import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      //test
      bool isSqlite = false;
      SQLiteHotline().selectWorkListForCheck().then((result) async {
        if (result == null) {
          print("result error");
        } else {
          setState(() {
            models = result;

            // for (var item in models) {
            //   print('## >>>> ${item.submenU}   : ${item.workstatus}');
            // }
            isSqlite = models.length > 0 ? true : false;
            load = false;
          });
          //test
          //  if (isConnected) {
          if (isConnected) {
            final response = await http.post(
              Uri.parse('${MyConstant.newService}request/check'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: '{"Region_Code":  "${widget.userModel.rsg}"  }',
            );
            modelCheck =
                MastCheckWorkListModel.fromJson(jsonDecode(response.body));
            if (!isSqlite) {
              setState(() {
                load = false;

                for (var item in modelCheck.result) {
                  // print(
                  //     "check close : ${widget.userModel.userID} :  ${item.employee_ID}  ");
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
            } else {
              //update status from api

              for (var item in modelCheck.result) {
                // print(
                //     "check close : ${widget.userModel.userID} :  ${item.employee_ID}  ");
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
                  SQLiteHotline()
                      .updateWorkListStatus(
                          item.mastStatus == ""
                              ? 2
                              : int.parse(item.mastStatus),
                          item.reqNo)
                      .then((value) => value == null ? null : newRander());
                  setState(() {
                    models.add(sqlMpdel);
                    //   for (var items in result) {
                    //     if(items.reqNo!=item.reqNo){
                    //         models.add(sqlMpdel);
                    //     }
                    //   }

                    load = false;
                  });
                  // insert to sqlite
                }
              }
            }
          }
        }

        allList();
      });
    } catch (e) {
      normalDialog(context, "error", e.toString());
    }
  }

  // ignore: missing_return
  Future<Null> newRander() {
    // print('######### ---- newRander()');
    // SQLiteHotline().selectWorkListForCheck().then((result) async {
    //   if (result == null) {
    //     print("result error");
    //   } else {
    //     setState(() {
    //       models = result;
    //       load = false;
    //     });
    //   }
    // });
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
              models[index].submenU +
              " , " +
              models[index].reqNo +
              ' , ${models[index].workstatus} , ${models[index].remark} ');

          //test
          //isConnected = true;
          //isConnected = false;

          if (models[index].workstatus != 5) {
            isConnected
                ? models[index].workstatus == 2
                    ? Navigator.push(
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
                    : models[index].workstatus == 4
                        ? Navigator.push(
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
                        : print('to do something..')
                : models[index].workstatus == 6
                    ? print(' wait for update to server...')
                    : offilineDialog(
                        context,
                        "offline",
                        "ต้องการทำงานแบบออฟไลน์หรือไม่",
                        models[index].reqNo,
                        widget.userModel,
                        models[index].workstatus,
                        models[index].mainmenu,
                        models[index].submenU);
          }
        },

        child: Column(
          children: [
            Slidable(
              child: Card(
                color: models[index].workstatus == 4
                    ? Colors.green[200]
                    : Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      width: size * 0.13,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: models[index].workstatus == 6
                            ? Icon(
                                Icons.access_alarm_outlined,
                                size: size * 0.09,
                              )
                            : Icon(
                                Icons.check,
                                size: size * 0.09,
                              ),
                      ),
                    ),
                    title: Column(
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
              key: ValueKey(models[index].reqNo),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  print('###----> pass slide');
                  SQLiteHotline().deleteWorklistByReqNo(models[index].reqNo);
                }),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      print('delet ReqNo : ${models[index].reqNo}');
                      SQLiteHotline()
                          .deleteWorklistByReqNo(models[index].reqNo);
                    },
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
            ),
          ],
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
