import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/profile_controller/profile_controller.dart';
import 'package:music_mind_client/view/widgets/my_app_bar.dart';
import 'package:music_mind_client/view/widgets/my_button.dart';
import 'package:music_mind_client/view/widgets/my_text_field.dart';

class Account extends StatefulWidget {

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var _isLoading = true;
  File? imageFile;
  final ProfileController controller = Get.put(ProfileController());
  var image;

  @override
  void initState() {
    // Create anonymous function:
        () async {
          image = await controller.getImageFromStorage('${Get.find<AuthController>().getUserId()}');

      _isLoading = false;
      if(mounted){
        setState(() {
          // Update your UI with the desired changes.
        });
      }
    } ();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account',
      ),
      body: _isLoading ?
      Center(child: CircularProgressIndicator(color: Colors.white,),):
      ListView(
        physics: const ClampingScrollPhysics(),
        padding: defaultPadding,
        children: [
          GestureDetector(
            onTap: () async{
              final res = await controller.uploadImage();
                if(res != null) {
                      Get.back();
                      Get.to(() => Account());
                    }
                  },
            child: Stack(
              alignment: Alignment.center,
              children: [
                image == null ? Image.asset(
                  'assets/unsplash3JmfENcL24M.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ): Image.memory(
                  image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/camera.png',
                  height: 38,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          MyTextField(
              label: 'Display Name',
              hintText: '${controller.userData['display_name']}',
              controller: controller.displayNameController_p),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
              label: 'First Name',
              hintText: '${controller.userData['first_name']}',
              controller: controller.firstNameController_p),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
              label: 'Last Name',
              hintText: '${controller.userData['last_name']}',
              controller: controller.lastNameController_p),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
            label: 'Email',
            hintText: '${controller.userData['email']}',
            controller: controller.emailController_p,
          ),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
              label: 'Phone',
              hintText: '${controller.userData['phone'] ?? 'Add your phone'}',
              controller: controller.phoneController_p),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
              maxlines: 10,
              label: 'About',
              hintText:'${controller.userData['about'] ?? 'Introduce yourself...'}',
              controller: controller.aboutController_p),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: KPrimaryColor,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyButton(
                onPressed: () async {
                  final res = await controller.updateProfile();
                  res == 200 ? Get.to(() => Account()): '';
                },
                text: 'Save',
                btnBgColor: KSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
