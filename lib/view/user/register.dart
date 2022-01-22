import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:music_mind_client/view/widgets/my_button.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';
import 'package:music_mind_client/view/widgets/my_text_field.dart';

class Register extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        padding: defaultPadding,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 60,
          ),
          heading('Register'),
          const SizedBox(
            height: 60,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                label: 'First Name',
                hintText: 'Antonie',
                controller: controller.firstNameController,
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                label: 'Last Name',
                hintText: 'Robbinson',
                controller: controller.lastNameController,
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                label: 'Email',
                hintText: 'example@example.com',
                controller: controller.emailController,
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                label: 'Password',
                hintText: '********',
                obsecure: true,
                controller: controller.passController,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          controller.isLoading.value == 'true'
          ? Center(child: CircularProgressIndicator(color: Colors.white,),)
          : MyButton(
            onPressed: () {
              controller.registerUser(
                  controller.emailController.text,
                  controller.passController.text,
                  controller.firstNameController.text,
                  controller.lastNameController.text);
            },
            text: 'Register',
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () => Get.to(() => Login()),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  color: KGrey2Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: 'Already have an account?',
                  ),
                  TextSpan(
                    text: ' Login',
                    style: TextStyle(
                      color: KSecondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
