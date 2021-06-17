class MastWorkListModel {
  String workID;
  String userID;
  String rsg;
  String ownerID;
  String mainWorkID;
  int subWorkID;
  int checklistID;
  String lat;
  String lng;
  String workPerform;
  String remark;
  int isChoice;
  String reason;
  String msgFromWeb;
  String createDate;
  String uploadDate;

  MastWorkListModel(
      {this.workID,
      this.userID,
      this.rsg,
      this.ownerID,
      this.mainWorkID,
      this.subWorkID,
      this.checklistID,
      this.lat,
      this.lng,
      this.workPerform,
      this.remark,
      this.isChoice,
      this.reason,
      this.msgFromWeb,
      this.createDate,
      this.uploadDate});

  MastWorkListModel.fromJson(Map<String, dynamic> json) {
    workID = json['work_ID'];
    userID = json['user_ID'];
    rsg = json['rsg'];
    ownerID = json['Owner_ID'];
    mainWorkID = json['mainWork_ID'];
    subWorkID = json['subWork_ID'];
    checklistID = json['checklist_ID'];
    lat = json['lat'];
    lng = json['lng'];
    workPerform = json['workPerform'];
    remark = json['remark'];
    isChoice = json['isChoice'];
    reason = json['reason'];
    msgFromWeb = json['msgFromWeb'];
    createDate = json['createDate'];
    uploadDate = json['uploadDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['work_ID'] = this.workID;
    data['user_ID'] = this.userID;
    data['rsg'] = this.rsg;
    data['Owner_ID'] = this.ownerID;
    data['mainWork_ID'] = this.mainWorkID;
    data['subWork_ID'] = this.subWorkID;
    data['checklist_ID'] = this.checklistID;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['workPerform'] = this.workPerform;
    data['remark'] = this.remark;
    data['isChoice'] = this.isChoice;
    data['reason'] = this.reason;
    data['msgFromWeb'] = this.msgFromWeb;
    data['createDate'] = this.createDate;
    data['uploadDate'] = this.uploadDate;
    return data;
  }
}//class
