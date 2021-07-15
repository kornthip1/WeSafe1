class MyConstainUserProfileDB {
  static final String nameUserTable = 'mastUserProfile';
  static final String columnUserID = 'userID';
  static final String columnFirstName = 'firstName';
  static final String columnLastName = 'lastName';
  static final String columnPosition = 'position';
  static final String columnDeptName = 'deptName';
  static final String columnRegionCode = 'regionCode';
  static final String columnTeamName = 'teamName';
  static final String columnLeaderId = 'leaderId';
  static final String columnLeaderName = 'leaderName';
  static final String columnOwnerID = 'ownerID';
  static final String columnOwnerName = 'ownerName';
  static final String columnOwnerDesc = 'ownerDesc';
  static final String columnUserRole = 'userRole';
  static final String columnCanApprove = 'canApprove';
  static final String columnPincode = 'pincode';
  static final String columnCreatedDate = 'createdDate';
}

class MyConstainWorklistDB {
  static final String nameTable = 'mastWorklist';
  static final String columnworkID = 'workID';
  static final String columnuserID = 'userID';
  static final String columnrsg = 'rsg';
  static final String columnownerID = 'ownerID';
  static final String columnmainWorkID = 'mainWorkID';
  static final String columnsubWorkID = 'subWorkID';
  static final String columnChecklistID = 'checklistID';
  static final String columnLat = 'lat';
  static final String columnLng = 'lng';
  static final String columnWorkPerform = 'workPerform';
  static final String columnRemark = 'remark';
  static final String columnIsChoice = 'isChoice';
  static final String columnReason = 'reason';
  static final String columnMsgFromWeb = 'msgFromWeb';
  static final String columnIsComplete = 'isComplete';
  static final String columnCreateDate = 'createDate';
  static final String columnUploadDate = 'uploadDate';

  static final String columnWorkRegion = 'workRegion';
  static final String columnWorkProvince = 'workProvince';
  static final String columnWorkStation = 'workStation';
  static final String columnWorkType = 'workType';
  static final String columnWorkDoc = 'workDoc';

  static final String columnImgList = 'imgList';
}

class MyConstainImagesDB {
  static final String nameUserTable = 'mastImg';
  static final String columnworkID = 'workID';
  static final String columnmainWorkID = 'mainWorkID';
  static final String columnsubWorkID = 'subWorkID';
  static final String columnChecklistID = 'checklistID';
  static final String columnSequenceImg = 'sequenceImg';
  static final String columnBase64Img = 'base64Img';
  static final String columnIsComplete = 'isComplete';
  static final String columnCreateDate = 'createDate';
  static final String columnUploadDate = 'uploadDate';
}

class MyConstainPercelDB {
  static final String nameTable = 'mastParcel';
  static final String columnworkID = 'workID';
  static final String columnmainWorkID = 'mainWorkID';
  static final String columnsubWorkID = 'subWorkID';
  static final String columnChecklistID = 'checklistID';
  static final String columnItem = 'item';
  static final String columnAmount = 'amount';
  static final String columnIsComplete = 'isComplete';
  static final String columnCreateDate = 'createDate';
}

class MyConstainStationInfoDB {
  static final String nameStationTable = 'mastStation';
  static final String columnRegionCode = 'regionCode';
  static final String columnRegionName = 'regionName';
  static final String columnProvince = 'province';
  static final String columnStationId = 'stationId';
  static final String columnStationName = 'stationName';
  static final String columnCreateDate = 'createdDate';
  static final String columnUpdatedDate = 'updatedDate';
}
