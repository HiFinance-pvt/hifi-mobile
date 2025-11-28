import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/services/auth_service.dart';
import 'package:hifi/controllers/session_controller.dart';
import 'package:hifi/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final SessionController _sessionController = Get.find<SessionController>();
  late final FocusNode messageFocusNode;
  final messageController = TextEditingController();

  final userEmail = ''.obs;
  final signInMethod = ''.obs;
  final authToken = ''.obs;
  final userName = 'John'.obs;

  @override
  void onInit() {
    super.onInit();
    messageFocusNode = FocusNode();
    messageFocusNode.addListener(() {
      print('🔍 HomeController: Focus changed - hasFocus: ${messageFocusNode.hasFocus}');
    });
    _loadUserInfo();
  }

  @override
  void onClose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }
  
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

  Future<void> sendMessageFromDashboard() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Create new session and navigate to chat with initial message
    final sessionId = await _sessionController.createNewSession();
    if (sessionId != null) {
      messageController.clear();
      Get.toNamed('/chat', arguments: {'sessionId': sessionId, 'initialMessage': text});
    }
  }

  void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF161313),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF4F4A4A),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF3461FD)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3461FD),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3461FD),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
