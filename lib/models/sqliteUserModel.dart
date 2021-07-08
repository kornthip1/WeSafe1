import 'dart:convert';

class SQLiteUserModel {
  String userID;
  String firstName;
  String lastName;
  String position;
  String deptCode;
  String teamName;
  String ownerID;
  String ownerName;
  String leaderName;
  String pincode;
  String createdDate;

  SQLiteUserModel({
    this.userID,
    this.firstName,
    this.lastName,
    this.position,
    this.deptCode,
    this.teamName,
    this.ownerID,
    this.ownerName,
    this.leaderName,
    this.pincode,
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
    String createdDate,
  }) {
    return SQLiteUserModel(
      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      position: position ?? this.position,
      deptCode: deptCode ?? this.deptCode,
      teamName: teamName ?? this.teamName,
      ownerID: ownerID ?? this.ownerID,
      ownerName: ownerName ?? this.ownerName,
      leaderName: leaderName ?? this.leaderName,
      pincode: pincode ?? this.pincode,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'position': position,
      'deptCode': deptCode,
      'teamName': teamName,
      'ownerID': ownerID,
      'ownerName': ownerName,
      'leaderName': leaderName,
      'pincode': pincode,
      'createdDate': createdDate,
    };
  }

  factory SQLiteUserModel.fromMap(Map<String, dynamic> map) {
    return SQLiteUserModel(
      userID: map['userID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      position: map['position'],
      deptCode: map['deptCode'],
      teamName: map['teamName'],
      ownerID: map['ownerID'],
      ownerName: map['ownerName'],
      leaderName: map['leaderName'],
      pincode: map['pincode'],
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
        other.deptCode == deptCode &&
        other.teamName == teamName &&
        other.ownerID == ownerID &&
        other.ownerName == ownerName &&
        other.leaderName == leaderName &&
        other.pincode == pincode &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        position.hashCode ^
        deptCode.hashCode ^
        teamName.hashCode ^
        ownerID.hashCode ^
        ownerName.hashCode ^
        leaderName.hashCode ^
        pincode.hashCode ^
        createdDate.hashCode;
  }
} //class
