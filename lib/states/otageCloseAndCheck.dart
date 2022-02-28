import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/outageWorklistClose.dart';
import 'package:wesafe/utility/offlineDialog.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';

class OtageCloseAndCheck extends StatefulWidget {
  final SQLiteUserModel userModel;
  OtageCloseAndCheck({@required this.userModel});

  @override
  _OtageCloseAndCheckState createState() => _OtageCloseAndCheckState();
}

class _OtageCloseAndCheckState extends State<OtageCloseAndCheck> {
  SQLiteUserModel userModel;
  List<SQLiteWorklistOutageModel> models = [];
  bool isConnected = false;

  @override
  void initState() {
    userModel = widget.userModel;
    readAllWork();
    checkConnection(context);
  }

  void checkConnection(BuildContext context) async {
    final bool isConn = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = isConn;
    });
  }

  void readAllWork() {
    SQLiteHelperOutage().selectWorkListForCheck().then((result) {
      if (result == null) {
        print("result error");
      } else {
        setState(() {
          models = result;
          print('##### check WORKSTATUS : ${models.length}');
        });
        for (var item in models) {
          print('------------------ ' + item.reqNo + '-----------------------');
          // print('##### check ID :  ${item.id}');
          print('##### check main menu : ' + item.mainmenu);
          print('##### check WORKSTATUS : ${item.workstatus}');
          print('##### check Remark : ${item.remark}');
          print('##### check workperform : ${item.workperform}');
          // print('##### check list menu : ${item.checklist}');
          // print('##### check workPerform : ${item.workperform}');
          // print('##### check workStatus : ${item.workstatus}');
          // print('##### check doOrNot : ${item.doOrNot}');
          // print('##### check imgList : ${item.imgList.length}');
          // print('##### check doOrNot : ${item.reseanNOT}');
        }
      }
    });

    //test get Lastedt ID

    SQLiteHelperOutage().selectLastID().then((result) {
      if (result == null) {
        print("result error");
      } else {
        print('##### check  Lastedt ID : $result');
      }
    });
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
          body: buildListView()),
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
                            )),
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
}
