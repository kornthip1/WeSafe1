class ResponeModel {
  bool isSuccess;
  Result result;
  Null message;

  ResponeModel({this.isSuccess, this.result, this.message});

  ResponeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    result =
        json['Result'] != null ? new Result.fromJson(json['Result']) : null;
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['Result'] = this.result.toJson();
    }
    data['Message'] = this.message;
    return data;
  }
}

class Result {
  String reply;

  Result({this.reply});

  Result.fromJson(Map<String, dynamic> json) {
    reply = json['reply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reply'] = this.reply;
    return data;
  }
}
