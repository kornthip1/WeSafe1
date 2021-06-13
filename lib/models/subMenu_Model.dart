class SubMenuModel {
  int menuMainID;
  int menuSubID;
  String menuMainName;
  List<String> menuSubName;
  String ownerID;

  SubMenuModel(
      {this.menuMainID,
      this.menuSubID,
      this.menuMainName,
      this.menuSubName,
      this.ownerID});

  SubMenuModel.fromJson(Map<String, dynamic> json) {
    menuMainID = json['MenuMain_ID'];
    menuSubID = json['MenuSub_ID'];
    menuMainName = json['MenuMain_Name'];
    menuSubName = json['MenuSub_Name'].cast<String>();
    ownerID = json['Owner_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuMain_ID'] = this.menuMainID;
    data['MenuSub_ID'] = this.menuSubID;
    data['MenuMain_Name'] = this.menuMainName;
    data['MenuSub_Name'] = this.menuSubName;
    data['Owner_ID'] = this.ownerID;
    return data;
  }
}
