class InsertWorklistModel {
  String _reqNo;
  String _regionCode;
  String _menuMainID;
  String _menuSubID;
  String _menuChecklistID;
  String _employeeID;
  String _empLeaderID;
  String _workStatus;
  String _locationLat;
  String _locationLng;
  String _waitApprove;
  String _dateTimeWorkFinish;
  String _workPerform;
  String _isSortGND;
  String _gNDReason;
  String _isOffElect;
  String _offElectReason;
  String _parcel;
  List<String> _image;
  String _deptName;
  String _workArea;
  String _province;
  String _station;
  String _workType;
  String _docRequire;
  String _ownerID;
  String _remark;
  String _sender;
  String _tokenNoti;
  String _macAddress;
  String _iPAddress;

  InsertWorklistModel(
      {String reqNo,
      String regionCode,
      String menuMainID,
      String menuSubID,
      String menuChecklistID,
      String employeeID,
      String empLeaderID,
      String workStatus,
      String locationLat,
      String locationLng,
      String waitApprove,
      String dateTimeWorkFinish,
      String workPerform,
      String isSortGND,
      String gNDReason,
      String isOffElect,
      String offElectReason,
      String parcel,
      List<String> image,
      String deptName,
      String workArea,
      String province,
      String station,
      String workType,
      String docRequire,
      String ownerID,
      String remark,
      String sender,
      String tokenNoti,
      String macAddress,
      String iPAddress}) {
    this._reqNo = reqNo;
    this._regionCode = regionCode;
    this._menuMainID = menuMainID;
    this._menuSubID = menuSubID;
    this._menuChecklistID = menuChecklistID;
    this._employeeID = employeeID;
    this._empLeaderID = empLeaderID;
    this._workStatus = workStatus;
    this._locationLat = locationLat;
    this._locationLng = locationLng;
    this._waitApprove = waitApprove;
    this._dateTimeWorkFinish = dateTimeWorkFinish;
    this._workPerform = workPerform;
    this._isSortGND = isSortGND;
    this._gNDReason = gNDReason;
    this._isOffElect = isOffElect;
    this._offElectReason = offElectReason;
    this._parcel = parcel;
    this._image = image;
    this._deptName = deptName;
    this._workArea = workArea;
    this._province = province;
    this._station = station;
    this._workType = workType;
    this._docRequire = docRequire;
    this._ownerID = ownerID;
    this._remark = remark;
    this._sender = sender;
    this._tokenNoti = tokenNoti;
    this._macAddress = macAddress;
    this._iPAddress = iPAddress;
  }

  String get reqNo => _reqNo;
  set reqNo(String reqNo) => _reqNo = reqNo;

  String get regionCode => _regionCode;
  set regionCode(String regionCode) => _regionCode = regionCode;
  String get menuMainID => _menuMainID;
  set menuMainID(String menuMainID) => _menuMainID = menuMainID;
  String get menuSubID => _menuSubID;
  set menuSubID(String menuSubID) => _menuSubID = menuSubID;
  String get menuChecklistID => _menuChecklistID;
  set menuChecklistID(String menuChecklistID) =>
      _menuChecklistID = menuChecklistID;
  String get employeeID => _employeeID;
  set employeeID(String employeeID) => _employeeID = employeeID;
  String get empLeaderID => _empLeaderID;
  set empLeaderID(String empLeaderID) => _empLeaderID = empLeaderID;
  String get workStatus => _workStatus;
  set workStatus(String workStatus) => _workStatus = workStatus;
  String get locationLat => _locationLat;
  set locationLat(String locationLat) => _locationLat = locationLat;
  String get locationLng => _locationLng;
  set locationLng(String locationLng) => _locationLng = locationLng;
  String get waitApprove => _waitApprove;
  set waitApprove(String waitApprove) => _waitApprove = waitApprove;
  String get dateTimeWorkFinish => _dateTimeWorkFinish;
  set dateTimeWorkFinish(String dateTimeWorkFinish) =>
      _dateTimeWorkFinish = dateTimeWorkFinish;
  String get workPerform => _workPerform;
  set workPerform(String workPerform) => _workPerform = workPerform;
  String get isSortGND => _isSortGND;
  set isSortGND(String isSortGND) => _isSortGND = isSortGND;
  String get gNDReason => _gNDReason;
  set gNDReason(String gNDReason) => _gNDReason = gNDReason;
  String get isOffElect => _isOffElect;
  set isOffElect(String isOffElect) => _isOffElect = isOffElect;
  String get offElectReason => _offElectReason;
  set offElectReason(String offElectReason) => _offElectReason = offElectReason;
  String get parcel => _parcel;
  set parcel(String parcel) => _parcel = parcel;
  List<String> get image => _image;
  set image(List<String> image) => _image = image;
  String get deptName => _deptName;
  set deptName(String deptName) => _deptName = deptName;
  String get workArea => _workArea;
  set workArea(String workArea) => _workArea = workArea;
  String get province => _province;
  set province(String province) => _province = province;
  String get station => _station;
  set station(String station) => _station = station;
  String get workType => _workType;
  set workType(String workType) => _workType = workType;
  String get docRequire => _docRequire;
  set docRequire(String docRequire) => _docRequire = docRequire;
  String get ownerID => _ownerID;
  set ownerID(String ownerID) => _ownerID = ownerID;
  String get remark => _remark;
  set remark(String remark) => _remark = remark;
  String get sender => _sender;
  set sender(String sender) => _sender = sender;
  String get tokenNoti => _tokenNoti;
  set tokenNoti(String tokenNoti) => _tokenNoti = tokenNoti;
  String get macAddress => _macAddress;
  set macAddress(String macAddress) => _macAddress = macAddress;
  String get iPAddress => _iPAddress;
  set iPAddress(String iPAddress) => _iPAddress = iPAddress;

