import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/controller/auth_controllers/auth_controller.dart';
import 'package:music_mind_client/controller/home_controller/body_controller/body_mission_controller/body_mission_controller.dart';
import 'package:music_mind_client/controller/video_controller/video_controller.dart';
import 'package:music_mind_client/view/profile/subscriptions_pricing.dart';
import 'package:music_mind_client/view/widgets/my_button.dart';
import 'package:video_player/video_player.dart';

class MissionWindow extends StatefulWidget {
  @override
  State<MissionWindow> createState() => _MissionWindowState();
}

class _MissionWindowState extends State<MissionWindow> {
  final AuthController _authController = Get.find<AuthController>();
   VideoController controller = Get.put(VideoController());

  var missionId = Get.arguments;
  var mission, nextObj;

  @override
  void initState() {
    // Create anonymous function:
    () async {
      mission = await _authController.playMission(missionId[0]);
      nextObj = await _authController.getNext(missionId[0]);
      if (mission == null) return;
      if ( mission['video'] == null) {
        Get.back();
        Get.snackbar('Error', 'Video could not be played or does not exist.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.white);
        return;
      };
      try {
        if (mission != null) {
          final url = '${dotenv.env['db_url']}${mission['video']['video_url']}';
          await controller.initializePlayer(url);
        }
      }catch(e){print('went wrong while playing video');}
      if(mounted) {
        setState(() {
          // Update your UI with the desired changes.
          return;
        });
      }
    }();
    super.initState();
  }

  @override
  void dispose() {

    if (controller.chewieController != null && controller.chewieController!.isPlaying) {
      controller.chewieController!.pause();
      controller.chewieController!.removeListener(() {});
      controller.chewieController = null;
    }
    else if(controller.chewieController != null){
      controller.chewieController!.pause();
      controller.chewieController!.removeListener(() {});
      controller.chewieController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: controller.chewieController != null &&
                  controller.chewieController!.videoPlayerController.value
                      .isInitialized && mission !=null
              ? Text(
                  '${ mission['level']['name']}: ${mission['level']['course']['name']}')
              : const Text('')
        ),
        body:  Center(
                child: controller.chewieController != null &&
                        controller.chewieController!.videoPlayerController.value
                            .isInitialized
                    ? Column(
                      children: [
                        Text('Video title: ${mission != null ? mission['video']['title'] : 'waiting'}', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),),
                        SizedBox(height: size.height * 0.1,),
                        SizedBox(
                            height: size.height * 0.5,
                            child: Chewie(controller: controller.chewieController!)),
                        Text('${nextObj != null ? nextObj['message'] : 'waiting'}', style: TextStyle(color: Colors.white),),
                        const SizedBox(height: 10,),
                        nextObj != null && nextObj['url'] == 'subscriptions' ?
                        MyButton(
                          onPressed: () => Get.to(() => SubscriptionsPricing()),
                          text: '${nextObj['button_text']}',
                        ):
                        nextObj != null ?
                        MyButton(
                          onPressed: (){
                            final url = nextObj['url'];
                            final id = url.substring(url.length - 1);
                            Get.back();
                            Get.to(MissionWindow(), arguments: [id]);
                          },
                          text: '${nextObj['button_text']}',
                        ):
                            Text('')
                      ],
                    )
                    : const Text(
                        'Fetching...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )));
  }
}
