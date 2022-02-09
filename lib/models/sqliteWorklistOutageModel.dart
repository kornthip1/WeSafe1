import 'dart:convert';

class SQLiteWorklistOutageModel {
  int id;
  String reqNo;
  String user;
  String region;
  String mainmenu;
  String submenU;
  int checklist;
  String latitude;
  String longtitude;
  String doOrNot;
  String reseanNOT;
  String workperform;
  String remark;
  String isMainLine;
  String imgList;
  int workstatus;
  String isComplete;
  String dateCreated;

  SQLiteWorklistOutageModel({
    this.id,
    this.reqNo,
    this.user,
    this.region,
    this.mainmenu,
    this.submenU,
    this.checklist,
    this.latitude,
    this.longtitude,
    this.doOrNot,
    this.reseanNOT,
    this.remark,
    this.workperform,
    this.isMainLine,
    this.imgList,
    this.isComplete,
    this.workstatus,
    this.dateCreated,
  });

  SQLiteWorklistOutageModel copyWith({
    int id,
    String reqNo,
    String user,
    String region,
    String mainmenu,
    String submenU,
    int checklist,
    String latitude,
    String longtitude,
    String doOrNot,
    String reseanNOT,
    String workperform,
    String remark,
    String isMainLine,
    String imgList,
    int workstatus,
    String isComplete,
    String dateCreated,
  }) {
    return SQLiteWorklistOutageModel(
      id: id ?? this.id,
      reqNo: reqNo ?? this.reqNo,
      user: user ?? this.user,
      region: region ?? this.region,
      mainmenu: mainmenu ?? this.mainmenu,
      submenU: submenU ?? this.submenU,
      checklist: checklist ?? this.checklist,
      latitude: latitude ?? this.latitude,
      longtitude: longtitude ?? this.longtitude,
      doOrNot: doOrNot ?? this.doOrNot,
      reseanNOT: reseanNOT ?? this.reseanNOT,
      workperform: workperform ?? this.workperform,
      remark: remark ?? this.remark,
      isMainLine: isMainLine ?? this.isMainLine,
      imgList: imgList ?? this.imgList,
      workstatus: workstatus ?? this.workstatus,
      isComplete: isComplete ?? this.isComplete,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'REQNO': reqNo,
      'USER': user,
      'REGION': region,
      'MAINMENU': mainmenu,
      'SUBMENU': submenU,
      'CHECKLIST': checklist,
      'LATITUDE': latitude,
      'LONGTITUDE': longtitude,
      'DOORNOT': doOrNot,
      'RESEANNOT': reseanNOT,
      'WORKPERFORM': workperform,
      'REMARK': remark,
      'ISMAINLINE': isMainLine,
      'IMGLIST': imgList,
      'WORKSTATUS': workstatus,
      'ISCOMPLATE': isComplete,
      'DATECREATE': dateCreated,
    };
  }

  factory SQLiteWorklistOutageModel.fromMap(Map<String, dynamic> map) {
    return SQLiteWorklistOutageModel(
      id: map['id'],
      reqNo: map['REQNO'],
      user: map['USER'],
      region: map['REGION'],
      mainmenu: map['MAINMENU'],
      submenU: map['SUBMENU'],
      checklist: map['CHECKLIST'],
      latitude: map['LATITUDE'],
      longtitude: map['LONGTITUDE'],
      doOrNot: map['DOORNOT'],
      reseanNOT: map['RESEANNOT'],
      workperform: map['WORKPERFORM'],
      remark: map['REMARK'],
      isMainLine: map['ISMAINLINE'],
      imgList: map['IMGLIST'],
      workstatus: map['WORKSTATUS'],
      isComplete: map['ISCOMPLATE'],
      dateCreated: map['DATECREATE'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteWorklistOutageModel.fromJson(String source) =>
      SQLiteWorklistOutageModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteWorklistOutageModel &&
        other.id == id &&
        other.reqNo == reqNo &&
        other.user == user &&
        other.region == region &&
        other.mainmenu == mainmenu &&
        other.submenU == submenU &&
        other.checklist == checklist &&
        other.latitude == latitude &&
        other.longtitude == longtitude &&
        other.doOrNot == doOrNot &&
        other.reseanNOT == reseanNOT &&
        other.workperform == workperform &&
        other.remark == remark &&
        other.isMainLine == isMainLine &&
        other.imgList == imgList &&
        other.isComplete == isComplete &&
        other.workstatus == workstatus &&
        other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        reqNo.hashCode ^
        user.hashCode ^
        region.hashCode ^
        mainmenu.hashCode ^
        submenU.hashCode ^
        checklist.hashCode ^
        latitude.hashCode ^
        longtitude.hashCode ^
        doOrNot.hashCode ^
        reseanNOT.hashCode ^
        workperform.hashCode ^
        remark.hashCode ^
        isMainLine.hashCode ^
        imgList.hashCode ^
        isComplete.hashCode ^
        workstatus.hashCode ^
        dateCreated.hashCode;
  }
} //class
