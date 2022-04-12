import 'dart:convert';

import 'package:wesafe/utility/my_constainDB.dart';

class SQLiteMastOfficeAddrModel {
  String regionGroup;
  String peaName;

  SQLiteMastOfficeAddrModel({this.regionGroup, this.peaName});

  SQLiteMastOfficeAddrModel copyWith({
    String regionGroup,
    String peaName,
  }) {
    return SQLiteMastOfficeAddrModel(
      regionGroup: regionGroup ?? this.regionGroup,
      peaName: peaName ?? this.peaName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'REGIONGROUP': regionGroup,
      'PEA_NAME': peaName,
 

    };
  }

  factory SQLiteMastOfficeAddrModel.fromMap(Map<String, dynamic> map) {
    return SQLiteMastOfficeAddrModel(
      regionGroup: map['REGIONGROUP'],
      peaName: map['PEA_NAME'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteMastOfficeAddrModel.fromJson(String source) =>
      SQLiteMastOfficeAddrModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteMastOfficeAddrModel &&
        other.regionGroup == regionGroup &&
        other.peaName == peaName;
  }

  @override
  int get hashCode {
    return regionGroup.hashCode ^
        peaName.hashCode ;
  }
} //class
