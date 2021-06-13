
class Errormodel {
  String error;

  Errormodel({this.error});

  Errormodel.fromJson(Map<String, dynamic> json) {
    error = json['Error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Error'] = this.error;
    return data;
  }
}
