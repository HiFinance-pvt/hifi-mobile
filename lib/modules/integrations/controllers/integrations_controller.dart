import 'package:get/get.dart';

class IntegrationsController extends GetxController {
  final integrationStates = <String, RxBool>{};

  @override
  void onInit() {
    super.onInit();
    for (var integration in integrations) {
      integrationStates[integration['name']!] = false.obs;
    }
  }

  void toggleIntegration(String name) {
    integrationStates[name]?.toggle();
  }

  final integrations = [
    {
      'name': 'Zerodha',
      'url': 'https://zerodha.com',
      'description': 'Online stock brokerage platform for trading and investing in stocks, futures, options, commodities, currency, ETFs, mutual funds, and bonds.',
      'logo': 'assets/images/zerodha_logo.png',
    },
    {
      'name': 'Grow',
      'url': 'https://groww.in',
      'description': 'Start Online Investing in Stocks & Direct Mutual Funds with India\'s No. 1 Stock Broker - Groww. Equity Trading, F&O, Direct Mutual Funds with ...',
      'logo': 'assets/images/grow_logo.png',
    },
    {
      'name': 'Upstox',
      'url': 'https://upstox.com',
      'description': 'A faster Investment & Trading Platform: Low brokerage, High service standards.',
      'logo': 'assets/images/upstox_logo.png',
    },
    {
      'name': 'Splitwise',
      'url': 'https://zerodha.com',
      'description': 'Online stock brokerage platform for trading and investing in stocks, futures, options, commodities, currency, ETFs, mutual funds, and bonds.',
      'logo': 'assets/images/splitwise_logo.png',
    },
  ];
}
