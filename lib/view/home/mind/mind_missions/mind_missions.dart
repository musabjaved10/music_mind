import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/mind_Controller/mind_missions_controller/mind_missions_controller.dart';
import 'package:music_mind_client/view/widgets/mission_widget.dart';

class MindMissions extends StatefulWidget {
  @override
  State<MindMissions> createState() => _MindMissionsState();
}

class _MindMissionsState extends State<MindMissions> {
  final MindMissionsController _mindMissionsController =
      Get.put(MindMissionsController());

  var levelId = Get.arguments;
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _mindMissionsController.getMissions(levelId[0]);
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
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : MissionsWidget(controller: _mindMissionsController),
    );
  }
}
