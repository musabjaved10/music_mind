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
  var missionId, thumbnail, missionName, duration;
  bool? isCompleted, isLocked;

  MissionsData({
    this.missionId,
    this.thumbnail,
    this.missionName,
    this.duration,
    this.isCompleted = false,
    this.isLocked = false
  });
}
