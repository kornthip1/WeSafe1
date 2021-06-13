class InformationModel {
  String eMPLOYEEID;
  String fIRSTNAME;
  String lASTNAME;
  String dEPTNAME;
  String rEGIONCODE;
  String tEAM;
  String ownerID;

  InformationModel(
      {this.eMPLOYEEID,
      this.fIRSTNAME,
      this.lASTNAME,
      this.dEPTNAME,
      this.rEGIONCODE,
      this.tEAM,
      this.ownerID});

  InformationModel.fromJson(Map<String, dynamic> json) {
    eMPLOYEEID = json['EMPLOYEE_ID'];
    fIRSTNAME = json['FIRST_NAME'];
    lASTNAME = json['LAST_NAME'];
    dEPTNAME = json['DEPT_NAME'];
    rEGIONCODE = json['REGION_CODE'];
    tEAM = json['TEAM'];
    ownerID = json['Owner_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['LAST_NAME'] = this.lASTNAME;
    data['DEPT_NAME'] = this.dEPTNAME;
    data['REGION_CODE'] = this.rEGIONCODE;
    data['TEAM'] = this.tEAM;
    data['Owner_ID'] = this.ownerID;
    return data;
  }
}
