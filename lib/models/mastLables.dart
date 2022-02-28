import 'dart:convert';

class MastLabelsModel {
  int seq;
  String label;
  String labelDesc;
  String dateTimeUpdated;
  String empID;

  MastLabelsModel({
    this.seq,
    this.label,
    this.labelDesc,
    this.dateTimeUpdated,
    this.empID,
  });

  MastLabelsModel copyWith({
    int seq,
    String label,
    String labelDesc,
    String dateTimeUpdated,
    String empID,
  }) {
    return MastLabelsModel(
      seq: seq ?? this.seq,
      label: label ?? this.label,
      labelDesc: labelDesc ?? this.labelDesc,
      dateTimeUpdated: dateTimeUpdated ?? this.dateTimeUpdated,
      empID: empID ?? this.empID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Seq': seq,
      'Label': label,
      'LabelDesc': labelDesc,
      'DateTimeUpdated': dateTimeUpdated,
      'EmpID': empID,
    };
  }

  factory MastLabelsModel.fromMap(Map<String, dynamic> map) {
    return MastLabelsModel(
      seq: map['Seq'],
      label: map['Label'],
      labelDesc: map['LabelDesc'],
      dateTimeUpdated: map['DateTimeUpdated'],
      empID: map['EmpID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MastLabelsModel.fromJson(String source) =>
      MastLabelsModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MastLabelsModel &&
        other.seq == seq &&
        other.label == label &&
        other.labelDesc == labelDesc &&
        other.dateTimeUpdated == dateTimeUpdated &&
        other.empID == empID;
  }

  @override
  int get hashCode {
    return seq.hashCode ^
        label.hashCode ^
        labelDesc.hashCode ^
        dateTimeUpdated.hashCode ^
        empID.hashCode;
  }
} //class
