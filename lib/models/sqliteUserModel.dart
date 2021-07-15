import 'dart:convert';

class SQLiteUserModel {
  String userID;
  String firstName;
  String lastName;
  String position;
  String deptName;
  String teamName;
  String ownerID;
  String ownerName;
  String leaderName;
  String pincode;
  String rsg;
  String leaderId;
  String ownerDesc;
  String userRole;
  String canApprove;
  String createdDate;

  SQLiteUserModel({
    this.userID,
    this.firstName,
    this.lastName,
    this.position,
    this.deptName,
    this.teamName,
    this.ownerID,
    this.ownerName,
    this.leaderName,
    this.pincode,
    this.rsg,
    this.leaderId,
    this.ownerDesc,
    this.userRole,
    this.canApprove,
    this.createdDate,
  });

  SQLiteUserModel copyWith({
    String userID,
    String firstName,
    String lastName,
    String position,
    String deptCode,
    String teamName,
    String ownerID,
    String ownerName,
    String leaderName,
    String pincode,
    String rsg,
    String leaderId,
    String ownerDesc,
    String userRole,
    String canApprove,
    String createdDate,
  }) {
    return SQLiteUserModel(
      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      position: position ?? this.position,
      deptName: deptCode ?? this.deptName,
      teamName: teamName ?? this.teamName,
      ownerID: ownerID ?? this.ownerID,
      ownerName: ownerName ?? this.ownerName,
      leaderName: leaderName ?? this.leaderName,
      pincode: pincode ?? this.pincode,
      rsg: rsg ?? this.rsg,
      leaderId: leaderId ?? this.leaderId,
      ownerDesc: ownerDesc ?? this.ownerDesc,
      userRole: userRole ?? this.userRole,
      canApprove: canApprove ?? this.canApprove,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'position': position,
      'deptName': deptName,
      'teamName': teamName,
      'ownerID': ownerID,
      'ownerName': ownerName,
      'leaderName': leaderName,
      'pincode': pincode,
      'regionCode': rsg,
      'leaderId': leaderId,
      'ownerDesc': ownerDesc,
      'userRole': userRole,
      'canApprove': canApprove,
      'createdDate': createdDate,
    };
  }

  factory SQLiteUserModel.fromMap(Map<String, dynamic> map) {
    return SQLiteUserModel(
      userID: map['userID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      position: map['position'],
      deptName: map['deptName'],
      teamName: map['teamName'],
      ownerID: map['ownerID'],
      ownerName: map['ownerName'],
      leaderName: map['leaderName'],
      pincode: map['pincode'],
      rsg: map['regionCode'],
      leaderId: map['leaderId'],
      ownerDesc: map['ownerDesc'],
      userRole: map['userRole'],
      canApprove: map['canApprove'],
      createdDate: map['createdDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteUserModel.fromJson(String source) =>
      SQLiteUserModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteUserModel &&
        other.userID == userID &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.position == position &&
        other.deptName == deptName &&
        other.teamName == teamName &&
        other.ownerID == ownerID &&
        other.ownerName == ownerName &&
        other.leaderName == leaderName &&
        other.pincode == pincode &&
        other.rsg == rsg &&
        other.leaderId == leaderId &&
        other.ownerDesc == ownerDesc &&
        other.userRole == userRole &&
        other.canApprove == canApprove &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        position.hashCode ^
        deptName.hashCode ^
        teamName.hashCode ^
        ownerID.hashCode ^
        ownerName.hashCode ^
        leaderName.hashCode ^
        pincode.hashCode ^
        rsg.hashCode ^
        leaderId.hashCode ^
        ownerDesc.hashCode ^
        userRole.hashCode ^
        canApprove.hashCode ^
        createdDate.hashCode;
  }
} //class
