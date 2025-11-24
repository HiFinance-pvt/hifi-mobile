import 'package:get/get.dart';
import 'package:hifi/modules/auth/bindings/auth_binding.dart';
import 'package:hifi/modules/auth/views/signin_view.dart';
import 'package:hifi/modules/auth/views/signup_view.dart';
import 'package:hifi/modules/auth/views/forgot_password_view.dart';
import 'app_routes.dart';

class AppPages {
  static const String initial = Routes.signin;

  static final routes = [
    GetPage(
      name: Routes.signin,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
  ];
}