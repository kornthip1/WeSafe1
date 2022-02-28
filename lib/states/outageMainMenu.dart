import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/mastOutageAllList.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/outageWorklist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../models/MastOutageMenuModel.dart';
import 'package:http/http.dart' as http;

class OutageMainMenu extends StatefulWidget {
  final SQLiteUserModel userModel;
  OutageMainMenu({@required this.userModel});
  @override
  _OutageMainMenuState createState() => _OutageMainMenuState();
}

class _OutageMainMenuState extends State<OutageMainMenu> {
  TextEditingController workController = TextEditingController();

  SQLiteUserModel userModel;
  String choose;
  List<SQLiteWorklistOutageModel> models = [];
  List<MastOutageMenuModel> listMenu = [];
  bool isConnected = false;
  String lblHeader;
  bool load = true;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readWorkList();
    checkConnection(context);
  }

  Future<Null> readWorkList() async {
    try {
      final bool isConn = await InternetConnectionChecker().hasConnection;
      if (isConn) {
        final response = await http.get(
          Uri.parse('${MyConstant.newService}workmenu/list_all'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          //body: '{"mainMenu": "${widget.mainID}",   "subMenu": "1"}',
        );

        MastOutageAllListModel checklistmodel =
            MastOutageAllListModel.fromJson(jsonDecode(response.body));

        if (!checklistmodel.isSuccess) {
          normalDialog(context, 'Error', checklistmodel.message);
        } else {
          MastOutageAllListModel listAllModel;
          listAllModel = checklistmodel;
          for (int j = 0; j < listAllModel.result.length; j++) {
            MastOutageMenuModel menuModel = MastOutageMenuModel(
                dateCreated: MyConstant.strDateNow,
                menuMainID: listAllModel.result[j].menuMainID,
                menuMainName: listAllModel.result[j].menuMainName,
                menuSubID: listAllModel.result[j].menuSubID,
                menuSubName: listAllModel.result[j].menuSubName,
                menuListID: listAllModel.result[j].menuChecklistID,
                menuListName: listAllModel.result[j].menuChecklistName,
                type: listAllModel.result[j].type,
                isChoice: listAllModel.result[j].isChoice,
                quantityImg: listAllModel.result[j].quantityImg);
            SQLiteHelperOutage().insertMenu(menuModel);
          }
        } //else
      }

      SQLiteHelperOutage().selectMainMenu(2).then((result) {
        if (result == null) {
          normalDialog(context, "Error", "ไม่มีข้อมูล");
        } else {
          setState(() {
            listMenu = result;
            load = false;
          });
        }
      });

      //else

      //---------------> Labels issue
      // List<MastLabelsModel> models;
      // SQLiteHelperOutage().selectLables("3").then((result) {
      //   if (result == null) {
      //     normalDialog(context, "Error", "ไม่มีข้อมูล");
      //   } else {
      //     models = result;
      //     for (var item in models) {
      //       setState(() {
      //         lblHeader = item.label;
      //       });
      //     }
      //   }
      // });

      //print("######-------------> IP : " + MyConstant.strIP.toString());
    } catch (e) {
      print("MainMenu Error : " + e.toString());
      if (isConnected) {
        normalDialog(context, "Error", e.toString());
      } else {
        SQLiteHelperOutage().selectMainMenu(2).then((result) {
          if (result == null) {
            normalDialog(context, "Error", "ไม่มีข้อมูล");
          } else {
            setState(() {
              listMenu = result;
              print("listMenu ------>" + listMenu.length.toString());
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ShowTitle(title: "งานปฏิบัติการและบำรุงรักษา", index: 3),
        ),
        drawer: ShowDrawer(userModel: userModel),
        body: load ? ShowProgress() : buildGridViewMainMenu(context),
      ),
    );
  }

  Widget buildGridViewMainMenu(BuildContext context) {
    double widthsize = 0.0;
    widthsize = MediaQuery.of(context).size.width;
    return GridView.count(
        padding: listMenu.length > 4
            ? const EdgeInsets.only(top: 0.0)
            : const EdgeInsets.only(left: 90.0, right: 90.0),
        crossAxisCount: listMenu.length > 4 ? 2 : 1,
        children: List.generate(listMenu.length, (index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ElevatedButton(
                  onPressed: () {
                    print("main Menu " +
                        listMenu[index].menuMainName +
                        "   subMenu :" +
                        (index + 1).toString());
                    print('main menu : ${listMenu[index].menuMainID}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OutageWorkList(
                          userModel: userModel,
                          mainID: listMenu[index].menuMainID.toString(),
                          mainName: listMenu[index].menuMainName,
                          workId: 0,
                          isMainLine: "1",
                          workPerform: "",
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: widthsize * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ShowIconImage(
                              fromMenu: index == 0
                                  ? "mainO"
                                  : index == 1
                                      ? "mainO2"
                                      : index == 2
                                          ? "mainO3"
                                          : index == 3
                                              ? "mainO4"
                                              : "mainOther",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          listMenu[index].menuMainName,
                          style: TextStyle(
                            color: index == listMenu.length - 1
                                ? Colors.white
                                : Colors.black,
                            fontSize: widthsize * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: index == 0
                          ? MyConstant.outageMenu2
                          : index == 1
                              ? MyConstant.outageMenu1
                              : index == 2
                                  ? MyConstant.outageMenu3
                                  : index == 3
                                      ? MyConstant.outageMenu4
                                      : MyConstant.primart),
                ),
              ));
        }));
  }

  void checkConnection(BuildContext context) async {
    final bool isConn = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = isConn;
    });
  }
}
