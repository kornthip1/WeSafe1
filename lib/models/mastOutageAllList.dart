class MastOutageAllListModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  MastOutageAllListModel({this.isSuccess, this.result, this.message});

  MastOutageAllListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['Result'] != null) {
      result = <Result>[];
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
  int menuMainID;
  String menuMainName;
  String ownerID;
  int menuSubID;
  String menuSubName;
  String type;
  int quantityImg;
  String isChoice;
  int menuChecklistID;
  String menuChecklistName;

  Result(
      {this.menuMainID,
      this.menuMainName,
      this.ownerID,
      this.menuSubID,
      this.menuSubName,
      this.type,
      this.quantityImg,
      this.isChoice,
      this.menuChecklistID,
      this.menuChecklistName});

  Result.fromJson(Map<String, dynamic> json) {
    menuMainID = json['MenuMain_ID'];
    menuMainName = json['MenuMain_Name'];
    ownerID = json['Owner_ID'];
    menuSubID = json['MenuSub_ID'];
    menuSubName = json['MenuSub_Name'];
    type = json['Type'];
    quantityImg = json['Quantity_Img'];
    isChoice = json['Is_Choice'];
    menuChecklistID = json['MenuChecklist_ID'];
    menuChecklistName = json['MenuChecklist_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuMain_ID'] = this.menuMainID;
    data['MenuMain_Name'] = this.menuMainName;
    data['Owner_ID'] = this.ownerID;
    data['MenuSub_ID'] = this.menuSubID;
    data['MenuSub_Name'] = this.menuSubName;
    data['Type'] = this.type;
    data['Quantity_Img'] = this.quantityImg;
    data['Is_Choice'] = this.isChoice;
    data['MenuChecklist_ID'] = this.menuChecklistID;
    data['MenuChecklist_Name'] = this.menuChecklistName;
    return data;
  }
}
