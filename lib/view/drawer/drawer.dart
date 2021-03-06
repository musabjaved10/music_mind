import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/profile_controller/profile_controller.dart';
import 'package:music_mind_client/view/profile/account.dart';
import 'package:music_mind_client/view/profile/subscriptions_pricing.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool? profileVisibility = false;
  AuthController _authController = Get.find<AuthController>();
  var image;
  @override
  void initState(){
        () async {
      await _authController.getUserData();
      image = await Get.find<ProfileController>().getImageFromStorage('${Get.find<AuthController>().getUserId()}');

      if(mounted) {
        setState(() {
          null;
          return;
        });
      }
    } ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.9,
      child: Drawer(
        child: Container(
          color: KPrimaryColor,
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                title: MyText(
                  text: _authController.userData['display_name'],
                  size: 18,
                  weight: FontWeight.w600,
                ),
                subtitle: MyText(
                  text: 'Join date: Jan 2022',
                  color: KGreyColor,
                  size: 12,
                ),
                trailing: image == null ? Image.asset(
                  'assets/unsplash3JmfENcL24M.png',
                  height: 56,
                  width: 56,
                  fit: BoxFit.cover,
                ): Image.memory(
                  image,
                  height: 56,
                  width: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: MyText(
                  text: 'PERSONAL'.toUpperCase(),
                  size: 10,
                ),
              ),
              ListTile(
                onTap: () => Get.to(() => Account()),
                title: MyText(
                  text: 'Account',
                  size: 16,
                  weight: FontWeight.w600,
                ),
                subtitle: MyText(
                  text: 'Setup account information',
                  color: KGreyColor,
                  size: 12,
                ),
                trailing: Image.asset(
                  'assets/arrow_forward.png',
                  height: 15,
                ),
              ),
              // ListTile(
              //   onTap: () {},
              //   title: MyText(
              //     text: 'Profile Visibiity',
              //     size: 16,
              //     weight: FontWeight.w600,
              //   ),
              //   subtitle: MyText(
              //     text: 'Show profile information to public',
              //     color: KGreyColor,
              //     size: 12,
              //   ),
              //   trailing: Switch(
              //     onChanged: (value) {
              //       setState(() {
              //         profileVisibility = !profileVisibility!;
              //       });
              //     },
              //     value: profileVisibility!,
              //     activeColor: KGreenColor,
              //     activeTrackColor: KSecondaryColor,
              //     inactiveTrackColor: KGreyColor,
              //   ),
              // ),
              // ListTile(
              //   onTap: () {},
              //   title: MyText(
              //     text: 'Blocked Members',
              //     size: 16,
              //     weight: FontWeight.w600,
              //   ),
              //   trailing: Image.asset(
              //     'assets/arrow_forward.png',
              //     height: 15,
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: MyText(
                  text: 'PAYMENT'.toUpperCase(),
                  size: 10,
                ),
              ),
              ListTile(
                onTap: () => Get.to(
                  () => SubscriptionsPricing(),
                ),
                title: MyText(
                  text: 'Subscriptions',
                  size: 16,
                  weight: FontWeight.w600,
                ),
                subtitle: MyText(
                  text: 'View and manage the subscriptions you\'ve purchased',
                  color: KGreyColor,
                  size: 12,
                ),
                trailing: Image.asset(
                  'assets/arrow_forward.png',
                  height: 15,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // ListTile(
              //   onTap: () {},
              //   title: MyText(
              //     text: 'About Apps',
              //     size: 16,
              //     weight: FontWeight.w600,
              //   ),
              //   trailing: Image.asset(
              //     'assets/arrow_forward.png',
              //     height: 15,
              //   ),
              // ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: (){
                  _authController.signOut();
                },
                child: MyText(
                  text: 'Logout',
                  size: 14,
                  weight: FontWeight.w700,
                  color: const Color(0xffEA4335),
                  align: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
