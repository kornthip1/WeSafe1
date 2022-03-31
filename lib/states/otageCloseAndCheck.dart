import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastCheckWorkListModel.dart';
import 'package:wesafe/models/mastOutageAllList.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/outageWorklistClose.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/offlineDialog.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';

class OtageCloseAndCheck extends StatefulWidget {
  final SQLiteUserModel userModel;
  OtageCloseAndCheck({@required this.userModel});

  @override
  _OtageCloseAndCheckState createState() => _OtageCloseAndCheckState();
}

class _OtageCloseAndCheckState extends State<OtageCloseAndCheck> {
  SQLiteUserModel userModel;
  MastCheckWorkListModel modelCheck;
  List<SQLiteWorklistOutageModel> models = [];
  bool isConnected = false;
  bool load = true;

  @override
  void initState() {
    userModel = widget.userModel;
    checkConnection(context);
    readAllWork();
  }

  void checkConnection(BuildContext context) async {
    final bool isConn = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = isConn;
    });
  }

  Future<void> readAllWork() async {
    //final bool isConn = await InternetConnectionChecker().hasConnection;
    try {
      //isConnected = true;
      bool isSqlite = false;
      SQLiteHelperOutage().selectWorkListForCheck().then((result) async {
        if (result == null) {
          print("result error");
        } else {
          setState(() {
            models = result;
            isSqlite = models.length > 0 ? true : false;
            load = false;
          });

          if (isConnected) {
            final response = await http.post(
              Uri.parse('${MyConstant.newService}request/check'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: '{"Region_Code":  "${userModel.rsg}"  }',
            );

            // final responseList = await http.get(
            //   Uri.parse('${MyConstant.newService}workmenu/list_all'),
            //   headers: <String, String>{
            //     'Content-Type': 'application/json; charset=UTF-8',
            //   },
            // );

            if (!isSqlite) {
              setState(() {
                load = false;
                modelCheck =
                    MastCheckWorkListModel.fromJson(jsonDecode(response.body));
                for (var item in modelCheck.result) {
                  print(
                      "check close : ${userModel.userID} :  ${item.employee_ID}  ");
                  if (userModel.userID.contains(item.employee_ID)) {
                    SQLiteWorklistOutageModel sqlMpdel =
                        SQLiteWorklistOutageModel(
                      checklist: item.menuChecklistID,
                      dateCreated: MyConstant.strDateNow,
                      doOrNot: 0,
                      imgList: null,
                      isComplete: int.parse(item.mastStatus),
                      isMainLine: null == item.isMainLine
                          ? 0
                          : int.parse(item.isMainLine),
                      latitude: null,
                      longtitude: null,
                      region: userModel.rsg,
                      reqNo: item.reqNo,
                      reseanNOT: "",
                      user: userModel.userID,
                      workperform: item.workPerform,
                      mainmenu: item.menuMainID.toString(),
                      remark: item.statusDetail,
                      submenU: "",
                      workstatus: int.parse(item.mastStatus),
                    );
                    setState(() {
                      models.add(sqlMpdel);
                      load = false;
                    });
                    // insert to sqlite
                  }
                }
              });

              // List<SQLiteWorklistOutageModel> listAll = [];
              // SQLiteHelperOutage().readWorkList().then((results) {
              //   listAll = results;
              //   for (int i = 0; i < listAll.length; i++) {
              //     print(
              //         '#################### ${listAll[i].reqNo}  : ${listAll[i].workstatus}');
              //   }
              // });
            }
          }
        }

        allList();
      });
    } catch (e) {
      normalDialog(context, "error", e.toString());
    }
  }

  Future<void> allList() async {
    try {
      print("##############  allList() start() ");
      //isConnected = true;
      if (isConnected) {
        final response = await http.get(
          Uri.parse('${MyConstant.newService}workmenu/list_all'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        MastOutageAllListModel listAllModel =
            MastOutageAllListModel.fromJson(jsonDecode(response.body));

        SQLiteHelperOutage().readMenu().then((result) {
          print('########### result : ${result.length}');
          if (result == null || result.length == 0) {
            for (int j = 0; j < listAllModel.result.length; j++) {
              print("#########  " +
                  listAllModel.result[j].menuMainID.toString() +
                  "  " +
                  listAllModel.result[j].menuSubID.toString() +
                  "  " +
                  listAllModel.result[j].menuChecklistID.toString());
              MastOutageMenuModel model = MastOutageMenuModel(
                dateCreated: MyConstant.strDateNow,
                isChoice: "",
                menuListID: listAllModel.result[j].menuChecklistID,
                menuListName: listAllModel.result[j].menuChecklistName,
                menuMainID: listAllModel.result[j].menuMainID,
                menuMainName: listAllModel.result[j].menuMainName,
                menuSubID: listAllModel.result[j].menuSubID,
                menuSubName: listAllModel.result[j].menuSubName,
                quantityImg: 10,
                type: listAllModel.result[j].type,
              );

              SQLiteHelperOutage().insertMenu(model);
            }
          }
        });

        setState(() {
          load = false;
        });

        // SQLiteHelperOutage()
        //     .selectChecklist(int.parse(widget.mainID), 2)
        //     .then((result) {
        //   if (result == null || result.length == 0) {}
        // });
      }
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: ShowTitle(title: "ตรวจสอบและปิดงาน", index: 3),
          ),
          drawer: ShowDrawer(userModel: userModel),
          body: load ? ShowProgress() : buildListView()),
    );
  }

  ListView buildListView() {
    double size = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) => GestureDetector(
        //child: Text('${models[index].reqNo}'),
        onTap: () {
          print("continue...." + widget.userModel.userID);
          print("main...." + models[index].mainmenu);
          print("req no #------->" + models[index].reqNo);
          print('workstatus #-------> ${models[index].workstatus}');
          print('workperform #-------> ${models[index].workperform}');
          if (models[index].workstatus != 5) {
            isConnected
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OutageWorklistClose(
                            userModel: userModel,
                            reqNo: models[index].reqNo,
                            workStatus: models[index].workstatus,
                            mainID: models[index].mainmenu,
                            workPerform: models[index].workperform,
                            isMainLine: models[index].isMainLine)),
                  )
                : offilineDialog(
                    context,
                    "offline",
                    "ต้องการทำงานแบบออฟไลน์หรือไม่",
                    models[index].reqNo,
                    widget.userModel,
                    models[index].workstatus,
                    models[index].mainmenu);
          }
        },
        child: Card(
          color: models[index].workstatus == 2
              ? Colors.green[200]
              : Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  ShowTitle(
                    title: models[index].reqNo +
                        "   : " +
                        models[index].workstatus.toString(),
                    index: 4,
                  ),
                  ShowTitle(
                    title: models[index].remark,
                    index: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
