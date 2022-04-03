import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastCheckWorkListModel.dart';
import 'package:wesafe/models/mastOutageAllList.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/hotlineWorkCloseList.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/offlineDialog.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';

class HotlineCheckList extends StatefulWidget {
  final SQLiteUserModel userModel;
  HotlineCheckList({@required this.userModel});

  @override
  State<HotlineCheckList> createState() => _HotlineCheckListState();
}

class _HotlineCheckListState extends State<HotlineCheckList> {
  List<SQLiteWorklistOutageModel> models = [];
  MastCheckWorkListModel modelCheck;

  bool isConnected = true;
  bool load = true;

  @override
  // ignore: must_call_super
  void initState() {
    checkConnection(context);
    readAllWork();
  }

  Future<void> readAllWork() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;

    try {
      //isConnected = true;

      bool isSqlite = false;
      SQLiteHotline().selectWorkListForCheck().then((result) async {
        if (result == null) {
          print("result error");
        } else {
          setState(() {
            models = result;

            isSqlite = models.length > 0 ? true : false;
            load = false;
          });

          //  if (isConnected) {
          if (true) {
            final response = await http.post(
              Uri.parse('${MyConstant.newService}request/check'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: '{"Region_Code":  "${widget.userModel.rsg}"  }',
            );

            if (!isSqlite) {
              setState(() {
                load = false;
                modelCheck =
                    MastCheckWorkListModel.fromJson(jsonDecode(response.body));
                for (var item in modelCheck.result) {
                  print(
                      "check close : ${widget.userModel.userID} :  ${item.employee_ID}  ");
                  if (widget.userModel.userID.contains(item.employee_ID)) {
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
                      region: widget.userModel.rsg,
                      reqNo: item.reqNo,
                      reseanNOT: "",
                      user: widget.userModel.userID,
                      workperform: item.workPerform,
                      mainmenu: item.menuMainID.toString(),
                      remark: item.statusDetail,
                      submenU: item.menuSubID.toString(),
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
            }
          }
        }

        allList();
      });
    } catch (e) {
      normalDialog(context, "error", e.toString());
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
        drawer: ShowDrawer(userModel: widget.userModel),
        body: load ? ShowProgress() : buildListView(),
      ),
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: models.length,
      itemBuilder: (context, index) => GestureDetector(
        //child: Text('${models[index].reqNo}'),
        onTap: () {
          print("#### --- >" +
              widget.userModel.userID +
              " , " +
              models[index].mainmenu +
              " , " +
              models[index].reqNo +
              ' , ${models[index].workstatus}');

          //test
          isConnected = true;
          if (models[index].workstatus != 5) {
            isConnected
                ? models[index].workstatus != 4
                    ? print('can not to do')
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotlineWorkCloseList(
                              userModel: widget.userModel,
                              reqNo: models[index].reqNo,
                              workStatus: models[index].workstatus,
                              mainID: models[index].mainmenu,
                              subID: models[index].submenU),
                        ),
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
          color: models[index].workstatus == 4
              ? Colors.green[200]
              : Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  ShowTitle(
                    title: models[index].reqNo,
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

  Future<void> allList() async {
    try {
      print("##############  allList() start() ");
      final bool isConnected = await InternetConnectionChecker().hasConnection;
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

  void checkConnection(BuildContext context) async {
    final bool isConn = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = isConn;
    });
  }
}
