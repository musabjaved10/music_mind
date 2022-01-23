import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/body_controller/body_controller.dart';
import 'package:music_mind_client/view/widgets/courses_widget.dart';

class Boddy extends StatefulWidget {
  @override
  State<Boddy> createState() => _BoddyState();
}

class _BoddyState extends State<Boddy> {
  final BodyController _bodyController = Get.put(BodyController());
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _bodyController.getCourses();
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
    return _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : CoursesWidget(controller: _bodyController);;
  }
}
