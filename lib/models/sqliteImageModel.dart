import 'dart:convert';

class SQLiteImgModel {
  int workID;
  String mainWorkID;
  int subWorkID;
  int checklistID;
  int sequenceImg;
  String base64Img;
  String createDate;
  String uploadDate;
  String isComplete;

  SQLiteImgModel({
    this.workID,
    this.mainWorkID,
    this.subWorkID,
    this.checklistID,
    this.sequenceImg,
    this.base64Img,
    this.createDate,
    this.uploadDate,
    this.isComplete,
  });

  SQLiteImgModel copyWith({
     int workID,
  String mainWorkID,
  int subWorkID,
  int checklistID,
  int sequenceImg,
  String base64Img,
  String createDate,
  String uploadDate,
  String isComplete,
  }) {
    return SQLiteImgModel(
      workID: workID ?? this.workID,
      mainWorkID: mainWorkID ?? this.mainWorkID,
      subWorkID: subWorkID ?? this.subWorkID,
      checklistID: checklistID ?? this.checklistID,
      sequenceImg: sequenceImg ?? this.sequenceImg,
      base64Img: base64Img ?? this.base64Img,
      createDate: createDate ?? this.createDate,
      uploadDate: uploadDate ?? this.uploadDate,
      isComplete: isComplete ?? this.isComplete,
     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workID': workID,
      'mainWorkID': mainWorkID,
      'subWorkID': subWorkID,
      'checklistID': checklistID,
      'sequenceImg': sequenceImg,
      'base64Img': base64Img,
      'isComplete': isComplete,
      'createDate': createDate,
      'uploadDate': uploadDate,
    };
  }

  factory SQLiteImgModel.fromMap(Map<String, dynamic> map) {
    return SQLiteImgModel(
      workID: map['workID'],
      mainWorkID: map['mainWorkID'],
      subWorkID: map['subWorkID'],
      checklistID: map['checklistID'],
      sequenceImg: map['sequenceImg'],
      base64Img: map['base64Img'],
      isComplete: map['isComplete'],
      createDate: map['createDate'],
      uploadDate: map['uploadDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteImgModel.fromJson(String source) =>
      SQLiteImgModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteImgModel &&
        other.workID == workID &&
        other.mainWorkID == mainWorkID &&
        other.subWorkID == subWorkID &&
        other.checklistID == checklistID &&
        other.sequenceImg == sequenceImg &&
        other.base64Img == base64Img &&
        other.isComplete == isComplete &&
        other.createDate == createDate &&
        other.uploadDate == uploadDate;
  }

  @override
  int get hashCode {
    return workID.hashCode ^
        mainWorkID.hashCode ^
        subWorkID.hashCode ^
        checklistID.hashCode ^
        sequenceImg.hashCode ^
        base64Img.hashCode ^
        isComplete.hashCode ^
        createDate.hashCode ^
        uploadDate.hashCode;
  }
} //class
