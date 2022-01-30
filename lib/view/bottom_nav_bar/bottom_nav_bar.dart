import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/bottom_nav_bar_controller/bottom_nav_bar_controller.dart';
import 'package:music_mind_client/controller/home_controller/body_controller/body_controller.dart';
import 'package:music_mind_client/controller/home_controller/learn_controller/learn_controller.dart';
import 'package:music_mind_client/controller/home_controller/mind_Controller/mind_controller.dart';
import 'package:music_mind_client/controller/home_controller/sleep_controller/sleep_controller.dart';
import 'package:music_mind_client/controller/home_controller/work_controller/work_controller.dart';
import 'package:music_mind_client/view/drawer/drawer.dart';
import 'package:music_mind_client/view/widgets/my_app_bar.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';
import 'package:music_mind_client/view/widgets/offer_card.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final MindController _mindController = Get.put(MindController());
  final BodyController _bodyController = Get.put(BodyController());
  final SleepController _sleepController = Get.put(SleepController());
  final LearnController _learnController = Get.put(LearnController());
  final WorkController _workController = Get.put(WorkController());

  var _isLoading = true;

  @override
  void initState(){
        () async {
      print('hello there **********');
          if (Get.find<AuthController>().user != null) {
            print('hello there **********');
            await _mindController.getCourses();
            await _bodyController.getCourses();
            await _sleepController.getCourses();
            await _learnController.getCourses();
            await _workController.getCourses();
             _isLoading = false;
          }
      await Future.delayed(Duration(milliseconds: 400));
        _isLoading = false;
        if(mounted){
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
    return _isLoading ? Scaffold(backgroundColor: KPrimaryColor,body: Center(child: CircularProgressIndicator(color: Colors.white,),),)
        : GetBuilder<BottomNavBarController>(
      init: BottomNavBarController(),
      builder: (controller) => Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(
          scaffoldKey: scaffoldKey,
        ),
        drawer: MyDrawer(),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                const OfferCard(),
                controller.screens[controller.currentIndex],
              ],
            ),
            CurrentPlaying(
              controller: controller.currentCategory,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: KSecondaryColor,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          currentIndex: controller.currentIndex,
          onTap: (index) {
            controller.currentScreen(index);
            controller.currentCategoryController(index);
          },
          backgroundColor: KPrimaryColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bxbxs-brain.png',
                color: controller.currentIndex == 0
                    ? KSecondaryColor
                    : KGrey2Color,
                height: 28,
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: MyText(
                  text: 'Mind',
                  color: controller.currentIndex == 0
                      ? KSecondaryColor
                      : KGrey2Color,
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/1.png',
                color: controller.currentIndex == 1
                    ? KSecondaryColor
                    : KGrey2Color,
                height: 28,
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: MyText(
                  text: 'Body',
                  color: controller.currentIndex == 1
                      ? KSecondaryColor
                      : KGrey2Color,
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/2.png',
                color: controller.currentIndex == 2
                    ? KSecondaryColor
                    : KGrey2Color,
                height: 28,
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: MyText(
                  text: 'Sleep',
                  color: controller.currentIndex == 2
                      ? KSecondaryColor
                      : KGrey2Color,
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/bibook-half.png',
                color: controller.currentIndex == 3
                    ? KSecondaryColor
                    : KGrey2Color,
                height: 28,
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: MyText(
                  text: 'Learn',
                  color: controller.currentIndex == 3
                      ? KSecondaryColor
                      : KGrey2Color,
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/claritysettings-solid.png',
                color: controller.currentIndex == 4
                    ? KSecondaryColor
                    : KGrey2Color,
                height: 28,
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: MyText(
                  text: 'Work',
                  color: controller.currentIndex == 4
                      ? KSecondaryColor
                      : KGrey2Color,
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentPlaying extends StatelessWidget {
  var controller;

  CurrentPlaying({
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return controller.coursesData.isEmpty ? Center(child:Text('No Courses yet', style: TextStyle(color: Colors.white, fontSize: 15),)) : Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 5,
        color: KSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: defaultPadding,
        child: ListTile(
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Image.asset(
            '${controller.coursesData[controller.currentIndex].courseIcon}',
            height: 36,
          ),
          title: MyText(
            text:
                '${controller.coursesData[controller.currentIndex].courseType}',
            size: 16,
            color: KBlackColor,
            weight: FontWeight.w700,
          ),
          subtitle: MyText(
            text:
                '${controller.coursesData[controller.currentIndex].levelName} | ${controller.coursesData[controller.currentIndex].missionName}',
            size: 12,
            maxlines: 2,
            color: KGreyColor,
            weight: FontWeight.w700,
          ),
          trailing: Image.asset(
            'assets/biplay-fill.png',
            color: KBlackColor,
            height: 30,
          ),
        ),
      ),
    );
  }
}
