import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/home_controller/mind_Controller/mind_controller.dart';
import 'package:music_mind_client/model/widgets_model/courses_widget_model.dart';
import 'package:music_mind_client/view/widgets/courses_widget.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';

class Mind extends StatefulWidget {
  @override
  State<Mind> createState() => _MindState();
}

class _MindState extends State<Mind> {
  final MindController _mindController = Get.put(MindController());
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _mindController.getCourses();
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
    return _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : CoursesWidget(controller: _mindController);
  }
}
