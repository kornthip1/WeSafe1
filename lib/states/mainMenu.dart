import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:wesafe/models/mastcheckListModel.dart';
import 'package:wesafe/models/sqliteChecklistModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/states/mainWorkInfo.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  SQLiteUserModel userModel = new SQLiteUserModel();
  String onwerId = "";
  List<String> mainMenuZ = [];
  int workID;
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<Null> getUserInfo() async {
    List<SQLiteUserModel> models = [];
    SQLiteUserModel _sqliteUserModel;
    await SQLiteHelper().readUserDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        for (var item in models) {
          _sqliteUserModel = SQLiteUserModel(
              canApprove: item.canApprove,
              createdDate: item.createdDate,
              deptName: item.deptName,
              firstName: item.firstName,
              lastName: item.lastName,
              leaderId: item.leaderId,
              leaderName: item.leaderName,
              ownerDesc: item.ownerDesc,
              ownerID: item.ownerID,
              ownerName: item.ownerName,
              pincode: item.pincode,
              position: item.position,
              rsg: item.rsg,
              teamName: item.teamName,
              userID: item.userID,
              userRole: item.userRole);
        }

        setState(() {
          userModel = _sqliteUserModel;
          onwerId = _sqliteUserModel.ownerID;
          getWorkMenu(onwerId, userModel.rsg);
        });
      }
    });
  }

  Future<Null> getWorkMenu(String ownerID, String rsg) async {
    MastMainMenuModel _mainMenuModel;
    try {
      // final client = HttpClient();

      // final request = await client
      //     .postUrl(Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu"));
      // request.headers.set(
      //     HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      // request.write('{"Owner_ID": "$ownerID",   "REGION_CODE": "$rsg"}');
      // final response = await request.close();

      // response.transform(utf8.decoder).listen(
      //   (contents) {
      //     if (contents.contains('Error')) {
      //       contents = contents.replaceAll("[", "").replaceAll("]", "");
      //       normalDialog(context, 'Error', contents);
      //     } else {
      //       _mainMenuModel = MastMainMenuModel.fromJson(json.decode(contents));
      //       for (var item in _mainMenuModel.result) {
      //         if (item.menuMainName != null)
      //           setState(() {
      //             mainMenuZ.add(item.menuMainName);
      //           });
      //       }
      //     } //else
      //   },
      // );

      final response = await http.post(
        Uri.parse('${MyConstant.webService}WeSafeCheckMainMenu'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: '{"Owner_ID": "$ownerID",   "REGION_CODE": "$rsg"}',
      );
      MastMainMenuModel _mainMenuModel =
          MastMainMenuModel.fromJson(jsonDecode(response.body));

      print("### getWorkMenu  = ${_mainMenuModel.result.length}");

      for (int i = 0; i < _mainMenuModel.result.length; i++) {
        if (_mainMenuModel.result != null)
          setState(() {
            mainMenuZ.add(_mainMenuModel.result[i].menuMainName);
          });
      }

      List<SQLiteWorklistModel> models = [];
      await SQLiteHelper().selectLastestWorkID().then((result) {
        if (result == null) {
        } else {
          models = result;
          if (models.length == 0) {
            setState(() {
              workID = 1;
            });
          } else {
            for (var item in models) {
              setState(() {
                workID = item.workID;
              });
            }
          }
        }
      });
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }

  int index = 0;
  List<String> titles = MyConstant.listMenu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหลัก'),
      ),
      drawer: ShowDrawer(userModel: userModel),
      body: buildGridViewMainMenu(context),
    );
  }

  GridView buildGridViewMainMenu(BuildContext context) {
    double widthsize = 0.0;
    widthsize = MediaQuery.of(context).size.width;
    return GridView.count(
      padding: mainMenuZ.length > 4
          ? const EdgeInsets.only(top: 0.0)
          : const EdgeInsets.only(left: 90.0 , right: 90.0),
      crossAxisCount: mainMenuZ.length > 4 ? 2 : 1,
      children: List.generate(mainMenuZ.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              print("main menu  index  : $index");
              SQLiteHelper().deleteWorkAll();
              getCheckList(index, userModel.ownerID);

              if( !mainMenuZ[index].contains("อื่นๆ")){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainWorkInfo(
                    user_model: userModel,
                    workID: workID,
                  ),
                  
                ),
              );
              }
            },
            child: Column(
              children: [
                Text(''),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Container(
                      width: 60,
                      child: ShowIconImage(
                        fromMenu: index == 0 ? "mainO" : "mainOther",
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        child: Padding(
                          padding: mainMenuZ[index].length > 30
                              ? const EdgeInsets.all(0.0)
                              : const EdgeInsets.only(top: 19),
                          child: Text(
                            mainMenuZ[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: mainMenuZ[index].length > 30
                                    ? widthsize * 0.04
                                    : widthsize * 0.05),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(primary: MyConstant.floralWhite),
          ),
        );
      }),
    );
  }

  Future<Null> getCheckList(int mainMenuIndex, String ownerID) async {
    int strmain;
    MastCheckListModel mastCheckListModel;
    strmain = ownerID == "Z"
        ? 300 + mainMenuIndex
        : ownerID == "O"
            ? 200 + mainMenuIndex
            : 100 + mainMenuIndex;

    try {
      final response = await http.post(
        Uri.parse('${MyConstant.webService}WeSafeSelectWorkList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: '{"mainMenu": "$strmain",   "subMenu": "1"}',
      );
      MastCheckListModel responeModel =
          MastCheckListModel.fromJson(jsonDecode(response.body));

      print("### getCheckList  = ${responeModel.result.length}");
      SQLiteChecklistModel _sqLiteChecklistModel;

      for (int i = 0; i < responeModel.result.length; i++) {
        _sqLiteChecklistModel = SQLiteChecklistModel(
            menuChecklistID: responeModel.result[i].menuChecklistID,
            flagRequire: responeModel.result[i].flagRequire,
            menuChecklistDesc: responeModel.result[i].menuChecklistDesc,
            id: i,
            menuChecklistName: responeModel.result[i].menuChecklistName,
            menuMainID: responeModel.result[i].menuMainID,
            menuSubID: responeModel.result[i].menuSubID,
            quantityImg: responeModel.result[i].quantityImg,
            type: responeModel.result[i].type,
            waitApprove: responeModel.result[i].waitApprove);

        print(
            "$i      type : ${_sqLiteChecklistModel.type}    : ${responeModel.result[i].menuChecklistName}");
        SQLiteHelper().insertChecklist(_sqLiteChecklistModel);

        //SQLiteHelper().selectCheclList();
      }
    } catch (e) {
      normalDialog(context, "Error", e.toString());
      print("mainmenu error  : ${e.toString()}");
    }
  }
}
