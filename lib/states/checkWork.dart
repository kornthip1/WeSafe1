import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/checkStatusModel.dart';
import 'package:wesafe/states/CloseList.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

import 'mainMenu.dart';

class CheckWork extends StatefulWidget {
  @override
  _CheckWorkState createState() => _CheckWorkState();
}

class _CheckWorkState extends State<CheckWork> {
  int index = 0;
  SQLiteUserModel _userModel;
  SQLiteWorklistModel _sqLiteWorklistModel;
  String tt = "";
  CheckStatusModel checkSatatusModel;
  @override
  void initState() {
    super.initState();
    readWorklist()
        .then((value) => print("initial readWorklist  value : $value"));
    readUserInfo()
        .then((value) => print("initial readUserInfo  value : $value"));
  }

  @override
  Widget build(BuildContext context) {
    //readUserInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text("ตรวจสอบสถานะการทำงาน"),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildNewJob(context),
                buildCheckStatus(context),
              ],
            ),
            buildSignOut()
          ],
        ),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    // print("########  checkSatatusModel   ");

    if (checkSatatusModel != null) {
      // for (var item in checkSatatusModel.result) {
      //   print("########  checkSatatusModel  req no : ${item.reqNo} ");
      // }

      return Container(
        child: new ListView.builder(
          itemCount: checkSatatusModel.result == null
              ? 0
              : checkSatatusModel.result.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              if (checkSatatusModel.result[index].jobStatus == "4") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CloseList(
                      user_model: _userModel,
                      reqNo : checkSatatusModel.result[index].reqNo
                    ),
                  ),
                );
              } else {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MainList(
                //       sqLiteWorklistModel: _sqLiteWorklistModel,
                //       user_model: _userModel,
                //     ),
                //   ),
                // );

              }
            },
            child: Card(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      ShowTitle(
                        title: checkSatatusModel.result == null
                            ? ""
                            : checkSatatusModel.result[index].reqNo,
                        index: 4,
                      ),
                      ShowTitle(
                        title: "การปฏิบัติงานภายในสถานีไฟฟ้าและระบบไฟฟ้า",
                        index: 2,
                      ),
                      ShowTitle(
                        title: "",
                        // title: _sqLiteWorklistModel.workRegion +
                        //     " " +
                        //     _sqLiteWorklistModel.workStation,
                        index: 2,
                      ),
                      ShowTitle(
                        title: checkSatatusModel.result == null
                            ? ""
                            : checkSatatusModel.result[index].jobStatusName,
                        index: 4,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<Null> readWorklist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _user = preferences.getString('USER');

    print("######## readWorklist()  user  :  $_user");
    try {
      final client = HttpClient();
      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_CheckStatus"));
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=utf-8");
      request.write('{"empID": "$_user"}');
      final response = await request.close();

      response.transform(utf8.decoder).listen(
        (contents) {
          print("###### -- >  contents : $contents");
          if (contents.contains('Error')) {
            contents = contents.replaceAll("[", "").replaceAll("]", "");
            normalDialog(context, 'Error', contents);
          } else {
            setState(() {
              checkSatatusModel =
                  CheckStatusModel.fromJson(json.decode(contents));
            });
          } //else
        },
      );

      // SQLiteWorklistModel sqlIteWorkModel;
      // for (int i = 0; i < checkSatatusModel.result.length; i++) {
      //   getWorkInfo(checkSatatusModel.result[i].reqNo);
      //   sqlIteWorkModel = SQLiteWorklistModel(
      //     reqNo: checkSatatusModel.result[i].reqNo,
      //     workProvince: _sqLiteWorklistModel.workProvince,
      //     workRegion: _sqLiteWorklistModel.workRegion,
      //     workStation: _sqLiteWorklistModel.workStation,
      //   );
      // }

      // setState(() {
      //   _sqLiteWorklistModel = sqlIteWorkModel;
      // });
    } catch (e) {
      print("###### -- >  readWorklist Error : ${e.toString()}");
    }
  }

  Future<Null> readUserInfo() async {
    SQLiteUserModel sqLiteUserModel;
    List<SQLiteUserModel> models = [];
    await SQLiteHelper().readUserDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;

        for (var item in models) {
          // print("CHECK()  #####  id ${item.userID}");
          // print("CHECK()  #####  id ${item.firstName}");
          // print("CHECK()  #####  region ${item.ownerID}");
          // print("CHECK()  #####  region ${item.ownerName}");

          sqLiteUserModel = SQLiteUserModel(
            userID: item.userID,
            firstName: item.firstName,
            lastName: item.lastName,
            deptName: item.deptName,
            ownerID: item.ownerID,
            ownerName: item.ownerName,
            pincode: item.pincode,
          );
        } //for
      }
    });
    setState(() {
      _userModel = sqLiteUserModel;
    });
  }

  Future<Null> getWorkInfo(String reqNo) async {
    await SQLiteHelper().readWorkByReqNoModel(reqNo).then((result) {
      setState(() {
        _sqLiteWorklistModel = result;
      });
    });
  }

/************ LEFT MENU */
  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primart),
      currentAccountPicture: ShowMan(),
      accountName: _userModel == null
          ? Text('Name')
          : Text('${_userModel.firstName}  ${_userModel.lastName}'),
      accountEmail: _userModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${_userModel.deptName}'),
    );
  }

  ListTile buildNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[0],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        //Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenu(
                //userModel: _userModel,
                //  ownerId: _userModel.ownerID,
                ),
          ),
        );
      },
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: Colors.red[900],
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign out',
            index: 3,
          ),
        ),
      ],
    );
  }

  ListTile buildCheckStatus(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_outline,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[1],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
      },
    );
  }
}
