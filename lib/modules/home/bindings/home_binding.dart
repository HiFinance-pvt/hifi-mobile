import 'package:get/get.dart';
import 'package:hifi/modules/home/controllers/home_controller.dart';
import 'package:hifi/services/auth_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}