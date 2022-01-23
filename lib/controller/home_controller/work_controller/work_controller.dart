import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/model/widgets_model/courses_widget_model.dart';
import 'package:music_mind_client/view/home/work/work_mission/work_mission.dart';
import 'package:http/http.dart' as http;


class WorkController extends GetxController {
  AuthController _authController = Get.find<AuthController>();
  int currentIndex = 0;
  List my_courses = [].obs;
  List coursesData = [].obs;


  getCourses() async{
    final url = Uri.parse('${dotenv.env['db_url']}/category/4');

    try{
      final res = await http.get(url, headers: {"uid": "${_authController.getUserId()}"});
      final resData = jsonDecode(res.body);
      if(resData['response'] == 200){
        final courses = resData['success']['data']['category']['courses'];

        // for (int i = 0; i < courses.length; i++) {
        //   CoursesWidgetModel(
        //     courseIcon: 'assets/bxbxs-brain.png',
        //     courseType: 'Mind',
        //     levelName: 'Level ${i+1}',
        //     missionName: 'Mission A',
        //     courseName: course['name'],
        //   );
        // }

        await courses.forEach((course) {
          List<CoursesThumbnailsModel> coursesThumbnailList = [];
          // print(course['levels']);
          course['levels'].forEach((level){
            coursesThumbnailList.add(CoursesThumbnailsModel(courseThumbnail:level['display_pic'] ,levelName:level['name'], levelCompleted:level['is_completed'] == 'true'? true:false ));
          });//inside foreach ends
          my_courses.add(CoursesWidgetModel(
              courseIcon: 'assets/claritysettings-solid.png',
              courseType: 'Work',
              levelName: 'Level 1',
              missionName: 'Mission A',
              courseName: course['name'],
              // onTap: () => Get.to(() => WorkMission()),
              coursesThumbnailData: coursesThumbnailList));
        });
        coursesData = my_courses;
        // print(coursesData);
      }else if((resData['response'] !=200) && (resData['errors'] != 'None')){
        Get.snackbar('Error', resData['errors'].keys.toList().first, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey );
      }
    }catch(e){
      print('whoops');
      print(e);
    }

  }
}
