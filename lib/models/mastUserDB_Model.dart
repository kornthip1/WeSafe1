import 'dart:convert';

class MastUserModel {
  String userID;
  String firstName;
  String lastName;
  String position;
  String deptCode;
  String teamName;
  String leaderName;
  String pincode;
  String createdDate;


  MastUserModel({
    this.userID,
    this.firstName,
    this.lastName,
    this.position,
    this.deptCode,
    this.teamName,
    this.leaderName,
    this.pincode,
    this.createdDate,
  });

  MastUserModel copyWith({
    String userID,
    String firstName,
    String lastName,
    String position,
    String deptCode,
    String teamName,
    String leaderName,
    String pincode,
    String createdDate,
  }) {
    return MastUserModel(

      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      position: position ?? this.position,
      deptCode: deptCode ?? this.deptCode,
      teamName: teamName ?? this.teamName,
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
      'leaderName': leaderName,
      'pincode': pincode,
      'createdDate': createdDate,
    };
  }

  factory MastUserModel.fromMap(Map<String, dynamic> map) {
    return MastUserModel(
      userID: map['userID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      position: map['position'],
      deptCode: map['deptCode'],
      teamName: map['teamName'],
      leaderName: map['leaderName'],
      pincode: map['pincode'],
      createdDate: map['createdDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MastUserModel.fromJson(String source) =>
      MastUserModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MastUserModel &&
        other.userID == userID &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.position == position &&
        other.deptCode == deptCode &&
        other.teamName == teamName &&
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
        leaderName.hashCode ^
        pincode.hashCode ^
        createdDate.hashCode ;
  }
} //class
