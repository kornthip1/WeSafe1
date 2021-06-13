class WorkListModel {
  int menuMainID;
  int menuSubID;
  String menuChecklistID;
  String menuChecklistName;
  int flagRequire;
  int waitApprove;
  String menuChecklistDesc;
  int type;
  int quantityImg;
  String prefixImgName;

  WorkListModel(
      {this.menuMainID,
      this.menuSubID,
      this.menuChecklistID,
      this.menuChecklistName,
      this.flagRequire,
      this.waitApprove,
      this.menuChecklistDesc,
      this.type,
      this.quantityImg,
      this.prefixImgName});

  WorkListModel.fromJson(Map<String, dynamic> json) {
    menuMainID = json['MenuMain_ID'];
    menuSubID = json['MenuSub_ID'];
    menuChecklistID = json['MenuChecklist_ID'];
    menuChecklistName = json['MenuChecklist_Name'];
    flagRequire = json['Flag_Require'];
    waitApprove = json['Wait_Approve'];
    menuChecklistDesc = json['MenuChecklist_Desc'];
    type = json['Type'];
    quantityImg = json['Quantity_Img'];
    prefixImgName = json['PrefixImgName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuMain_ID'] = this.menuMainID;
    data['MenuSub_ID'] = this.menuSubID;
    data['MenuChecklist_ID'] = this.menuChecklistID;
    data['MenuChecklist_Name'] = this.menuChecklistName;
    data['Flag_Require'] = this.flagRequire;
    data['Wait_Approve'] = this.waitApprove;
    data['MenuChecklist_Desc'] = this.menuChecklistDesc;
    data['Type'] = this.type;
    data['Quantity_Img'] = this.quantityImg;
    data['PrefixImgName'] = this.prefixImgName;
    return data;
  }
}
