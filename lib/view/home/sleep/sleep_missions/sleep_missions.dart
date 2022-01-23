import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/sleep_controller/sleep_mission_controller/sleep_mission_controller.dart';
import 'package:music_mind_client/view/widgets/mission_widget.dart';

class SleepMissions extends StatefulWidget {
  @override
  State<SleepMissions> createState() => _SleepMissionsState();
}

class _SleepMissionsState extends State<SleepMissions> {
  final SleepMissionController _sleepMissionController =
  Get.put(SleepMissionController());

  var levelId = Get.arguments;
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      _isLoading = true;
      await _sleepMissionController.getMissions(levelId[0]);
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
    return Scaffold(
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
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : MissionsWidget(controller: _sleepMissionController),
    );
  }
}
