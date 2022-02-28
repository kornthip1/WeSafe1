import 'package:flutter/material.dart';
import 'package:wesafe/models/sqliteUserModel.dart';

import 'package:wesafe/states/outageMainMenu.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showTitle.dart';

Future<Null> offilineAlert(BuildContext context, String title, String message,
    SQLiteUserModel userModel, String reqNo, int status) async {
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
                      
                     
                      SQLiteHelperOutage().updateWorkListStatus(status, reqNo);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutageMainMenu(
                            userModel: userModel,
                            //  userModel: userModel,
                            // ownerId: userModel.ownerID,
                          ),
                        ),
                      );
                    },
                    child: Text('ตกลง')),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
