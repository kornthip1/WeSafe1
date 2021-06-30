class MastImgModel {
  String workID;
  String mainWorkID;
  int subWorkID;
  int checklistID;
  int sequenceImg;
  String base64Img;
  String createDate;
  String uploadDate;

  MastImgModel(
      {this.workID,
      this.mainWorkID,
      this.subWorkID,
      this.checklistID,
      this.sequenceImg,
      this.base64Img,
      this.createDate,
      this.uploadDate});

  MastImgModel.fromJson(Map<String, dynamic> json) {
    workID = json['work_ID'];
    mainWorkID = json['mainWork_ID'];
    subWorkID = json['subWork_ID'];
    checklistID = json['checklist_ID'];
    sequenceImg = json['sequenceImg'];
    base64Img = json['base64Img'];
    createDate = json['createDate'];
    uploadDate = json['uploadDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['work_ID'] = this.workID;
    data['mainWork_ID'] = this.mainWorkID;
    data['subWork_ID'] = this.subWorkID;
    data['checklist_ID'] = this.checklistID;
    data['sequenceImg'] = this.sequenceImg;
    data['base64Img'] = this.base64Img;
    data['createDate'] = this.createDate;
    data['uploadDate'] = this.uploadDate;
    return data;
  }
}
