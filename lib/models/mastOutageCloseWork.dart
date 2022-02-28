class OutageCloseWork {
  String reqNo;
  String regionCode;
  String menuMainID;
  String menuSubID;
  String menuChecklistID;
  String employeeID;
  String empLeaderID;
  String workStatus;
  String locationLat;
  String locationLng;
  String waitApprove;
  String dateTimeWorkFinish;
  String workPerform;
  String isSortGND;
  String gNDReason;
  String isOffElect;
  String offElectReason;
  String parcel;
  List<String> image;
  String deptName;
  String ownerID;
  String remark;
  String sender;

  OutageCloseWork(
      {this.reqNo,
      this.regionCode,
      this.menuMainID,
      this.menuSubID,
      this.menuChecklistID,
      this.employeeID,
      this.empLeaderID,
      this.workStatus,
      this.locationLat,
      this.locationLng,
      this.waitApprove,
      this.dateTimeWorkFinish,
      this.workPerform,
      this.isSortGND,
      this.gNDReason,
      this.isOffElect,
      this.offElectReason,
      this.parcel,
      this.image,
      this.deptName,
      this.ownerID,
      this.remark,
      this.sender});

  OutageCloseWork.fromJson(Map<String, dynamic> json) {
    reqNo = json['Req_No'];
    regionCode = json['Region_Code'];
    menuMainID = json['MenuMain_ID'];
    menuSubID = json['MenuSub_ID'];
    menuChecklistID = json['Menu_Checklist_ID'];
    employeeID = json['Employee_ID'];
    empLeaderID = json['EmpLeader_ID'];
    workStatus = json['Work_Status'];
    locationLat = json['Location_Lat'];
    locationLng = json['Location_Lng'];
    waitApprove = json['Wait_Approve'];
    dateTimeWorkFinish = json['DateTime_WorkFinish'];
    workPerform = json['WorkPerform'];
    isSortGND = json['IsSortGND'];
    gNDReason = json['GNDReason'];
    isOffElect = json['Is_OffElect'];
    offElectReason = json['OffElectReason'];
    parcel = json['Parcel'];
    image = json['Image'].cast<String>();
    deptName = json['DeptName'];
    ownerID = json['OwnerID'];
    remark = json['Remark'];
    sender = json['Sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Req_No'] = this.reqNo;
    data['Region_Code'] = this.regionCode;
    data['MenuMain_ID'] = this.menuMainID;
    data['MenuSub_ID'] = this.menuSubID;
    data['Menu_Checklist_ID'] = this.menuChecklistID;
    data['Employee_ID'] = this.employeeID;
    data['EmpLeader_ID'] = this.empLeaderID;
    data['Work_Status'] = this.workStatus;
    data['Location_Lat'] = this.locationLat;
    data['Location_Lng'] = this.locationLng;
    data['Wait_Approve'] = this.waitApprove;
    data['DateTime_WorkFinish'] = this.dateTimeWorkFinish;
    data['WorkPerform'] = this.workPerform;
    data['IsSortGND'] = this.isSortGND;
    data['GNDReason'] = this.gNDReason;
    data['Is_OffElect'] = this.isOffElect;
    data['OffElectReason'] = this.offElectReason;
    data['Parcel'] = this.parcel;
    data['Image'] = this.image;
    data['DeptName'] = this.deptName;
    data['OwnerID'] = this.ownerID;
    data['Remark'] = this.remark;
    data['Sender'] = this.sender;
    return data;
  }
}
