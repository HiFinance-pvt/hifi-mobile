import 'package:dio/dio.dart';

class StocksService {
  final Dio _dio = Dio();
  // Free Finnhub API key - replace with your own from finnhub.io
  final String _apiKey = 'd5higdpr01qqequ2mkqgd5higdpr01qqequ2mkr0';

  Future<List<Map<String, dynamic>>> getIndianStocks() async {
    try {
      // Popular Indian stocks on NSE
      final symbols = [
        {'symbol': 'RELIANCE.NS', 'name': 'Reliance'},
        {'symbol': 'TCS.NS', 'name': 'TCS'},
        {'symbol': 'INFY.NS', 'name': 'Infosys'},
        {'symbol': 'HDFCBANK.NS', 'name': 'HDFC Bank'},
        {'symbol': 'ICICIBANK.NS', 'name': 'ICICI Bank'},
      ];
      
      final stocks = <Map<String, dynamic>>[];

      for (final stock in symbols) {
        try {
          final response = await _dio.get(
            'https://finnhub.io/api/v1/quote',
            queryParameters: {
              'symbol': stock['symbol'],
              'token': _apiKey,
            },
          );

          if (response.statusCode == 200 && response.data['c'] != null) {
            final currentPrice = response.data['c'] as num;
            final previousClose = response.data['pc'] as num;
            final change = currentPrice - previousClose;
            final changePercent = (change / previousClose) * 100;

            stocks.add({
              'name': stock['name'],
              'symbol': (stock['symbol'] as String).replaceAll('.NS', ''),
              'price': '₹${currentPrice.toStringAsFixed(2)}',
              'change': '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
              'isPositive': changePercent >= 0,
            });
          }
        } catch (e) {
          print('❌ [StocksService] Error fetching ${stock['symbol']}: $e');
        }
      }

      return stocks.isNotEmpty ? stocks : _getFallbackStocks();
    } catch (e) {
      print('❌ [StocksService] Error: $e');
      return _getFallbackStocks();
    }
  }

  List<Map<String, dynamic>> _getFallbackStocks() {
    return [
      {
        'name': 'Reliance',
        'symbol': 'RELIANCE',
        'price': '₹2,509.75',
        'change': '+2.45%',
        'isPositive': true,
      },
      {
        'name': 'TCS',
        'symbol': 'TCS',
        'price': '₹3,845.20',
        'change': '+1.23%',
        'isPositive': true,
      },
      {
        'name': 'Infosys',
        'symbol': 'INFY',
        'price': '₹1,678.90',
        'change': '-0.85%',
        'isPositive': false,
      },
    ];
  }
}
