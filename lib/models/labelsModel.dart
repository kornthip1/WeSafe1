class LabelsModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  LabelsModel({this.isSuccess, this.result, this.message});

  LabelsModel.fromJson(Map<String, dynamic> json) {
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
  int seq;
  String label;
  String labelDesc;
  String dateTimeUpdated;
  String empID;

  Result(
      {this.seq, this.label, this.labelDesc, this.dateTimeUpdated, this.empID});

  Result.fromJson(Map<String, dynamic> json) {
    seq = json['Seq'];
    label = json['Label'];
    labelDesc = json['LabelDesc'];
    dateTimeUpdated = json['DateTimeUpdated'];
    empID = json['EmpID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Seq'] = this.seq;
    data['Label'] = this.label;
    data['LabelDesc'] = this.labelDesc;
    data['DateTimeUpdated'] = this.dateTimeUpdated;
    data['EmpID'] = this.empID;
    return data;
  }
}
