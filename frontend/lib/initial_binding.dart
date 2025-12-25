import 'package:get/get.dart';

import 'package:news_app/app/auth/auth_controller.dart';
import 'package:news_app/services/api_services.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<ApiService>(ApiService());
  }
}
