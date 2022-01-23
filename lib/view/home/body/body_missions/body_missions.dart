import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/home_controller/body_controller/body_mission_controller/body_mission_controller.dart';
import 'package:music_mind_client/view/widgets/mission_widget.dart';

class BodyMissions extends StatefulWidget {

  @override
  State<BodyMissions> createState() => _BodyMissionsState();
}

class _BodyMissionsState extends State<BodyMissions> {
  final BodyMissionController _bodyMissionController =
  Get.put(BodyMissionController());
  var levelId = Get.arguments;
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _bodyMissionController.getMissions(levelId[0]);
      _isLoading = false;
      setState(() {
        // Update your UI with the desired changes.
        return;
      });
    } ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Image.asset(
              'assets/arrow_Back.png',
              height: 15,
            ),
          ),
        ),
      ),
      backgroundColor: KPrimaryColor,
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : MissionsWidget(controller: _bodyMissionController),
    );
  }
}
