import 'dart:convert';

class MastWorkListModel {
  int workID;
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

  MastWorkListModel({
    this.workID,
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
    this.uploadDate,
  });

  MastWorkListModel copyWith({
    int workID,
    String userID,
    String rsg,
    String ownerID,
    String mainWorkID,
    int subWorkID,
    int checklistID,
    String lat,
    String lng,
    String workPerform,
    String remark,
    int isChoice,
    String reason,
    String msgFromWeb,
    String createDate,
    String uploadDate,
  }) {
    return MastWorkListModel(
      workID: workID ?? this.workID,
      userID: userID ?? this.userID,
      rsg: rsg ?? this.rsg,
      ownerID: ownerID ?? this.ownerID,
      mainWorkID: mainWorkID ?? this.mainWorkID,
      subWorkID: subWorkID ?? this.subWorkID,
      checklistID: checklistID ?? this.checklistID,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      workPerform: workPerform ?? this.workPerform,
      remark: remark ?? this.remark,
      isChoice: isChoice ?? this.isChoice,
      reason: reason ?? this.reason,
      msgFromWeb: msgFromWeb ?? this.msgFromWeb,
      createDate: createDate ?? this.createDate,
      uploadDate: uploadDate ?? this.uploadDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workID': workID,
      'userID': userID,
      'rsg': rsg,
      'ownerID': ownerID,
      'mainWorkID': mainWorkID,
      'subWorkID': subWorkID,
      'checklistID': checklistID,
      'lat': lat,
      'lng': lng,
      'workPerform': workPerform,
      'remark': remark,
      'isChoice': isChoice,
      'reason': reason,
      'msgFromWeb': msgFromWeb,
      'createDate': createDate,
      'uploadDate': uploadDate,
    };
  }

  factory MastWorkListModel.fromMap(Map<String, dynamic> map) {
    return MastWorkListModel(
      workID: map['workID'],
      userID: map['userID'],
      rsg: map['rsg'],
      ownerID: map['ownerID'],
      mainWorkID: map['mainWorkID'],
      subWorkID: map['int subWorkID'],
      checklistID: map['int checklistID'],
      lat: map['lat'],
      lng: map['lng'],
      workPerform: map['workPerform'],
      remark: map['remark'],
      isChoice: map['int isChoice'],
      reason: map['reason'],
      msgFromWeb: map['msgFromWeb'],
      createDate: map['createDate'],
      uploadDate: map['uploadDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MastWorkListModel.fromJson(String source) =>
      MastWorkListModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MastWorkListModel &&
        other.workID == workID &&
        other.userID == userID &&
        other.rsg == rsg &&
        other.ownerID == ownerID &&
        other.mainWorkID == mainWorkID &&
        other.subWorkID == subWorkID &&
        other.checklistID == checklistID &&
        other.lat == lat &&
        other.lng == lng &&
        other.workPerform == workPerform &&
        other.remark == remark &&
        other.isChoice == isChoice &&
        other.reason == reason &&
        other.msgFromWeb == msgFromWeb &&
        other.createDate == createDate &&
        other.uploadDate == uploadDate;
  }

  @override
  int get hashCode {
    return workID.hashCode ^
        userID.hashCode ^
        rsg.hashCode ^
        ownerID.hashCode ^
        mainWorkID.hashCode ^
        subWorkID.hashCode ^
        checklistID.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        workPerform.hashCode ^
        remark.hashCode ^
        isChoice.hashCode ^
        reason.hashCode ^
        msgFromWeb.hashCode ^
        createDate.hashCode ^
        uploadDate.hashCode;
  }
} //class
