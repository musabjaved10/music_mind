import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/home_controller/mind_Controller/mind_controller.dart';
import 'package:music_mind_client/model/widgets_model/courses_widget_model.dart';
import 'package:music_mind_client/view/widgets/courses_widget.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';

class Mind extends StatelessWidget {
  final MindController _mindController = Get.put(MindController());

  @override
  Widget build(BuildContext context) {
    return CoursesWidget(controller: _mindController);
  }
}
