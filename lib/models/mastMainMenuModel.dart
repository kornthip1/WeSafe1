class MastMainMenuModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  MastMainMenuModel({this.isSuccess, this.result, this.message});

  MastMainMenuModel.fromJson(Map<String, dynamic> json) {
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
  String menuMainName;
  String menuMainDesc;
  String ownerID;
  String menuColor;
  List<String> lineToken;

  Result(
      {this.menuMainID,
      this.menuMainName,
      this.menuMainDesc,
      this.ownerID,
      this.menuColor,
      this.lineToken});

  Result.fromJson(Map<String, dynamic> json) {
    menuMainID = json['MenuMain_ID'];
    menuMainName = json['MenuMain_Name'];
    menuMainDesc = json['MenuMain_Desc'];
    ownerID = json['Owner_ID'];
    menuColor = json['Menu_Color'];
    lineToken = json['LineToken'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuMain_ID'] = this.menuMainID;
    data['MenuMain_Name'] = this.menuMainName;
    data['MenuMain_Desc'] = this.menuMainDesc;
    data['Owner_ID'] = this.ownerID;
    data['Menu_Color'] = this.menuColor;
    data['LineToken'] = this.lineToken;
    return data;
  }
}
