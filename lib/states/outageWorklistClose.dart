import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/InsertWorklistOutageModel.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/mastOutageCloseWork.dart';
import 'package:wesafe/models/responeModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/otageCloseAndCheck.dart';
import 'package:wesafe/states/outageMainMenu.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/offliceAlert.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';

class OutageWorklistClose extends StatefulWidget {
  final SQLiteUserModel userModel;
  final String reqNo;
  final int workStatus;
  final String mainID;
  final String workPerform;
  final int isMainLine;

  OutageWorklistClose(
      {@required this.userModel,
      this.reqNo,
      this.workStatus,
      this.mainID,
      this.workPerform,
      this.isMainLine});
  @override
  _OutageWorklistCloseState createState() => _OutageWorklistCloseState();
}

class _OutageWorklistCloseState extends State<OutageWorklistClose> {
  SQLiteUserModel userModel;
  List<SQLiteWorklistOutageModel> listModels = [];
  List<MastOutageMenuModel> checkListModels = [];
  //List<SQLiteWorklistOutageModel> workingModels = [];
  //List<SQLiteWorklistOutageModel> closelistModels = [];
  bool isConnected = false;
  String reqNo;
  int workStatus;
  String workPerform;
  int mainLine;
  double lat, lng;
  String newReq;
  bool load = true;
  List<String> lineToken = [];
  int status = 0;
  @override
  void initState() {
    super.initState();
    newReq = widget.reqNo;
    userModel = widget.userModel;
    reqNo = widget.reqNo;
    workStatus = widget.workStatus;
    workPerform = widget.workPerform;
    checkConnection(context);
    findLatLng();
    getWork();
    getToken();
  }

