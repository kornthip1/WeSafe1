import 'dart:convert';

class MastOutageWorkingModel {
  String reqno;
  String user;
  String region;
  String mainmenu;
  String submenu;
  String checklist;
  String latitude;
  String longtitude;
  String doornot;
  String reseannot;
  String workperform;
  String remark;
  String ismainline;
  String imglist;
  String workstatus;
  String iscomplate;
  String datecreate;

  MastOutageWorkingModel({
    this.reqno,
    this.user,
    this.region,
    this.mainmenu,
    this.submenu,
    this.checklist,
    this.latitude,
    this.longtitude,
    this.doornot,
    this.reseannot,
    this.workperform,
    this.remark,
    this.ismainline,
    this.imglist,
    this.workstatus,
    this.iscomplate,
    this.datecreate,
  });

  MastOutageWorkingModel copyWith({
    String reqno,
    String user,
    String region,
    String mainmenu,
    String submenu,
    String checklist,
    String latitude,
    String longtitude,
    String doornot,
    String reseannot,
    String workperform,
    String remark,
    String ismainline,
    String imglist,
    String workstatus,
    String iscomplate,
    String datecreate,
  }) {
    return MastOutageWorkingModel(
      reqno: reqno ?? this.reqno,
      user: user ?? this.user,
      region: region ?? this.region,
      mainmenu: mainmenu ?? this.mainmenu,
      submenu: submenu ?? this.submenu,
      checklist: checklist ?? this.checklist,
      latitude: latitude ?? this.latitude,
      longtitude: longtitude ?? this.longtitude,
      doornot: doornot ?? this.doornot,
      reseannot: reseannot ?? this.reseannot,
      workperform: workperform ?? this.workperform,
      remark: remark ?? this.remark,
      ismainline: ismainline ?? this.ismainline,
      imglist: imglist ?? this.imglist,
      workstatus: workstatus ?? this.workstatus,
      iscomplate: iscomplate ?? this.iscomplate,
      datecreate: datecreate ?? this.datecreate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'REQNO': reqno,
      'USER': user,
      'REGION': region,
      'MAINMENU': mainmenu,
      'SUBMENU': submenu,
      'CHECKLIST': checklist,
      'LATITUDE': latitude,
      'LONGTITUDE': longtitude,
      'DOORNOT': doornot,
      'RESEANNOT': reseannot,
      'WORKPERFORM': workperform,
      'REMARK': remark,
      'ISMAINLINE': ismainline,
      'IMGLIST': imglist,
      'WORKSTATUS': workstatus,
      'ISCOMPLATE': iscomplate,
      'DATECREATE': datecreate,
    };
  }

  factory MastOutageWorkingModel.fromMap(Map<String, dynamic> map) {
    return MastOutageWorkingModel(
      reqno: map['REQNO'],
      user: map['USER'],
      region: map['REGION'],
      mainmenu: map['MAINMENU'],
      submenu: map['SUBMENU'],
      checklist: map['CHECKLIST'],
      latitude: map['LATITUDE'],
      longtitude: map['LONGTITUDE'],
      doornot: map['DOORNOT'],
      reseannot: map['RESEANNOT'],
      workperform: map['WORKPERFORM'],
      remark: map['REMARK'],
      ismainline: map['ISMAINLINE'],
      imglist: map['IMGLIST'],
      workstatus: map['WORKSTATUS'],
      iscomplate: map['ISCOMPLATE'],
      datecreate: map['DATECREATE'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MastOutageWorkingModel.fromJson(String source) =>
      MastOutageWorkingModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MastOutageWorkingModel &&
        other.reqno == reqno &&
        other.user == user &&
        other.region == region &&
        other.mainmenu == mainmenu &&
        other.submenu == submenu &&
        other.checklist == checklist &&
        other.latitude == latitude &&
        other.longtitude == longtitude &&
        other.doornot == doornot &&
        other.reseannot == reseannot &&
        other.workperform == workperform &&
        other.remark == remark &&
        other.ismainline == ismainline &&
        other.imglist == imglist &&
        other.workstatus == workstatus &&
        other.iscomplate == iscomplate &&
        other.datecreate == datecreate;
  }

  @override
  int get hashCode {
    return reqno.hashCode ^
        user.hashCode ^
        region.hashCode ^
        mainmenu.hashCode ^
        submenu.hashCode ^
        checklist.hashCode ^
        latitude.hashCode ^
        longtitude.hashCode ^
        doornot.hashCode ^
        reseannot.hashCode ^
        workperform.hashCode ^
        remark.hashCode ^
        ismainline.hashCode ^
        imglist.hashCode ^
        workstatus.hashCode ^
        iscomplate.hashCode ^
        datecreate.hashCode;
  }
} //class
