import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/home_controller/learn_controller/learn_controller.dart';
import 'package:music_mind_client/view/widgets/courses_widget.dart';

class Learn extends StatefulWidget {
  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  final LearnController _learnController = Get.put(LearnController());
  var _isLoading = true;

  @override
  void initState() {
    // Create anonymous function:
        () async {
      await _learnController.getCourses();
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
    return _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : CoursesWidget(controller: _learnController);
  }
}
