import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/sleep_controller/sleep_controller.dart';
import 'package:music_mind_client/view/widgets/courses_widget.dart';

class Sleep extends StatefulWidget {
  @override
  State<Sleep> createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  final SleepController _sleepController = Get.put(SleepController());
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _sleepController.getCourses();
      _isLoading = false;
      if(mounted){
        setState(() {
          // Update your UI with the desired changes.
          return;
        });
      }
    } ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : CoursesWidget(controller: _sleepController);;
  }
}
