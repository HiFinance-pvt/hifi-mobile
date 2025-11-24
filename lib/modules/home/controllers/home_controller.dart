import 'package:get/get.dart';
import 'package:hifi/services/auth_service.dart';
import 'package:hifi/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userEmail = ''.obs;
  final signInMethod = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final user = _authService.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? 'No email';
      
      // Determine sign-in method
      if (user.providerData.any((info) => info.providerId == 'google.com')) {
        signInMethod.value = 'Google Sign-In';
      } else {
        signInMethod.value = 'Email/Password';
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