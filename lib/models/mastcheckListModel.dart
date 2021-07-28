class MastCheckListModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  MastCheckListModel({this.isSuccess, this.result, this.message});

  MastCheckListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['Result'] != null) {
      result = new List<Result>();
      json['Result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['Result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    return data;
  }
}

class Result {
  String menuMainID;
  String menuSubID;
  String menuChecklistID;
  String menuChecklistName;
  String flagRequire;
  String waitApprove;
  String menuChecklistDesc;
  String type;
  String quantityImg;
  String prefixImgName;
  String isChoice;

  Result(
      {this.menuMainID,
      this.menuSubID,
      this.menuChecklistID,
      this.menuChecklistName,
      this.flagRequire,
      this.waitApprove,
      this.menuChecklistDesc,
      this.type,
      this.quantityImg,
      this.prefixImgName,
      this.isChoice});

  Result.fromJson(Map<String, dynamic> json) {
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
    isChoice = json['Is_Choice'];
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
    data['Is_Choice'] = this.isChoice;
    return data;
  }
}
