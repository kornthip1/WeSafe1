import 'dart:convert';

class SQLitePercelModel {
  int workID;
  String mainWorkID;
  int subWorkID;
  int checklistID;
  String item;
  int amount;
  int isComplete;
  String createDate;
  String reqNo;

  SQLitePercelModel({
    this.workID,
    this.mainWorkID,
    this.subWorkID,
    this.checklistID,
    this.item,
    this.amount,
    this.createDate,
    this.isComplete,
    this.reqNo,
  });

  SQLitePercelModel copyWith({
    int workID,
    String mainWorkID,
    int subWorkID,
    int checklistID,
    String item,
    int amount,
    int isComplete,
    String createDate,
    String reqNo,
  }) {
    return SQLitePercelModel(
      workID: workID ?? this.workID,
      mainWorkID: mainWorkID ?? this.mainWorkID,
      subWorkID: subWorkID ?? this.subWorkID,
      checklistID: checklistID ?? this.checklistID,
      item: item ?? this.item,
      amount: amount ?? this.amount,
      createDate: createDate ?? this.createDate,
      isComplete: isComplete ?? this.isComplete,
      reqNo: reqNo ?? this.reqNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workID': workID,
      'mainWorkID': mainWorkID,
      'subWorkID': subWorkID,
      'checklistID': checklistID,
      'item': item,
      'amount': amount,
      'isComplete': isComplete,
      'createDate': createDate,
      'reqNo': createDate,
    };
  }

  factory SQLitePercelModel.fromMap(Map<String, dynamic> map) {
    return SQLitePercelModel(
      workID: map['workID'],
      mainWorkID: map['mainWorkID'],
      subWorkID: map['subWorkID'],
      checklistID: map['ichecklistID'],
      item: map['item'],
      amount: map['amount'],
      isComplete: map['isComplete'],
      createDate: map['createDate'],
      reqNo: map['reqNo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLitePercelModel.fromJson(String source) =>
      SQLitePercelModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLitePercelModel &&
        other.workID == workID &&
        other.mainWorkID == mainWorkID &&
        other.subWorkID == subWorkID &&
        other.checklistID == checklistID &&
        other.item == item &&
        other.amount == amount &&
        other.isComplete == isComplete &&
        other.reqNo == reqNo &&
        other.createDate == createDate;
  }

  @override
  int get hashCode {
    return workID.hashCode ^
        mainWorkID.hashCode ^
        subWorkID.hashCode ^
        checklistID.hashCode ^
        item.hashCode ^
        amount.hashCode ^
        isComplete.hashCode ^
        reqNo.hashCode^
        createDate.hashCode;
  }
} //class
