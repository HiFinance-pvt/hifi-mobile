import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hifi/app/routes/app_pages.dart';
import 'package:hifi/shared/themes/app_theme.dart';
import 'package:hifi/controllers/session_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(SessionController(), permanent: true);
  runApp(const HiFiApp());
}

class HiFiApp extends StatelessWidget {
  const HiFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HiFi',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}