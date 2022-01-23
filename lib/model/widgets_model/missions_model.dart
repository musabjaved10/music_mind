class MissionsModel {
  var levelName, tagLine;
  List<MissionsData>? missionsData;

  MissionsModel({
    this.levelName,
    this.tagLine,
    this.missionsData,
  });
}

class MissionsData {
  var thumbnail, missionName, duration, isLocked;
  bool? isCompleted;

  MissionsData({
    this.isLocked,
    this.thumbnail,
    this.missionName,
    this.duration,
    this.isCompleted = false,
  });
}