  InsertWorklistModel.fromJson(Map<String, dynamic> json) {
    _reqNo = json['Req_No'];
    _regionCode = json['Region_Code'];
    _menuMainID = json['MenuMain_ID'];
    _menuSubID = json['MenuSub_ID'];
    _menuChecklistID = json['Menu_Checklist_ID'];
    _employeeID = json['Employee_ID'];
    _empLeaderID = json['EmpLeader_ID'];
    _workStatus = json['Work_Status'];
    _locationLat = json['Location_Lat'];
    _locationLng = json['Location_Lng'];
    _waitApprove = json['Wait_Approve'];
    _dateTimeWorkFinish = json['DateTime_WorkFinish'];
    _workPerform = json['WorkPerform'];
    _isSortGND = json['IsSortGND'];
    _gNDReason = json['GNDReason'];
    _isOffElect = json['Is_OffElect'];
    _offElectReason = json['OffElectReason'];
    _parcel = json['Parcel'];
    _image = json['Image'].cast<String>();
    _deptName = json['DeptName'];
    _workArea = json['WorkArea'];
    _province = json['Province'];
    _station = json['Station'];
    _workType = json['WorkType'];
    _docRequire = json['DocRequire'];
    _ownerID = json['OwnerID'];
    _remark = json['Remark'];
    _sender = json['Sender'];
    _tokenNoti = json['TokenNoti'];
    _macAddress = json['MacAddress'];
    _iPAddress = json['IPAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Req_No'] = this._reqNo;
    data['Region_Code'] = this._regionCode;
    data['MenuMain_ID'] = this._menuMainID;
    data['MenuSub_ID'] = this._menuSubID;
    data['Menu_Checklist_ID'] = this._menuChecklistID;
    data['Employee_ID'] = this._employeeID;
    data['EmpLeader_ID'] = this._empLeaderID;
    data['Work_Status'] = this._workStatus;
    data['Location_Lat'] = this._locationLat;
    data['Location_Lng'] = this._locationLng;
    data['Wait_Approve'] = this._waitApprove;
    data['DateTime_WorkFinish'] = this._dateTimeWorkFinish;
    data['WorkPerform'] = this._workPerform;
    data['IsSortGND'] = this._isSortGND;
    data['GNDReason'] = this._gNDReason;
    data['Is_OffElect'] = this._isOffElect;
    data['OffElectReason'] = this._offElectReason;
    data['Parcel'] = this._parcel;
    data['Image'] = this._image;
    data['DeptName'] = this._deptName;
    data['WorkArea'] = this._workArea;
    data['Province'] = this._province;
    data['Station'] = this._station;
    data['WorkType'] = this._workType;
    data['DocRequire'] = this._docRequire;
    data['OwnerID'] = this._ownerID;
    data['Remark'] = this._remark;
    data['Sender'] = this._sender;
    data['TokenNoti'] = this._tokenNoti;
    data['MacAddress'] = this._macAddress;
    data['IPAddress'] = this._iPAddress;
    return data;
  }
}
