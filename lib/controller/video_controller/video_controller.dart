import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController{
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void onInit(){
    super.onInit();
  }

  @override
  void onClose(){
    videoPlayerController.dispose();
    chewieController?.dispose();
  }

  Future<void> initializePlayer(url) async{
    videoPlayerController = VideoPlayerController.network('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4');
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        materialProgressColors: ChewieProgressColors(
          handleColor: Colors.yellowAccent,
          playedColor: Colors.red,
          backgroundColor: KPrimaryColor
        ),
        autoInitialize: true
    );
    update();
  }

}