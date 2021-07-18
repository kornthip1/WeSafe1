import 'dart:convert';

class SQLiteWorklistModel {
  int id;
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
  int isComplete;
  String createDate;
  String uploadDate;

  String workRegion;
  String workProvince;
  String workStation;
  String workType;
  String workDoc;

  String imgList;

  String reqNo;

  String isSortGND;
  String gNDReason;
  String isOffElect;
  String offElectReason;

  SQLiteWorklistModel({
    this.id,
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
    this.isComplete,
    this.createDate,
    this.uploadDate,
    this.workRegion,
    this.workProvince,
    this.workStation,
    this.workType,
    this.workDoc,
    this.imgList,
    this.reqNo,
    this.isSortGND,
    this.gNDReason,
    this.isOffElect,
    this.offElectReason,
  });

  SQLiteWorklistModel copyWith({
    int id,
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
    int isComplete,
    String createDate,
    String uploadDate,
    String workRegion,
    String workProvince,
    String workStation,
    String workType,
    String workDoc,
    String imgList,
    String reqNo,
    String isSortGND,
    String gNDReason,
    String isOffElect,
    String offElectReason,
  }) {
    return SQLiteWorklistModel(
      id: id ?? this.id,
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
      isComplete: isComplete ?? this.isComplete,
      createDate: createDate ?? this.createDate,
      uploadDate: uploadDate ?? this.uploadDate,
      workRegion: workRegion ?? this.workRegion,
      workProvince: workProvince ?? this.workProvince,
      workStation: workStation ?? this.workStation,
      workType: workType ?? this.workType,
      workDoc: workDoc ?? this.workDoc,
      imgList: imgList ?? this.imgList,
      reqNo: reqNo ?? this.reqNo,
      isSortGND: isSortGND ?? this.isSortGND,
      gNDReason: gNDReason ?? this.gNDReason,
      isOffElect: reqNo ?? this.isOffElect,
      offElectReason: reqNo ?? this.offElectReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'isComplete': isComplete,
      'createDate': createDate,
      'uploadDate': uploadDate,
      'workRegion': workRegion,
      'workProvince': workProvince,
      'workStation': workStation,
      'workType': workType,
      'workDoc': workDoc,
      'imgList': imgList,
      'reqNo': reqNo,
      'isSortGND': isSortGND,
      'gNDReason': gNDReason,
      'isOffElect': isOffElect,
      'offElectReason': offElectReason,
    };
  }

  factory SQLiteWorklistModel.fromMap(Map<String, dynamic> map) {
    return SQLiteWorklistModel(
      id: map['id'],
      workID: map['workID'],
      userID: map['userID'],
      rsg: map['rsg'],
      ownerID: map['ownerID'],
      mainWorkID: map['mainWorkID'],
      subWorkID: map['subWorkID'],
      checklistID: map['checklistID'],
      lat: map['lat'],
      lng: map['lng'],
      workPerform: map['workPerform'],
      remark: map['remark'],
      isChoice: map['isChoice'],
      reason: map['reason'],
      msgFromWeb: map['msgFromWeb'],
      isComplete: map['isComplete'],
      createDate: map['createDate'],
      uploadDate: map['uploadDate'],
      workRegion: map['workRegion'],
      workProvince: map['workProvince'],
      workStation: map['workStation'],
      workType: map['workType'],
      workDoc: map['workDoc'],
      imgList: map['imgList'],
      reqNo: map['reqNo'],
      isSortGND: map['isSortGND'],
      gNDReason: map['gNDReason'],
      isOffElect: map['isOffElect'],
      offElectReason: map['offElectReason'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteWorklistModel.fromJson(String source) =>
      SQLiteWorklistModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteWorklistModel &&
        other.id == id &&
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
        other.isComplete == isComplete &&
        other.createDate == createDate &&
        other.uploadDate == uploadDate &&
        other.workRegion == workRegion &&
        other.workProvince == workProvince &&
        other.workStation == workStation &&
        other.workType == workType &&
        other.workDoc == workDoc &&
        other.reqNo == reqNo &&
        other.isSortGND == isSortGND &&
        other.gNDReason == gNDReason &&
        other.isOffElect == isOffElect &&
        other.offElectReason == offElectReason &&
        other.imgList == imgList;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        workID.hashCode ^
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
        isComplete.hashCode ^
        createDate.hashCode ^
        uploadDate.hashCode ^
        workRegion.hashCode ^
        workProvince.hashCode ^
        workStation.hashCode ^
        workType.hashCode ^
        workDoc.hashCode ^
        reqNo.hashCode ^
        isSortGND.hashCode ^
        gNDReason.hashCode ^
        isOffElect.hashCode ^
        offElectReason.hashCode ^
        imgList.hashCode;
  }
} //class
