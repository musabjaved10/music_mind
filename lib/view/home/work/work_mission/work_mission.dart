import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/work_controller/work_mission_controller/work_mission_controller.dart';
import 'package:music_mind_client/view/widgets/mission_widget.dart';

class WorkMission extends StatefulWidget {
  @override
  State<WorkMission> createState() => _WorkMissionState();
}

class _WorkMissionState extends State<WorkMission> {
  final WorkMissionController _workMissionController =
  Get.put(WorkMissionController());

  var levelId = Get.arguments;
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      _isLoading = true;
      await _workMissionController.getMissions(levelId[0]);
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
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : MissionsWidget(controller: _workMissionController),
    );
  }
}
