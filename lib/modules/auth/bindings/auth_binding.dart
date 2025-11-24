import 'package:get/get.dart';
import 'package:hifi/modules/auth/controllers/auth_controller.dart';
import 'package:hifi/services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}