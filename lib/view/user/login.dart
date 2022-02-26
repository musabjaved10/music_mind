import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/user/register.dart';
import 'package:music_mind_client/view/widgets/my_button.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';
import 'package:music_mind_client/view/widgets/my_text_field.dart';

class Login extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            heading('Login'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  label: 'Email',
                  hintText:  controller.emailController.text.isEmpty ?'email@example.com' : controller.emailController.text,
                  controller: controller.emailController,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextField(
                  label: 'Password',
                  hintText: controller.passController.text.isEmpty ? '********': '*' * controller.passController.text.length,
                  controller: controller.passController,
                  inputIcon: const Icon(Icons.visibility),
                ),
                GestureDetector(
                  onTap: () => controller.resetPassword(),
                  child: MyText(
                    text: 'Forgot Password?',
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            MyButton(
              onPressed: () {controller.login(controller.emailController.text, controller.passController.text);},
              text: 'Login',
            ),
            // MyText(
            //   text: 'or continue with',
            //   size: 14,
            //   align: TextAlign.center,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Image.asset(
            //       'assets/Group.png',
            //       height: 28,
            //     ),
            //     const SizedBox(
            //       width: 30,
            //     ),
            //     Image.asset(
            //       'assets/Group 17.png',
            //       height: 28,
            //     ),
            //   ],
            // ),
            GestureDetector(
              onTap: () => Get.to(() => Register()),
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
                      text: 'Don’t have an account?',
                    ),
                    TextSpan(
                      text: ' Register',
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
      ),
    );
  }
}
