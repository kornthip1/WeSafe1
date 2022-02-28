import 'dart:convert';

class MastOutageMenuModel {
  int menuMainID;
  String menuMainName;
  int menuSubID;
  String menuSubName;
  int menuListID;
  String menuListName;
  String dateCreated;
  String type;
  int quantityImg;
  String isChoice;

  MastOutageMenuModel({
    this.menuMainID,
    this.menuMainName,
    this.menuSubID,
    this.menuSubName,
    this.menuListID,
    this.menuListName,
    this.dateCreated,
    this.type,
    this.quantityImg,
    this.isChoice,
  });

  MastOutageMenuModel copyWith({
    int menuMainID,
    String menuMainName,
    int menuSubID,
    String menuSubName,
    int menuListID,
    String menuListName,
    String dateCreated,
    String type,
    int quantityImg,
    String isChoice,
  }) {
    return MastOutageMenuModel(
      menuMainID: menuMainID ?? this.menuMainID,
      menuMainName: menuMainName ?? this.menuMainName,
      menuSubID: menuSubID ?? this.menuSubID,
      menuSubName: menuSubName ?? this.menuSubName,
      menuListID: menuListID ?? this.menuListID,
      menuListName: menuListName ?? this.menuListName,
      dateCreated: dateCreated ?? this.dateCreated,
      type: type ?? this.type,
      quantityImg: quantityImg ?? this.quantityImg,
      isChoice: isChoice ?? this.isChoice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MENUMAIN_ID': menuMainID,
      'MENUMAIN_NAME': menuMainName,
      'MENUSUB_ID': menuSubID,
      'MENUSUB_NAME': menuSubName,
      'MENUCHECKLIST_ID': menuListID,
      'MENUCHECKLIST_NAME': menuListName,
      'DATECREATE': dateCreated,
      'TYPE': type,
      'QUANTITY_IMG': quantityImg,
      'IS_CHOICE': isChoice,
    };
  }

  factory MastOutageMenuModel.fromMap(Map<String, dynamic> map) {
    return MastOutageMenuModel(
      menuMainID: map['MENUMAIN_ID'],
      menuMainName: map['MENUMAIN_NAME'],
      menuSubID: map['MENUSUB_ID'],
      menuSubName: map['MENUSUB_NAME'],
      menuListID: map['MENUCHECKLIST_ID'],
      menuListName: map['MENUCHECKLIST_NAME'],
      dateCreated: map['DATECREATE'],
      type: map['TYPE'],
      quantityImg: map['QUANTITY_IMG'],
      isChoice: map['IS_CHOICE'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MastOutageMenuModel.fromJson(String source) =>
      MastOutageMenuModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MastOutageMenuModel &&
        other.menuMainID == menuMainID &&
        other.menuMainName == menuMainName &&
        other.menuSubID == menuSubID &&
        other.menuSubName == menuSubName &&
        other.menuListID == menuListID &&
        other.menuListName == menuListName &&
        other.dateCreated == dateCreated &&
        other.type == type &&
        other.quantityImg == quantityImg &&
        other.isChoice == isChoice;
  }

  @override
  int get hashCode {
    return menuMainID.hashCode ^
        menuMainName.hashCode ^
        menuSubID.hashCode ^
        menuSubName.hashCode ^
        menuListID.hashCode ^
        menuListName.hashCode ^
        dateCreated.hashCode ^
        type.hashCode ^
        quantityImg.hashCode ^
        isChoice.hashCode;
  }
} //class
