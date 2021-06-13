class UserModel {
  String eMPLOYEEID;
  String fIRSTNAME;
  String lASTNAME;
  String dEPTNAME;
  String rEGIONCODE;
  String eMPLOYEESTATUSJOB;
  String tEAM;
  String learderID;
  String learderName;
  List<String> ownerID;
  String userRole;
  String canApprove;
  String ownerName;

  UserModel(
      {this.eMPLOYEEID,
      this.fIRSTNAME,
      this.lASTNAME,
      this.dEPTNAME,
      this.rEGIONCODE,
      this.eMPLOYEESTATUSJOB,
      this.tEAM,
      this.learderID,
      this.learderName,
      this.ownerID,
      this.userRole,
      this.canApprove,
      this.ownerName});

  UserModel.fromJson(Map<String, dynamic> json) {
    eMPLOYEEID = json['EMPLOYEE_ID'];
    fIRSTNAME = json['FIRST_NAME'];
    lASTNAME = json['LAST_NAME'];
    dEPTNAME = json['DEPT_NAME'];
    rEGIONCODE = json['REGION_CODE'];
    eMPLOYEESTATUSJOB = json['EMPLOYEE_STATUS_JOB'];
    tEAM = json['TEAM'];
    learderID = json['LearderID'];
    learderName = json['LearderName'];
    ownerID = json['Owner_ID'].cast<String>();
    userRole = json['UserRole'];
    canApprove = json['CanApprove'];
    ownerName = json['Owner_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['LAST_NAME'] = this.lASTNAME;
    data['DEPT_NAME'] = this.dEPTNAME;
    data['REGION_CODE'] = this.rEGIONCODE;
    data['EMPLOYEE_STATUS_JOB'] = this.eMPLOYEESTATUSJOB;
    data['TEAM'] = this.tEAM;
    data['LearderID'] = this.learderID;
    data['LearderName'] = this.learderName;
    data['Owner_ID'] = this.ownerID;
    data['UserRole'] = this.userRole;
    data['CanApprove'] = this.canApprove;
    data['Owner_Name'] = this.ownerName;
    return data;
  }
}
