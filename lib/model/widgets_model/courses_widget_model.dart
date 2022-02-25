
// This Model is used for Entire Courses
import 'package:flutter/cupertino.dart';

class CoursesWidgetModel {
  var courseId, courseIcon, courseType, levelName,missionName, courseName, isCourseComplete;
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
    this.isCourseComplete
    // this.onTap,
  });
}

class CoursesThumbnailsModel{
  var courseThumbnail, levelName, levelId;
  bool? levelCompleted, levelLocked;

  CoursesThumbnailsModel({
    this.courseThumbnail,
    this.levelName,
    this.levelId,
    this.levelCompleted = false,
    this.levelLocked = true
  });
}
