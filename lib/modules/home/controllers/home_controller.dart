import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/services/auth_service.dart';
import 'package:hifi/services/news_service.dart';
import 'package:hifi/services/stocks_service.dart';
import 'package:hifi/controllers/session_controller.dart';
import 'package:hifi/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final SessionController _sessionController = Get.find<SessionController>();
  final NewsService _newsService = NewsService();
  final StocksService _stocksService = StocksService();
  late final FocusNode messageFocusNode;
  final messageController = TextEditingController();

  final userEmail = ''.obs;
  final signInMethod = ''.obs;
  final authToken = ''.obs;
  final userName = 'John'.obs;
  final newsItems = <Map<String, dynamic>>[].obs;
  final isLoadingNews = false.obs;
  final trendingStocks = <Map<String, dynamic>>[].obs;
  final isLoadingStocks = false.obs;

  @override
  void onInit() {
    super.onInit();
    messageFocusNode = FocusNode();
    messageFocusNode.addListener(() {
      print('🔍 HomeController: Focus changed - hasFocus: ${messageFocusNode.hasFocus}');
    });
    _loadUserInfo();
    _loadNews();
    _loadStocks();
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

  Future<void> _loadNews() async {
    try {
      isLoadingNews.value = true;
      final news = await _newsService.getIndianFinanceNews();
      newsItems.value = news;
    } catch (e) {
      print('❌ [HomeController] Failed to load news: $e');
      // Set fallback news
      newsItems.value = [
        {
          'title': 'Sensex rises 500 points on strong global cues',
          'source': 'Economic Times',
          'time': '2 hrs ago',
          'image': 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=200',
          'url': 'https://economictimes.indiatimes.com',
        },
        {
          'title': 'RBI keeps repo rate unchanged at 6.5%',
          'source': 'Business Standard',
          'time': '5 hrs ago',
          'image': 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=200',
          'url': 'https://www.business-standard.com',
        },
        {
          'title': 'Rupee strengthens against dollar',
          'source': 'Mint',
          'time': '8 hrs ago',
          'image': 'https://images.unsplash.com/photo-1580519542036-c47de6196ba5?w=200',
          'url': 'https://www.livemint.com',
        },
      ];
    } finally {
      isLoadingNews.value = false;
    }
  }

  Future<void> _loadStocks() async {
    try {
      isLoadingStocks.value = true;
      final stocks = await _stocksService.getIndianStocks();
      trendingStocks.value = stocks;
    } catch (e) {
      print('❌ [HomeController] Failed to load stocks: $e');
    } finally {
      isLoadingStocks.value = false;
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
                      onPressed: () => Navigator.of(Get.context!).pop(),
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
                        Navigator.of(Get.context!).pop();
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
