class MastCheckWorkListModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  MastCheckWorkListModel({this.isSuccess, this.result, this.message});

  MastCheckWorkListModel.fromJson(Map<String, dynamic> json) {
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
  String reqNo;
  String dateCreate;
  String mastStatus;
  String statusDetail;
  int menuMainID;
  int menuSubID;
  int menuChecklistID;
  String employee_ID;
  String dateApprove;
  String msgReturnFromWeb;
  String isMainLine;
  String workPerform;

  Result(
      {this.reqNo,
      this.dateCreate,
      this.mastStatus,
      this.statusDetail,
      this.menuMainID,
      this.menuSubID,
      this.menuChecklistID,
      this.employee_ID,
      this.dateApprove,
      this.msgReturnFromWeb,
      this.isMainLine,
      this.workPerform});

  Result.fromJson(Map<String, dynamic> json) {
    reqNo = json['Req_no'];
    dateCreate = json['DateCreate'];
    mastStatus = json['Mast_Status'];
    statusDetail = json['StatusName'];
    menuMainID = json['MenuMain_ID'];
    menuSubID = json['MenuSub_ID'];
    menuChecklistID = json['Menu_Checklist_ID'];
    employee_ID = json['Employee_ID'];
    dateApprove = json['Date_Approve'];
    msgReturnFromWeb = json['Msg_Return_From_Web'];
    isMainLine = json['IsMainLine'];
    workPerform = json['WorkPerformed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Req_no'] = this.reqNo;
    data['DateCreate'] = this.dateCreate;
    data['Mast_Status'] = this.mastStatus;
    data['StatusName'] = this.statusDetail;
    data['MenuMain_ID'] = this.menuMainID;
    data['MenuSub_ID'] = this.menuSubID;
    data['Menu_Checklist_ID'] = this.menuChecklistID;
    data['Employee_ID'] = this.employee_ID;
    data['Date_Approve'] = this.dateApprove;
    data['Msg_Return_From_Web'] = this.msgReturnFromWeb;
    data['IsMainLine'] = this.isMainLine;
    data['WorkPerformed'] = this.workPerform;
    return data;
  }
}
