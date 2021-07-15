class MastStationModel {
  bool isSuccess;
  List<Result> result;
  Null message;

  MastStationModel({this.isSuccess, this.result, this.message});

  MastStationModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    if (json['Result'] != null) {
      result = new List<Result>();
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
  String stationID;
  String stationName;
  String stationPEA;
  String stationProvince;
  String stationType;
  String stationVolt;
  String stationStart;
  String stationWork;
  String stationSystem;

  Result(
      {this.stationID,
      this.stationName,
      this.stationPEA,
      this.stationProvince,
      this.stationType,
      this.stationVolt,
      this.stationStart,
      this.stationWork,
      this.stationSystem});

  Result.fromJson(Map<String, dynamic> json) {
    stationID = json['StationID'];
    stationName = json['StationName'];
    stationPEA = json['StationPEA'];
    stationProvince = json['StationProvince'];
    stationType = json['StationType'];
    stationVolt = json['StationVolt'];
    stationStart = json['StationStart'];
    stationWork = json['StationWork'];
    stationSystem = json['StationSystem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StationID'] = this.stationID;
    data['StationName'] = this.stationName;
    data['StationPEA'] = this.stationPEA;
    data['StationProvince'] = this.stationProvince;
    data['StationType'] = this.stationType;
    data['StationVolt'] = this.stationVolt;
    data['StationStart'] = this.stationStart;
    data['StationWork'] = this.stationWork;
    data['StationSystem'] = this.stationSystem;
    return data;
  }
}
