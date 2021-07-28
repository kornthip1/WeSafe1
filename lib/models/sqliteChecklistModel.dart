import 'dart:convert';

import 'package:wesafe/utility/my_constainDB.dart';

class SQLiteChecklistModel {
  int id;
  String menuMainID;
  String menuSubID;
  String menuChecklistID;
  String menuChecklistName;
  String flagRequire;
  String waitApprove;
  String menuChecklistDesc;
  String type;
  String quantityImg;

  SQLiteChecklistModel(
      {this.id,
      this.menuMainID,
      this.menuSubID,
      this.menuChecklistID,
      this.menuChecklistName,
      this.flagRequire,
      this.waitApprove,
      this.menuChecklistDesc,
      this.type,
      this.quantityImg});

  SQLiteChecklistModel copyWith({
    int id,
    String menuMainID,
    String menuSubID,
    String menuChecklistID,
    String menuChecklistName,
    String flagRequire,
    String waitApprove,
    String menuChecklistDesc,
    String type,
    String quantityImg,
  }) {
    return SQLiteChecklistModel(
      id: id ?? this.id,
      menuMainID: menuMainID ?? this.menuMainID,
      menuSubID: menuSubID ?? this.menuSubID,
      menuChecklistID: menuChecklistID ?? this.menuChecklistID,
      menuChecklistName: menuChecklistName ?? this.menuChecklistName,
      flagRequire: flagRequire ?? this.flagRequire,
      waitApprove: waitApprove ?? this.waitApprove,
      menuChecklistDesc: menuChecklistDesc ?? this.menuChecklistDesc,
      type: type ?? this.type,
      quantityImg: quantityImg ?? this.quantityImg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      MyConstainCheckListDB.columnMenuMainID: menuMainID,
      MyConstainCheckListDB.columnMenuSubID: menuSubID,
      MyConstainCheckListDB.columnMenuChecklistID: menuChecklistID,
      MyConstainCheckListDB.columnMenuChecklistName: menuChecklistName,
      MyConstainCheckListDB.columnFlagRequire: flagRequire,
      MyConstainCheckListDB.columnWaitApprove: waitApprove,
      MyConstainCheckListDB.columnMenuChecklistDesc: menuChecklistDesc,
      MyConstainCheckListDB.columnType: type,
      MyConstainCheckListDB.columnQuantityImg: quantityImg,
    };
  }

  factory SQLiteChecklistModel.fromMap(Map<String, dynamic> map) {
    return SQLiteChecklistModel(
      id: map['id'],
      menuMainID: map[MyConstainCheckListDB.columnMenuMainID],
      menuSubID: map[MyConstainCheckListDB.columnMenuSubID],
      menuChecklistID: map[MyConstainCheckListDB.columnMenuChecklistID],
      menuChecklistName: map[MyConstainCheckListDB.columnMenuChecklistName],
      flagRequire: map[MyConstainCheckListDB.columnFlagRequire],
      waitApprove: map[MyConstainCheckListDB.columnWaitApprove],
      menuChecklistDesc: map[MyConstainCheckListDB.columnMenuChecklistDesc],
      type: map[MyConstainCheckListDB.columnType],
      quantityImg: map[MyConstainCheckListDB.columnQuantityImg],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteChecklistModel.fromJson(String source) =>
      SQLiteChecklistModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteChecklistModel &&
        other.id == id &&
        other.menuMainID == menuMainID &&
        other.menuSubID == menuSubID &&
        other.menuChecklistID == menuChecklistID &&
        other.menuChecklistName == menuChecklistName &&
        other.flagRequire == flagRequire &&
        other.waitApprove == waitApprove &&
        other.menuChecklistDesc == menuChecklistDesc &&
        other.type == type &&
        other.quantityImg == quantityImg;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        menuMainID.hashCode ^
        menuSubID.hashCode ^
        menuChecklistID.hashCode ^
        menuChecklistName.hashCode ^
        flagRequire.hashCode ^
        waitApprove.hashCode ^
        type.hashCode ^
        quantityImg.hashCode ^
        menuChecklistDesc.hashCode;
  }
} //class
