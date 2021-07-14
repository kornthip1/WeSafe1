import 'dart:convert';

class SQLiteStationModel {
  int id;
  String regionCode;
  String regionName;
  String province;
  String stationId;
  String stationName;
  String createdDate;
  String updatedDate;


  SQLiteStationModel({
    this.id,
    this.regionCode,
    this.regionName,
    this.province,
    this.stationId,
    this.stationName,
    this.createdDate,
    this.updatedDate,
  });

  SQLiteStationModel copyWith({
    int id,
    String regionCode,
    String regionName,
    String province,
    String stationId,
    String stationName,
    String createdDate,
    String updatedDate,
  }) {
    return SQLiteStationModel(
      id: id ?? this.id,
      regionCode: regionCode ?? this.regionCode,
      regionName: regionName ?? this.regionName,
      province: province ?? this.province,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'regionCode': regionCode,
      'regionName': regionName,
      'province': province,
      'stationId': stationId,
      'stationName': stationName,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }

  factory SQLiteStationModel.fromMap(Map<String, dynamic> map) {
    return SQLiteStationModel(
      id: map['id'],
      regionCode: map['regionCode'],
      regionName: map['regionName'],
      province: map['province'],
      stationId: map['stationId'],
      stationName: map['stationName'],
      createdDate: map['createdDate'],
      updatedDate: map['updatedDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteStationModel.fromJson(String source) =>
      SQLiteStationModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteStationModel &&
        other.id == id &&
        other.regionCode == regionCode &&
        other.regionName == regionName &&
        other.province == province &&
        other.stationId == stationId &&
        other.stationName == stationName &&
        other.createdDate == createdDate &&
        other.updatedDate == updatedDate ;
       
  }

  @override
  int get hashCode {
    return id.hashCode ^
        regionCode.hashCode ^
        regionName.hashCode ^
        province.hashCode ^
        stationId.hashCode ^
        stationName.hashCode ^
        createdDate.hashCode ^
        updatedDate.hashCode ;
  }
} //class
