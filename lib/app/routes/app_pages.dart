import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hifi/modules/auth/bindings/auth_binding.dart';
import 'package:hifi/modules/auth/views/signin_view.dart';
import 'package:hifi/modules/auth/views/signup_view.dart';
import 'package:hifi/modules/auth/views/forgot_password_view.dart';
import 'package:hifi/modules/home/bindings/home_binding.dart';
import 'package:hifi/modules/home/views/home_view.dart';
import 'package:hifi/modules/chat/bindings/chat_binding.dart';
import 'package:hifi/modules/chat/views/chat_view.dart';
import 'package:hifi/modules/explore/bindings/explore_binding.dart';
import 'package:hifi/modules/explore/views/explore_view.dart';
import 'package:hifi/modules/integrations/bindings/integrations_binding.dart';
import 'package:hifi/modules/integrations/views/integrations_view.dart';
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
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
      preventDuplicates: false,
    ),
    GetPage(
      name: Routes.explore,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: Routes.integrations,
      page: () => const IntegrationsView(),
      binding: IntegrationsBinding(),
    ),
  ];
}