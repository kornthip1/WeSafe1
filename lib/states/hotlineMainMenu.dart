import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastOutageAllList.dart';
import 'package:wesafe/models/sqliteOfficeAddr.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/hotlineSubMenu.dart';
import 'package:wesafe/utility/Test.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
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
  String _myOffice;
  List<String> listOffice = [];

  @override
  // ignore: must_call_super
  void initState() {
    userModel = widget.userModel;
    userModel.ownerID = "H";
    checkConnection(context);
    workListInfo();
  }

  Future<Null> workListInfo() async {
    try {
      //-----step 1
      //bool isInSQLite = false;
      SQLiteHelperOutage().selectMainMenu(1).then((result) async {
        if (result == null) {
          normalDialog(context, "Error", "ไม่มีข้อมูล");
        } else {
          print('######### Hotline result : ${result.length}');
          if (result.length > 0) {
            //isInSQLite = true;
            setState(() {
              SQLiteHotline().selectOffice().then((value) {
                if (value != null) {
                  List<SQLiteMastOfficeAddrModel> list;
                  list = value;
                  for (var item in list) {
                    //print('#######---> ${item.peaName}');
                    listOffice.add(item.regionGroup + ":" + item.peaName);
                  }
                }
              });

              listMenu = result;
              load = false;
            });
          } else {
            // isInSQLite = false;
            listMenu.clear();
            //test
            isConnected = true;
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
                  workListInfo();
                }
              }
            }

            //get Office
            SQLiteHotline().selectOffice().then((value) {
              if (value != null) {
                List<SQLiteMastOfficeAddrModel> list;
                list = value;
                for (var item in list) {
                  setState(() {
                    listOffice.add(item.regionGroup + ":" + item.peaName);
                    load = false;
                  });
                }
              }
            });
          }
        }
      });

      //---- step 2
      // if (!isInSQLite) {
      //   //isConnected
      // }
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
            : Column(
                children: [
                  buildRegion(),
                  buildGridViewMainMenu(context),
                ],
              ), //load ? ShowProgress() : buildGridViewMainMenu(context),
      ),
    );
  }

  Widget buildGridViewMainMenu(BuildContext context) {
    double widthsize = 0.0;
    widthsize = MediaQuery.of(context).size.width;
    return Expanded(
      child: Center(
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

                        if (_myOffice != null) {
                          // print('direct....');
                          // print('#####---- > $_myOffice');
                          String rsg = _myOffice.split(':')[0].toString();
                          print('#####---- > $rsg');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => (HotlineSubMenu(
                                MenuName: listMenu[index].menuMainName,
                                MenuID: listMenu[index].menuMainID,
                                userModel: userModel,
                                rsg: rsg,
                              )),
                            ),
                          );
                        } else {
                          normalDialog(context, 'เตือน',
                              'กรุณาระบุการไฟฟ้าที่ปฏิบัติงาน');
                        }
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: index == 3
                                  ? widthsize * 0.2
                                  : widthsize * 0.149,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: ShowIconImage(
                                  fromMenu: index == 0
                                      ? "mainH1"
                                      : index == 1
                                          ? "mainH3"
                                          : index == 2
                                              ? "mainH4"
                                              : index == 3
                                                  ? "mainH2"
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
      ),
    );
  }

  Widget buildRegion() {
    double widthsize = 0.0;
    widthsize = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Card(
        color: Colors.purple[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ระบุการไฟฟ้าที่ปฏิบัติงาน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widthsize * 0.045,
                        color: Colors.black),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: DropdownButton<String>(
                            iconEnabledColor: Colors.purple[600],
                            value: _myOffice,
                            iconSize: 30,
                            icon: const Icon(Icons
                                .arrow_drop_down_outlined), //arrow_drop_down
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            hint: Text('Select Region'),
                            onChanged: (String newValue) {
                              setState(() {
                                _myOffice = newValue;
                              });
                            },
                            items: listOffice.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} // class
