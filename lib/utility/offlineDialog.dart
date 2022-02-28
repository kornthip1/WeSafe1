import 'package:flutter/material.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/outageWorklistClose.dart';
import 'package:wesafe/widgets/showTitle.dart';

Future<Null> offilineDialog(
    BuildContext context,
    String title,
    String message,
    String reqNo,
    SQLiteUserModel userModel,
    int workStatus,
    String mainID) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Icon(
          Icons.wifi_off_outlined,
          size: 40,
          color: Colors.red,
        ),
        title: ShowTitle(
          title: title,
          index: 0,
        ),
        subtitle: ShowTitle(title: message, index: 1),
      ),
      children: [
        Container(
          child: Column(
            children: [
              Card(
                child: TextButton(
                    onPressed: () {
                      print("checklist...." + reqNo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OutageWorklistClose(
                                  userModel: userModel,
                                  reqNo: reqNo,
                                  workStatus: workStatus,
                                  mainID: mainID,
                                )),
                      );
                    },
                    child: Text('ต้องการ')),
              ),
              Card(
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('ไม่ต้องการ')),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
