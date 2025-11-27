import 'package:get/get.dart';
import 'package:hifi/services/auth_service.dart';
import 'package:hifi/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userEmail = ''.obs;
  final signInMethod = ''.obs;
  final authToken = ''.obs;
  final userName = 'John'.obs;
  
  // Mock data
  final usagePercentage = 68.0;
  final promptsUsed = 19;
  final promptsTotal = 30;
  final currentPlan = 'Personal';
  
  final suggestionChips = [
    'What can I buy in upcoming 30 days?',
    'Show me my spending trends',
  ];
  
  final trendingStocks = [
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'price': '₹2,509.75',
      'change': '+9.77%',
      'isPositive': true,
    },
    {
      'name': 'Cardano',
      'symbol': 'ADA',
      'price': '₹1,234.50',
      'change': '+5.23%',
      'isPositive': true,
    },
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'price': '₹2,509.75',
      'change': '+9.77%',
      'isPositive': true,
    },
  ];
  
  final newsItems = [
    {
      'title': 'Why Bitcoiners Are Rooting for This Latest China Mining Ban to Finally, Actually Be Real',
      'source': 'Decrypt',
      'time': '12 hrs ago',
    },
    {
      'title': 'Why Bitcoiners Are Rooting for This Latest China Mining Ban to Finally, Actually Be Real',
      'source': 'Decrypt',
      'time': '12 hrs ago',
    },
    {
      'title': 'Why Bitcoiners Are Rooting for This Latest China Mining Ban to Finally, Actually Be Real',
      'source': 'Decrypt',
      'time': '12 hrs ago',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final user = _authService.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? 'No email';
      userName.value = user.displayName ?? user.email?.split('@')[0] ?? 'User';
      
      if (user.providerData.any((info) => info.providerId == 'google.com')) {
        signInMethod.value = 'Google Sign-In';
      } else {
        signInMethod.value = 'Email/Password';
      }
      
      try {
        final token = await user.getIdToken();
        if (token != null && token.isNotEmpty) {
          final maskedToken = token.length > 12 
              ? '${token.substring(0, 6)}****${token.substring(token.length - 6)}'
              : '${token.substring(0, 3)}****${token.substring(token.length - 3)}';
          authToken.value = maskedToken;
        } else {
          authToken.value = 'No token';
        }
      } catch (e) {
        authToken.value = 'Token error';
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(Routes.signin);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
