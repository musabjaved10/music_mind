import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/login.dart';


class Root extends GetWidget<AuthController> {
@override
Widget build(BuildContext context) {
  return Obx((){
    return Get.find<AuthController>().user!=null ? BottomNavBar() : Login();
  });
}
}
