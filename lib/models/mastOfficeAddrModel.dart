class MastOfficeAddrModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  MastOfficeAddrModel({this.isSuccess, this.result, this.message});

  MastOfficeAddrModel.fromJson(Map<String, dynamic> json) {
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
  String rEGIONGROUP;
  String pEAName;

  Result({this.rEGIONGROUP, this.pEAName});

  Result.fromJson(Map<String, dynamic> json) {
    rEGIONGROUP = json['REGIONGROUP'];
    pEAName = json['PEA_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['REGIONGROUP'] = this.rEGIONGROUP;
    data['PEA_Name'] = this.pEAName;
    return data;
  }
}
