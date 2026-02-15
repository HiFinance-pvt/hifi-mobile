import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntegrationsController extends GetxController {
  final integrationStates = <String, RxBool>{};

  IntegrationsController() {
    // Initialize states immediately
    for (var integration in integrations) {
      integrationStates[integration['name']!] = false.obs;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadIntegrationStates();
  }

  Future<void> _loadIntegrationStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (var integration in integrations) {
      final name = integration['name']!;
      final saved = prefs.getBool('integration_$name') ?? false;
      integrationStates[name]?.value = saved;
    }
  }

  Future<void> _saveIntegrationState(String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('integration_$name', value);
  }

  static const String _fiMcpSessionId = 'mcp-server-01399581-e861-4b3a-9973-f0215569e81a';

  Future<void> toggleIntegration(String name) async {
    final currentState = integrationStates[name]?.value ?? false;
    
    if (!currentState) {
      // Turning ON
      if (name == 'Fi Money') {
        final url = Uri.parse('https://fi-mcp.hifi.click/mockWebPage?sessionId=$_fiMcpSessionId');
        
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          integrationStates[name]?.value = true;
          await _saveIntegrationState(name, true);
        }
      } else if (name == 'Zerodha') {
        Get.snackbar(
          'Coming Soon',
          'Some issue occurred. Try again later!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Groww, Upstox, Splitwise
        Get.snackbar(
          'Coming Soon',
          'This integration will be available soon!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      // Turning OFF
      integrationStates[name]?.value = false;
      await _saveIntegrationState(name, false);
    }
  }

  final integrations = [
    {
      'name': 'Fi Money',
      'url': 'https://fi-mcp.hifi.click/',
      'description': 'Connect 18+ assets like mutual funds, stocks & EPF instantly. Authorize Fi MCP to fetch your Net Worth details and start asking questions!',
      'logo': 'assets/images/fi_money_logo.png',
      'status': 'active',
    },
    {
      'name': 'Zerodha',
      'url': 'https://zerodha.com',
      'description': 'Online stock brokerage platform for trading and investing in stocks, futures, options, commodities, currency, ETFs, mutual funds, and bonds.',
      'logo': 'assets/images/zerodha_logo.png',
      'status': 'coming_soon',
    },
    {
      'name': 'Grow',
      'url': 'https://groww.in',
      'description': 'Start Online Investing in Stocks & Direct Mutual Funds with India\'s No. 1 Stock Broker - Groww. Equity Trading, F&O, Direct Mutual Funds with ...',
      'logo': 'assets/images/grow_logo.png',
      'status': 'coming_soon',
    },
    {
      'name': 'Upstox',
      'url': 'https://upstox.com',
      'description': 'A faster Investment & Trading Platform: Low brokerage, High service standards.',
      'logo': 'assets/images/upstox_logo.png',
      'status': 'coming_soon',
    },
    {
      'name': 'Splitwise',
      'url': 'https://zerodha.com',
      'description': 'Online stock brokerage platform for trading and investing in stocks, futures, options, commodities, currency, ETFs, mutual funds, and bonds.',
      'logo': 'assets/images/splitwise_logo.png',
      'status': 'coming_soon',
    },
  ];
}
