import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastOutageAllList.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/hotlineSubMenu.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class HotlineMainMenu extends StatefulWidget {
  final SQLiteUserModel userModel;
  HotlineMainMenu({@required this.userModel});

  @override
  State<HotlineMainMenu> createState() => _HotlineMainMenuState();
}

class _HotlineMainMenuState extends State<HotlineMainMenu> {
  SQLiteUserModel userModel;
  List<MastOutageMenuModel> listMenu = [];
  bool load = true;
  bool isConnected = false;

  @override
  void initState() {
    userModel = widget.userModel;
    userModel.ownerID = "H";
    checkConnection(context);
    workListInfo();
  }

  Future<Null> workListInfo() async {
    try {
      //-----step 1
      bool isInSQLite = false;
      SQLiteHelperOutage().selectMainMenu(1).then((result) {
        if (result == null) {
          normalDialog(context, "Error", "ไม่มีข้อมูล");
        } else {
          if (result.length > 0) {
            isInSQLite = true;
            setState(() {
              listMenu = result;
              load = false;
            });
          } else {
            isInSQLite = false;
          }
        }
      });

      //---- step 2
      if (!isInSQLite) {
        if (isConnected) {
          final response = await http.get(
            Uri.parse('${MyConstant.newService}workmenu/list_all'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
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

              if (listAllModel.result[j].menuMainID.toString().contains("10") &&
                  listAllModel.result[j].menuSubID.toString().contains("1")) {
                setState(() {
                  listMenu.add(menuModel);
                  load = false;
                });
              }
            }
          }
        } //isConnected
      }
    } catch (e) {
      AlertDialog(
        title: Title(color: Colors.red, child: Text(e.toString())),
      );
    }
  }

  void checkConnection(BuildContext context) async {
    final bool isConn = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = isConn;
    });
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
          title: ShowTitle(title: "งานด้าน Hotline", index: 3),
        ),
        drawer: ShowDrawer(userModel: userModel),
        body: load
            ? ShowProgress()
            : buildGridViewMainMenu(
                context), //load ? ShowProgress() : buildGridViewMainMenu(context),
      ),
    );
  }

  Widget buildGridViewMainMenu(BuildContext context) {
    double widthsize = 0.0;
    widthsize = MediaQuery.of(context).size.width;
    return Center(
      child: GridView.count(
          padding: listMenu.length >= 4
              ? const EdgeInsets.only(top: 35.0)
              : const EdgeInsets.only(left: 90.0, right: 90.0),
          crossAxisCount: listMenu.length >= 4 ? 2 : 1,
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
                          builder: (context) => (HotlineSubMenu(
                            MenuName: listMenu[index].menuMainName,
                            MenuID: listMenu[index].menuMainID,
                            userModel: userModel,
                          )),
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
                                    ? "mainH1"
                                    : index == 1
                                        ? "mainH1"
                                        : index == 2
                                            ? "mainH1"
                                            : index == 3
                                                ? "mainH1"
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
                            ? Colors.grey[200]
                            : index == 1
                                ? MyConstant.outageMenu1
                                : index == 2
                                    ? MyConstant.outageMenu3
                                    : index == 3
                                        ? MyConstant.outageMenu4
                                        : MyConstant.primart),
                  ),
                ));
          })),
    );
  }
} // class