  Future<void> getWork() async {
    try {
      SQLiteHelperOutage()
          .selectChecklist(int.parse(widget.mainID), 2)
          .then((result) {
        if (result != null || result.length > 0) {
          setState(() {
            checkListModels = result;
            load = false;
          });

          SQLiteHelperOutage().selectWorkList(reqNo, "2").then((results) {
            print('********** # results : ${results.length} ');
            if (results.length > 0) {
              setState(() {
                listModels = results;
              });
            } else {
              print('######### checkListModels : ${checkListModels.length} ');
              for (var item in checkListModels) {
                if (item.menuMainID == int.parse(widget.mainID) &&
                    item.menuSubID == 2) {
                  print("##########  list  : " + item.menuListID.toString());
                  SQLiteWorklistOutageModel sqlMpdel =
                      SQLiteWorklistOutageModel(
                    checklist: item.menuListID,
                    dateCreated: MyConstant.strDateNow,
                    doOrNot: 0,
                    imgList: null,
                    isComplete: 0,
                    isMainLine:
                        null == widget.isMainLine ? 0 : widget.isMainLine,
                    latitude: null,
                    longtitude: null,
                    region: userModel.rsg,
                    reqNo: widget.reqNo,
                    reseanNOT: "",
                    user: userModel.userID,
                    workperform: widget.workPerform,
                    mainmenu: item.menuMainID.toString(),
                    remark: "",
                    submenU: "2",
                    workstatus: status,
                  );

                  SQLiteHelperOutage().insertWorkList(sqlMpdel);
                  setState(() {
                    listModels.add(sqlMpdel);
                    load = false;
                  });
                }
              }
            }
          });
        }
      });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: ShowTitle(title: "ปิดงาน", index: 3),
          ),
          drawer: ShowDrawer(userModel: widget.userModel),
          body: load ? ShowProgress() : buildContent(),
          bottomNavigationBar: load ? null : buildSaveBtn()),
    );
  }

  Container buildSaveBtn() {
    return Container(
      height: 40,
      child: ElevatedButton(
        child: ShowTitle(
          title: "ยืนยัน",
          index: 3,
        ),
        onPressed: () async {
          //test
          //isConnected = true;

          isConnected
              ? listModels[listModels.length - 1].workstatus == 2
                  ? reqNo.length < 5
                      ? onlineInsert(reqNo)
                      : sendToServer(reqNo)
                  : print('..')
              : updateStatusOffline();
          // !isConnected
          //     ? updateStatusOffline()
          //     : listModels.isEmpty
          //         ? print("")
          //         : listModels[listModels.length - 1].workstatus == 2
          //             ? reqNo.length < 5
          //                 ? onlineInsert(reqNo)
          //                 : sendToServer(reqNo)
          //             : print("can't insert");
        },
        style: ElevatedButton.styleFrom(
          primary: listModels.isEmpty
              ? Colors.grey[300]
              : listModels[listModels.length - 1].workstatus == 2
                  ? MyConstant.primart
                  : Colors.grey[300],
        ),
      ),
    );
  }

  void updateStatusOffline() {
    SQLiteHelperOutage().updateWorkListStatus(6, widget.reqNo).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtageCloseAndCheck(
            userModel: widget.userModel,
          ),
        ),
      );
    });
  }

  Center buildContent() {
    return Center(
      child: Column(
        children: [
          buildReqNo(),
          buildWorkType(),
          buildWorkPerform(),
          Divider(
            color: Colors.grey,
            indent: 4.0,
            endIndent: 4.0,
          ),
          buildListView(),
        ],
      ),
    );
  }

  Widget buildReqNo() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size * 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'ใบงานเลขที่ :  $reqNo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWorkType() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size * 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                  'ประเภทงาน :  ${null == listModels ? "" : mainLine == 0 ? "การปฏิบัติงานระบบ จำหน่าย Main Line" : "การปฏิบัติงานหลัง Drop และระบบแรงต่ำ"}',
                  style:
                      TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWorkPerform() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size * 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text('งานที่ปฏิบัติงาน  :  ${widget.workPerform}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;
    // print("size of model : " + checklistmodel.result.length.toString());
    return new Expanded(
      child: Container(
        width: size * 0.9,
        child: ListView.builder(
          itemCount: checkListModels == null ? 0 : checkListModels.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              //normalDialog(context, "title", "message");
              print("check...");
              print('main : ${checkListModels[index].menuMainID}');
              print('sub : ${checkListModels[index].menuSubID}');
              print('list : ${checkListModels[index].menuListID}');
              print('status : ${listModels[index].workstatus}');
              setState(() {
                status = 2;
              });
              SQLiteHelperOutage().updateWorkList(
                  2,
                  reqNo,
                  checkListModels[index].menuSubID.toString(),
                  checkListModels[index].menuListID,
                  "",
                  0,
                  "",
                  workPerform,
                  listModels[0].isMainLine);
              setState(() {
                getWork();
                print('status : ${listModels[index].workstatus}');
              });
            },
            child: Card(
              color: listModels == null
                  ? Colors.green[300]
                  : listModels[index].workstatus == 2
                      ? Colors.green[300]
                      : Colors.grey[300],
              child: ListTile(
                leading: Container(
                  width: size * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      MyConstant.imgIconCheckList1,
                      color: Colors.white.withOpacity(0.5),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                title: Text(
                  checkListModels == null
                      ? ""
                      : checkListModels[index].menuListName,
                  style: TextStyle(
                    fontSize: size * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  } //build

  Future<Null> prepareWorking(
      List<MastOutageMenuModel> _checkListModels) async {
    // insert for transaction working
    //print("### getCheckList  = ${checkListModels.length}");
    for (int i = 0; i < _checkListModels.length; i++) {
      SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel(
        reqNo: reqNo,
        checklist: _checkListModels[i].menuListID,
        mainmenu: _checkListModels[i].menuMainID.toString(),
        dateCreated: MyConstant.strDateNow,
        submenU: _checkListModels[i].menuSubID.toString(),
        user: userModel.userID,
        isComplete: 0,
        workperform: "",
        isMainLine: 0,
        imgList: "",
        region: userModel.rsg,
        remark: "",
        workstatus: 0,
      );
      SQLiteHelperOutage().insertWorkList(model);
    }

    setState(() {
      load = false;
    });
  }

  //else {
  //for check status
  Future<Null> findLatLng() async {
    Position position = await Geolocator.getLastKnownPosition();

    setState(() {
      lat = position == null ? 0 : position.latitude;
      lng = position == null ? 0 : position.longitude;
    });
  }

  Future<Null> sendToServer(String reqNo) async {
    try {
      List<SQLiteWorklistOutageModel> listModels = [];
      String _strJson;
      List<String> listValues = [];
      OutageCloseWork closeListModel;
      if (isConnected) {
        SQLiteHelperOutage().selectWorkList(reqNo, "2").then((result) async {
          if (result == null) {
            print("Error : " + result.toString());
          } else {
            setState(() {
              load = false;
            });
            listModels = result;
            print("close : length : " + listModels.length.toString());
            for (int i = 0; i < listModels.length; i++) {
              closeListModel = OutageCloseWork(
                deptName: userModel.deptName == null ? "" : userModel.deptName,
                dateTimeWorkFinish: "",
                empLeaderID:
                    userModel.leaderId == null ? "" : userModel.leaderId,
                employeeID: userModel.userID == null ? "" : userModel.userID,
                image: [""],
                isOffElect: "",
                offElectReason: "",
                isSortGND: "",
                gNDReason: "",
                locationLat: lat.toString(),
                locationLng: lng.toString(),
                menuChecklistID: listModels[i].checklist == null
                    ? ""
                    : listModels[i].checklist.toString(),
                menuMainID: listModels[i].mainmenu == null
                    ? ""
                    : listModels[i].mainmenu == null
                        ? ""
                        : listModels[i].mainmenu.toString(),
                menuSubID: "2",
                ownerID: userModel.ownerID,
                parcel: "",
                regionCode: userModel.rsg == null ? "" : userModel.rsg,
                remark: "",
                sender: userModel.userID == null ? "" : userModel.userID,
                waitApprove: "",
                workPerform: null == listModels[i].workperform
                    ? ""
                    : listModels[i].workperform,
                workStatus: "5",
                reqNo: newReq,
              );

              _strJson = json.encode(closeListModel);
              listValues.add(_strJson);
            } //for

            final response = await http.post(
              Uri.parse(
                  '${MyConstant.webService}WeSafe_Insert_TransactionWork_CloseO'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: utf8.encode(listValues.toString()),
            );

            print("sent to server respond  : " + response.body);
            ResponeModel responeModel =
                ResponeModel.fromJson(jsonDecode(response.body));

            print(
                "Close success  reply = ${responeModel.result.reply.toString()}");

            //if (responeModel.result.reply.toString().contains("Insert")) {
            SQLiteHelperOutage().updateWorkListStatus(5, reqNo);

            SQLiteHelperOutage().deleteWorklistByReqNo(reqNo);

            setLine(reqNo);
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
            // }
          }
        });
      } else {
        offilineAlert(
            context, "OffLine", "ขณะนี้ทำงานแบบ offline", userModel, reqNo, 5);
      }
    } catch (E) {
      await http.post(
        Uri.parse('${MyConstant.newService}log/create_error'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            '[{"Req_no": "$reqNo",   "Error": "${E.toString()}" , "CodeFrom":"mobile " , "DateTimeError":"${MyConstant.strDateNow}" }]',
      );

      //+++++++++++ alert Line++++++++++++++++++++++++++++++++
      final client = HttpClient();
      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
      String msg =
          'close work  ###  ReqNO = $reqNo   send to server error  : ${E.toString()}';
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.write(
          '{"strMsg": "$msg",   "strToken": "gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz"}');
      await request.close();
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      print("insert error : " + E.toString());
      normalDialog(context, "Error", E.toString());
    }
  }

  Future<Null> onlineInsert(String reqNo) async {
    try {
      if (isConnected) {
        InsertWorklistOutageModel insertWorklistModel;
        List<SQLiteWorklistOutageModel> listModels = [];
        String _strJson;
        List<String> listValues = [];
        SQLiteHelperOutage().selectWorkList(reqNo, "1").then((result) async {
          if (result == null) {
            print("Error : " + result.toString());
          } else {
            setState(() {
              load = false;
            });
            listModels = result;

            for (int i = 0; i < listModels.length; i++) {
              insertWorklistModel = InsertWorklistOutageModel(
                  deptName:
                      userModel.deptName == null ? "" : userModel.deptName,
                  dateTimeWorkFinish: "",
                  docRequire: "",
                  empLeaderID:
                      userModel.leaderId == null ? "" : userModel.leaderId,
                  employeeID: userModel.userID == null ? "" : userModel.userID,
                  iPAddress: "",
                  image: listModels[i].imgList == null
                      ? [""]
                      : generateImage(listModels[i].imgList),
                  // image: [""],
                  isOffElect: "",
                  offElectReason: "",
                  isSortGND: "",
                  gNDReason: "",
                  locationLat: lat.toString(),
                  locationLng: lng.toString(),
                  macAddress: "",
                  menuChecklistID: listModels[i].checklist == null
                      ? ""
                      : listModels[i].checklist.toString(),
                  menuMainID: listModels[i].mainmenu == null
                      ? ""
                      : listModels[i].mainmenu == null
                          ? ""
                          : listModels[i].mainmenu.toString(),
                  menuSubID: "1",
                  ownerID: "O",
                  parcel: "",
                  province: "",
                  regionCode: userModel.rsg == null ? "" : userModel.rsg,
                  remark: "",
                  sender: userModel.userID == null ? "" : userModel.userID,
                  station: "",
                  tokenNoti: "",
                  waitApprove: "",
                  workArea: "",
                  workPerform: listModels[i].workperform,
                  workStatus: "0",
                  workType: "",
                  reqNo: "",
                  doOrNot: listModels[i].doOrNot.toString(),
                  isMainLine: listModels[i].isMainLine.toString(),
                  reasonNot: listModels[i].reseanNOT.toString());

              _strJson = json.encode(insertWorklistModel);
              listValues.add(_strJson);
            } //for

            final response = await http.post(
              Uri.parse('${MyConstant.webService}WeSafe_InsertTransactionO'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: utf8.encode(listValues.toString()),
            );

            print("respond  : " + response.body);
            ResponeModel responeModel =
                ResponeModel.fromJson(jsonDecode(response.body));

            SQLiteHelperOutage().updateWorkListReq(
                reqNo, responeModel.result.reply.toString(), 1);

            setState(() {
              //if (responeModel.isSuccess) {
              newReq = responeModel.result.reply.toString();

              sendToServer(newReq);
              //}
            });
          }
        });
      } else {
        offilineAlert(
            context, "OffLine", "ขณะนี้ทำงานแบบ offline", userModel, reqNo, 4);
      }
    } catch (e) {
      await http.post(
        Uri.parse('${MyConstant.newService}log/create_error'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            '[{"Req_no": "$reqNo",   "Error": "${e.toString()}" , "CodeFrom":"mobile " , "DateTimeError":"${MyConstant.strDateNow}" }]',
      );

      //+++++++++++ alert Line++++++++++++++++++++++++++++++++
      final client = HttpClient();
      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
      String msg =
          'close work  ###  ReqNO = $reqNo   send to server error  : ${e.toString()}';
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.write(
          '{"strMsg": "$msg",   "strToken": "gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz"}');
      await request.close();
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    }
  }

  List generateImage(String strImg) {
    List arr = new List();
    arr = strImg.split(',');
    return arr;
  }

  Future<Null> setLine(String reqNo) async {
    findLatLng();

    //test
    // List<String> lineToken = [];
    // lineToken.add("gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz");
    if (userModel.userID.contains('506429')) {
      lineToken = [];
      lineToken.add("gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz");
    }
    final client = HttpClient();

    for (int i = 0; i < lineToken.length; i++) {
      print("####--->  line Token  :  $lineToken");
      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
      String msg = "📣 ปิดงาน : $reqNo"
              "\n" +
          listModels[0].mainmenu +
          " : หลังปฏิบัติงาน"
              "\n" +
          "\n" +
          listModels[0].workperform +
          "\n" +
          userModel.firstName +
          " " +
          userModel.lastName +
          "\n" +
          userModel.deptName +
          "\n" +
          MyConstant.strDateNow +
          "\n" +
          "https://wesafe.pea.co.th/admin/detail.aspx?WebGetReqNO=$reqNo";

      print("#######  Token   ${lineToken[i]} ");

      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");

      request.write('{"strMsg": "$msg",   "strToken": "${lineToken[i]}"}');

      final response = await request.close();
      response.transform(utf8.decoder).listen((contents) {
        print("###### notification reply : $contents");
      });
    } //for
    setState(() {
      load = true;
    });
  }

  Future<Null> getToken() async {
    print("#--------> get line token");
    final bool isConnect = await InternetConnectionChecker().hasConnection;
    MastMainMenuModel _mainMenuModel;
    try {
      if (isConnect) {
        final client = HttpClient();

        final request = await client
            .postUrl(Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu"));
        request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
        request.write('{"Owner_ID": "O",   "REGION_CODE": "${userModel.rsg}"}');
        final response = await request.close();

        response.transform(utf8.decoder).listen(
          (contents) {
            if (contents.contains('Error')) {
              contents = contents.replaceAll("[", "").replaceAll("]", "");
              normalDialog(context, 'Error', contents);
            } else {
              _mainMenuModel =
                  MastMainMenuModel.fromJson(json.decode(contents));

              for (int i = 0; i < 1; i++) {
                setState(() {
                  lineToken = _mainMenuModel.result[i].lineToken;
                  load = false;
                });
              }
            } //else
          },
        );
      }
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }
}
