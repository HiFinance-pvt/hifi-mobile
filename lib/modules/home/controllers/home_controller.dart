import 'package:get/get.dart';
import 'package:hifi/services/auth_service.dart';
import 'package:hifi/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userEmail = ''.obs;
  final signInMethod = ''.obs;
  final authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final user = _authService.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? 'No email';
      
      // Determine sign-in method
      if (user.providerData.any((info) => info.providerId == 'google.com')) {
        signInMethod.value = 'Google Sign-In';
      } else {
        signInMethod.value = 'Email/Password';
      }
      
      // Get and mask auth token
      try {
        final token = await user.getIdToken();
        if (token != null && token.isNotEmpty) {
          // Mask token: show first 6 and last 6 characters
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
      Get.snackbar('Error', 'Failed to sign out: ${e.toString()}');
    }
  }
}