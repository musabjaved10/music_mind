import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/home_controller/body_controller/body_mission_controller/body_mission_controller.dart';
import 'package:music_mind_client/controller/video_controller/video_controller.dart';
import 'package:video_player/video_player.dart';

class MissionWindow extends StatefulWidget {
  @override
  State<MissionWindow> createState() => _MissionWindowState();
}

class _MissionWindowState extends State<MissionWindow> {
  final AuthController _authController = Get.find<AuthController>();
   VideoController controller = Get.put(VideoController());

  var missionId = Get.arguments;
  var mission;
  var _isLoading = false;

  @override
  void initState() {
    // Create anonymous function:
    () async {
      mission = await _authController.playMission(missionId[0]);
      if (mission == null) return;
      if (mission['video'] == null) {
        Get.back();
        Get.snackbar('Error', 'Video could not be played or does not exist.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        return;
      };
      try {
        final url = '${dotenv.env['db_url']}${mission['video']['video_url']}';
        await controller.initializePlayer(url);
      }catch(e){print('went wrong while playing video');}
      setState(() {
        // Update your UI with the desired changes.
        return;
      });
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: controller.chewieController != null &&
                  controller.chewieController!.videoPlayerController.value
                      .isInitialized
              ? Text(
                  '${mission['level']['name']}: ${mission['level']['course']['name']}')
              : const Text(''),
        ),
        body:  Center(
                child: controller.chewieController != null &&
                        controller.chewieController!.videoPlayerController.value
                            .isInitialized
                    ? Container(
                        height: size.height * 0.5,
                        child: Chewie(controller: controller.chewieController!))
                    : const Text(
                        'Please wait...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )));
  }
}
