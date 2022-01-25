import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/model/widgets_model/missions_model.dart';
import 'package:http/http.dart' as http;

class SleepMissionController extends GetxController {
  AuthController _authController = Get.find<AuthController>();
  var currentIndex = 0;
  List missions = [].obs;

  // List my_missions = [].obs;

  getMissions(levelId) async {
    final url = Uri.parse('${dotenv.env['db_url']}/level/$levelId');
    print(url);
    try {
      final res = await http.get(url, headers: {
        "uid": "${_authController.getUserId()}",
        "api-key": "${dotenv.env['api_key']}"
      });
      final resData = jsonDecode(res.body);
      if (resData['response'] == 200) {
        final level = resData['success']['data']['level'];
        final level_missions = resData['success']['data']['level']['missions'];
        print(level_missions);
        List<MissionsData> missionsList = [];
        await level_missions.forEach((mission) {
          // print(course['levels']);
          missionsList.add(MissionsData(
              thumbnail: "${dotenv.env['db_url']}${mission['display_pic']}",
              duration: mission['duration'],
              missionName: mission['name'],
              isCompleted: mission['is_completed'] == true && true,
              isLocked: mission['is_locked'] == true && true));
        });
        missions.add(MissionsModel(
            levelName: level['name'],
            tagLine: 'this is a tagline',
            missionsData: missionsList));
        // print(missions);
        return;

        // print(level_missions);

      } else if ((resData['response'] != 200) && (resData['errors'] != null)) {
        Get.snackbar('Error', resData['errors'].keys.toList().first,
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey);
      }
    } catch (e) {
      print('whoops');
      print(e);
    }
  }
}
