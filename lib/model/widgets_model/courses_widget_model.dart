
// This Model is used for Entire Courses
import 'package:flutter/cupertino.dart';

class CoursesWidgetModel {
  var courseId, courseIcon, courseType, levelName,missionName, courseName;
  List<CoursesThumbnailsModel>? coursesThumbnailData;
  // VoidCallback? onTap;

  CoursesWidgetModel({
    this.courseId,
    this.courseIcon,
    this.courseType,
    this.levelName,
    this.missionName,
    this.courseName,
    this.coursesThumbnailData,
    // this.onTap,
  });
}

class CoursesThumbnailsModel{
  var courseThumbnail, levelName, levelId;
  bool? levelCompleted;

  CoursesThumbnailsModel({
    this.courseThumbnail,
    this.levelName,
    this.levelId,
    this.levelCompleted = false,
  });
}
