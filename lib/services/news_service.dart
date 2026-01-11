import 'package:dio/dio.dart';

class NewsService {
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> getIndianFinanceNews() async {
    try {
      // Using GNews free API - no key needed for basic usage
      final response = await _dio.get(
        'https://gnews.io/api/v4/search',
        queryParameters: {
          'q': 'india finance OR stock market OR economy',
          'lang': 'en',
          'country': 'in',
          'max': 10,
          'apikey': 'fa78323ba4ea2ef682aa79c1b24cd59d',
        },
      );

      if (response.statusCode == 200) {
        final articles = response.data['articles'] as List? ?? [];
        return articles.map((article) => {
          'title': article['title'] ?? '',
          'source': article['source']?['name'] ?? 'Unknown',
          'time': _formatTime(article['publishedAt']),
          'url': article['url'] ?? '',
          'image': article['image'] ?? '',
        }).toList();
      }
      return _getFallbackNews();
    } catch (e) {
      print('❌ [NewsService] Error: $e');
      return _getFallbackNews();
    }
  }

  String _formatTime(String? publishedAt) {
    if (publishedAt == null) return '';
    try {
      final date = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inHours < 24) return '${diff.inHours} hrs ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}';
    } catch (e) {
      return '';
    }
  }

  List<Map<String, dynamic>> _getFallbackNews() {
    return [
      {
        'title': 'Sensex rises 500 points on strong global cues',
        'source': 'Economic Times',
        'time': '2 hrs ago',
      },
      {
        'title': 'RBI keeps repo rate unchanged at 6.5%',
        'source': 'Business Standard',
        'time': '5 hrs ago',
      },
      {
        'title': 'Rupee strengthens against dollar',
        'source': 'Mint',
        'time': '8 hrs ago',
      },
    ];
  }
}
