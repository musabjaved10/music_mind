import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late TextEditingController fNameController, lNameController, emailController, passwordController;
  var firstName = '';
  var lastName = '';
  var email = '';
  var password = '';

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fNameController = TextEditingController();
    lNameController = TextEditingController();
  }


  @override
  void onClose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide valid Email";
    }
    return null;
  }
}