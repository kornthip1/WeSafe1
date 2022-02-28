import 'package:flutter/material.dart';
import 'package:wesafe/models/mastLables.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showTitle.dart';

class ShowLables extends StatelessWidget {
  final int index;
  ShowLables({@required this.index});

  @override
  Widget build(BuildContext context) {
    return ShowTitle(title: getLable(3), index: 3);
  }

  String getLable(int index) {
    String lblHeader = "";
    List<MastLabelsModel> models;
    SQLiteHelperOutage().selectLables("3").then((result) {
      if (result == null) {
        lblHeader = "";
      } else {
        models = result;
        for (var item in models) {
          lblHeader = item.label;
          print("########### ->>>>  result : " + lblHeader);
        }
      }
    });
    print("########### ->>>> reutrn  result : " + lblHeader);
    return lblHeader;
  }
}
