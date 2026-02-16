import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hifi/services/kite_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntegrationsController extends GetxController {
  final KiteService _kiteService = KiteService();
  final integrationStates = <String, RxBool>{};
  final isCheckingKiteStatus = false.obs;

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
    checkKiteStatus();
  }

  Future<void> _loadIntegrationStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (var integration in integrations) {
      final name = integration['name']!;
      if (name != 'Zerodha') {
        final saved = prefs.getBool('integration_$name') ?? false;
        integrationStates[name]?.value = saved;
      }
    }
  }

  Future<void> _saveIntegrationState(String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('integration_$name', value);
  }

  Future<void> checkKiteStatus() async {
    try {
      isCheckingKiteStatus.value = true;
      final status = await _kiteService.getStatus();
      
      // Check different possible response formats
      bool isConnected = false;
      if (status['connected'] == true) {
        isConnected = true;
      } else if (status['status'] == 'connected') {
        isConnected = true;
      }
      
      integrationStates['Zerodha']?.value = isConnected;
      print('🔗 [Kite] Status checked: $isConnected (from response: $status)');
    } catch (e) {
      print('⚠️ [Kite] Status check failed: $e');
      // If API doesn't exist yet, default to false
      integrationStates['Zerodha']?.value = false;
    } finally {
      isCheckingKiteStatus.value = false;
    }
  }

  Future<void> refreshIntegrations() async {
    await checkKiteStatus();
  }

  static const String _fiMcpSessionId = 'mcp-server-01399581-e861-4b3a-9973-f0215569e81a';

  Future<void> toggleIntegration(String name) async {
    if (name == 'Zerodha') {
      await _toggleKiteIntegration();
      return;
    }
    
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
      } else {
        // Other integrations
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

  Future<void> _toggleKiteIntegration() async {
    final currentState = integrationStates['Zerodha']?.value ?? false;
    
    try {
      if (currentState) {
        // Disconnect
        await _disconnectKite();
      } else {
        // Connect
        await _connectKite();
      }
    } catch (e) {
      print('❌ [Kite] Toggle failed: $e');
      
      // Check if it's a 404 or server error (API not ready)
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('404') || errorString.contains('server error')) {
        Get.snackbar(
          'Coming Soon',
          'Zerodha integration is being prepared. Try again later!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to ${currentState ? 'disconnect from' : 'connect to'} Zerodha',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _connectKite() async {
    try {
      final response = await _kiteService.connect();
      
      // Try different possible locations for the redirect URL
      String? redirectUrl = response['redirect_url']?.toString();
      if (redirectUrl == null || redirectUrl.isEmpty) {
        redirectUrl = response['data']?['url']?.toString();
      }
      
      print('🔗 [Kite] Extracted redirect URL: $redirectUrl');
      
      if (redirectUrl != null && redirectUrl.isNotEmpty) {
        // Launch external browser
        final uri = Uri.parse(redirectUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          
          Get.snackbar(
            'Redirecting',
            'Opening Zerodha login in browser...',
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Check status after a delay to see if connection succeeded
          Future.delayed(const Duration(seconds: 3), () {
            checkKiteStatus();
          });
        } else {
          throw 'Could not launch browser';
        }
      } else {
        throw 'No redirect URL received from server';
      }
    } catch (e) {
      print('❌ [Kite] Connect failed: $e');
      rethrow; // Let the toggle handler deal with error messages
    }
  }

  Future<void> _disconnectKite() async {
    try {
      await _kiteService.disconnect();
      integrationStates['Zerodha']?.value = false;
      
      Get.snackbar(
        'Success',
        'Disconnected from Zerodha',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ [Kite] Disconnect failed: $e');
      rethrow;
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
      'status': 'active',
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
