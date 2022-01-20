import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}