import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/model/widgets_model/courses_widget_model.dart';
import 'package:music_mind_client/view/home/body/body_missions/body_missions.dart';
import 'package:music_mind_client/view/widgets/my_text.dart';

class CoursesWidget extends StatelessWidget {
  CoursesWidget({
    this.controller,
  });

  var controller;

  @override
  Widget build(BuildContext context) {
    return  Obx(
      () {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.coursesData.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            var courseData = controller.coursesData[index];
            return SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 20),
                    child: Row(
                      children: [
                        MyText(
                          text: '${courseData.courseName}',
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                        courseData.isCourseComplete == true ? Image.asset(
                          'assets/akar-iconscircle-check.png',
                          height: 16,
                        ): const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: courseData.coursesThumbnailData!.length,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        CoursesThumbnailsModel thumbnails =
                            courseData.coursesThumbnailData![index];
                        return GestureDetector(
                          onTap: (){
                            Get.to(()=> BodyMissions(), arguments: [thumbnails.levelId]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 7, right: 7, bottom: 40),
                            width: 140,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: EdgeInsets.zero,
                                    color: KPrimaryColor,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        '${thumbnails.courseThumbnail}',
                                        fit: BoxFit.cover,
                                        width: Get.width,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: '${thumbnails.levelName}',
                                        size: 16,
                                        weight: FontWeight.w600,
                                      ),
                                      thumbnails.levelCompleted == true
                                          ? Image.asset(
                                              'assets/akar-iconscircle-check.png',
                                              height: 16,
                                            )
                                          : thumbnails.levelLocked == true ?
                                      Image.asset(
                                              'assets/lock.png',
                                              height: 16,
                                            )
                                          :Image.asset(
                                        'assets/progress-icon.png',
                                        height: 16,
                                      )
                                      ,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
