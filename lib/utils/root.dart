import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/home_controller/body_controller/body_controller.dart';
import 'package:music_mind_client/controller/home_controller/learn_controller/learn_controller.dart';
import 'package:music_mind_client/controller/home_controller/mind_Controller/mind_controller.dart';
import 'package:music_mind_client/controller/home_controller/sleep_controller/sleep_controller.dart';
import 'package:music_mind_client/controller/home_controller/work_controller/work_controller.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:music_mind_client/view/user/register.dart';

class Root extends StatefulWidget {
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  var _isLoading = false;
  @override
  void initState() {
    _isLoading = true;
    () async {
      // print('hello there **********');
      await Future.delayed(Duration(seconds: 1));
      _isLoading = false;
      if(mounted) {
        setState(() {
          // Update your UI with the desired changes.
          return;
        });
      }

    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Get.find<AuthController>().user == null
          ? Login()
          : _isLoading
              ? Scaffold(
                  body: Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                )
              : BottomNavBar();
    });
  }
}
