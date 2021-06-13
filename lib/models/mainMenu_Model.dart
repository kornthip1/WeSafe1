class MainMenuModel {
  int menuMainID;
  String menuMainName;
  String menuMainDesc;
  String ownerID;
  String menuColor;

  MainMenuModel(
      {this.menuMainID,
      this.menuMainName,
      this.menuMainDesc,
      this.ownerID,
      this.menuColor});

  MainMenuModel.fromJson(Map<String, dynamic> json) {
    menuMainID = json['menuMain_ID'];
    menuMainName = json['menuMain_Name'];
    menuMainDesc = json['menuMain_Desc'];
    ownerID = json['owner_ID'];
    menuColor = json['menu_Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuMain_ID'] = this.menuMainID;
    data['menuMain_Name'] = this.menuMainName;
    data['menuMain_Desc'] = this.menuMainDesc;
    data['owner_ID'] = this.ownerID;
    data['menu_Color'] = this.menuColor;
    return data;
  }
}
