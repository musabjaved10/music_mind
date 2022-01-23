import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/work_controller/work_controller.dart';
import 'package:music_mind_client/view/widgets/courses_widget.dart';

class Work extends StatefulWidget {
  @override
  State<Work> createState() => _WorkState();
}

class _WorkState extends State<Work> {
  final WorkController _workController = Get.put(WorkController());
  var _isLoading = true;


  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _workController.getCourses();
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
    return _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : CoursesWidget(controller: _workController);;
  }
}
