//import 'dart:_http';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/InsertWorklistOutageModel.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/responeModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/hotlineMainMenu.dart';
import 'package:wesafe/states/hotlineWorkRec.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/offliceAlert.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';

class HotlineWorklist extends StatefulWidget {
  final String MenuName;
  final int MenuID;
  final int MenuSubID;
  final String MenuSubName;
  final SQLiteUserModel userModel;
  final String workID;
  final String rsg;
  HotlineWorklist(
      {@required this.MenuName,
      this.MenuID,
      this.MenuSubID,
      this.MenuSubName,
      this.userModel,
      this.workID,
      this.rsg});

  @override
  State<HotlineWorklist> createState() => _HotlineWorklistState();
}

class _HotlineWorklistState extends State<HotlineWorklist> {
  TextEditingController remarkController = TextEditingController();
  List<MastOutageMenuModel> listMenu = [];
  List<SQLiteWorklistOutageModel> listWork = [];
  List<String> lineToken;
  SQLiteUserModel _userModel;
  bool load = true;
  bool isConnected = false;
  double lat, lng = 0.0;
  int workID = 0;
  int status = 0;

  @override
  // ignore: must_call_super
  void initState() {
    workListInfo();
    _userModel = widget.userModel;
    workID = int.parse(widget.workID);

    findLatLng();
    getToken();

    // const oneSec = const Duration(seconds: 3);

    // Timer.periodic(oneSec, (Timer timer) {
    //   print(
    //       "Repeat task every one second"); // This statement will be printed after every one second
    // });
  }

  void workListInfo() {
    try {
      SQLiteHotline()
          .selectChecklist(widget.MenuID, widget.MenuSubID)
          .then((result) async {
        print('######## result  lenght : ${result.length}');
        if (result == null) {
          normalDialog(context, "Error", "ไม่มีข้อมูล");
        } else {
          // setState(() async {
          listMenu = result;

          if (workID == 0) {
            // int lastID = 1;
            await SQLiteHelperOutage().selectLastID().then((result) {
              if (result == null) {
              } else {
                setState(() {
                  load = false;
                  workID = result;

                  print('workID   :  $workID');
                  print('listMenu lenght   :  ${listMenu.length}');

                  for (int i = 0; i < listMenu.length; i++) {
                    SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel(
                      reqNo: workID.toString(),
                      checklist: listMenu[i].menuListID,
                      mainmenu: listMenu[i].menuMainID.toString(),
                      dateCreated: MyConstant.strDateNow,
                      submenU: listMenu[i].menuSubID.toString(),
                      user: _userModel.userID,
                      isComplete: 0,
                      workperform: "",
                      isMainLine: 0,
                      imgList: "",
                      region: _userModel.rsg,
                      remark: "",
                      workstatus: status,
                    );
                    SQLiteHelperOutage().insertWorkList(model);
                    setState(() {
                      listWork.add(model);
                      listMenu = listMenu;
                    });
                  } //for
                });
              }
            });

            // insert for transaction working
            //print("### getCheckList  = ${checkListModels.length}");

          } else {
            newRender();
            setState(() {
              listMenu = listMenu;
              load = false;
            });
          }
          // }

          //load = false;
          // });
        }
      });
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ShowTitle(title: "บันทึกงาน", index: 3),
        ),
        drawer: ShowDrawer(userModel: widget.userModel),
        body: load
            ? ShowProgress()
            : Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.MenuName,
                          style: TextStyle(
                            fontSize: size * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.MenuSubName,
                          style: TextStyle(
                            fontSize: size * 0.043,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      buildListView(),
                      expandPanel("เพิ่มเติม (ถ้ามี)"),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          height: 40,
          child: load
              ? ShowProgress()
              : ElevatedButton(
                  child: ShowTitle(
                    title: "ยืนยัน",
                    index: 3,
                  ),
                  onPressed: () {
                    //
                    print("sent to server..." + widget.workID);
                    sendToServer(widget.workID);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: listWork.length > 0
                        ? listWork[listWork.length - 1].workstatus == 1
                            ? MyConstant.primart
                            : Colors.grey[400]
                        : Colors.grey[400],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;

    return new Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 25.0),
        width: size * 0.9,
        child: ListView.builder(
          itemCount: listMenu.length - 1,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              //normalDialog(context, "title", "message");
              print("###--------------------> workID " + workID.toString());
              print("###--------------------> ListWork status " +
                  listWork[index].workstatus.toString());
              print("###--------------------> menuListID " +
                  listMenu[index].menuListID.toString());
              if (listWork[index].workstatus == 1 ||
                  listMenu[index].menuListID == 1) {
                if (listMenu[index].type.contains("1")) {
                  //print("update.....");
                  SQLiteHelperOutage().updateWorkList(
                    2,
                    workID.toString(),
                    widget.MenuSubID.toString(),
                    listMenu[index].menuListID,
                    "",
                    0,
                    "",
                    "",
                    0,
                  );

                  // next step
                  SQLiteHelperOutage()
                      .updateWorkList(
                    1,
                    workID.toString(),
                    widget.MenuSubID.toString(),
                    listMenu[index].menuListID + 1,
                    "",
                    0,
                    "",
                    "",
                    0,
                  )
                      .then((value) {
                    setState(() {
                      newRender();
                    });
                  });
                } else if (listMenu[index].type.contains("2")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (HotlineWorkRec(
                        workType: listMenu[index].type,
                        isMainLine: "",
                        listStatus: 1,
                        mainID: listMenu[index].menuMainID.toString(),
                        subID: widget.MenuSubID.toString(),
                        mainName: listMenu[index].menuMainName,
                        subName: widget.MenuSubName,
                        userModel: widget.userModel,
                        workID: workID.toString(),
                        workList: listMenu[index].menuListID,
                        workName: listMenu[index].menuListName,
                        rsg: widget.rsg,
                      )),
                    ),
                  );
                }
              }
              // else {
              //   //normalDialog(context, ".", "ทำก่นอหน้าก่อนจ้า");
              // }
            },
            child: Card(
              color: listWork[index].workstatus == 2
                  ? Colors.green[200]
                  : Colors.grey[300],
              child: ListTile(
                leading: Container(
                  width: size * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: listMenu[index].type == "1"
                        ? Image.asset(MyConstant.imgIconCheckList1)
                        : listMenu[index].type == "2"
                            ? Image.asset(MyConstant.imgIconCheckList2)
                            : Image.asset(MyConstant.imgIconCheckList1),
                  ),
                ),
                title: Text(
                  listMenu[index].menuListName,
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
  }

  void newRender() {
    //List<SQLiteWorklistOutageModel> newList = [];
    print("####  check value newRender()");
    SQLiteHelperOutage()
        .selectWorkList(workID.toString(), widget.MenuSubID.toString())
        .then((value) {
      if (value != null && value.length > 0) {
        setState(() {
          // for (var item in value) {
          //   print(
          //       '##--------> ${item.reqNo} , ${item.submenU},  ${item.checklist}  status :  ${item.workstatus}');
          //   print('img :  ${item.imgList.length}');
          // }
          listWork = value;
        });
      }
    });
  }

  Widget expandPanel(String word) {
    double size = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.grey[300], width: 1)),
      child: Container(
        width: size * 0.875,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              ExpansionTile(
                title: Row(
                  children: [
                    Text(
                      word,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                children: <Widget>[
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: remarkController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'กรุณาระบุเหตุผล';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue[800], width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue[800], width: 2.0),
                          ),
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.blue[700],
                          ),
                          labelText: 'เหตุผล',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /********************************* close work *********************************** */

  Future<Null> sendToServer(String reqNo) async {
    try {
      print("work : " + widget.workID);
      reqNo = widget.workID.toString();

      List<SQLiteWorklistOutageModel> listModels = [];
      String _strJson;
      List<String> listValues = [];
      InsertWorklistOutageModel insertWorklistModel;
      final bool isConn = await InternetConnectionChecker().hasConnection;

      //test
      //isConnected = true;
      //isConnected = false;
      if (isConnected) {
        SQLiteHotline().selectWorkList(reqNo).then((result) async {
          //print("#-----> result lenght : " + result.length.toString());
          if (result == null) {
            print("Error : " + result.toString());
          } else {
            listModels = result;
            for (int i = 0; i < listModels.length - 1; i++) {
              print("#### listModels[i].imgList : " +
                  listModels[i].imgList.length.toString());

              insertWorklistModel = InsertWorklistOutageModel(
                  deptName: widget.userModel.deptName == null
                      ? ""
                      : widget.userModel.deptName,
                  dateTimeWorkFinish: "",
                  docRequire: "",
                  empLeaderID: widget.userModel.leaderId == null
                      ? ""
                      : widget.userModel.leaderId,
                  employeeID: widget.userModel.userID == null
                      ? ""
                      : widget.userModel.userID,
                  iPAddress: "",
                  image: listWork[i].imgList == null &&
                          listWork[i].imgList.length < 0
                      ? [""]
                      : generateImage(listWork[i].imgList),
                  // image: [""],
                  isOffElect: "",
                  offElectReason: "",
                  isSortGND: "",
                  gNDReason: "",
                  locationLat: lat == null ? "" : lat.toString(),
                  locationLng: lng == null ? "" : lng.toString(),
                  macAddress: "",
                  menuChecklistID: listModels[i].checklist == null
                      ? ""
                      : listModels[i].checklist.toString(),
                  menuMainID: listModels[i].mainmenu == null
                      ? ""
                      : listModels[i].mainmenu,
                  menuSubID: widget.MenuSubID.toString(),
                  ownerID: "H",
                  parcel: "",
                  province: widget.rsg,
                  regionCode:
                      widget.userModel.rsg == null ? "" : widget.userModel.rsg,
                  remark: remarkController.text,
                  sender: widget.userModel.userID == null
                      ? ""
                      : widget.userModel.userID,
                  station: "",
                  tokenNoti: "",
                  waitApprove: "",
                  workArea: "",
                  workPerform: "",
                  workStatus: "0",
                  workType: "",
                  reqNo: "",
                  doOrNot: "0",
                  isMainLine: "",
                  reasonNot: "");

              _strJson = json.encode(insertWorklistModel);
              listValues.add(_strJson);
            } //for

            print("work list listValues lenght : " +
                listValues.length.toString());

            final response = await http.post(
              Uri.parse('${MyConstant.webService}WeSafe_InsertTransactionO'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: utf8.encode(listValues.toString()),
            );

            print("####---> respond  : " + response.body);
            ResponeModel responeModel =
                ResponeModel.fromJson(jsonDecode(response.body));

            print(
                "####---> Insert success  req_no = ${responeModel.result.reply.toString()}");

            SQLiteHelperOutage().updateWorkListReq(
                reqNo, responeModel.result.reply.toString(), 0);

            setLine(responeModel.result.reply.toString());

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (HotlineMainMenu(
                          userModel: widget.userModel,
                        ))));
          }
        });
      } else {
        offilineAlert(context, "OffLine", "ขณะนี้ทำงานแบบ offline",
            widget.userModel, reqNo, 4);
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
          'worklist  ## ReqNO = $reqNo   send to server error  : ${E.toString()}';
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

  Future<Null> setLine(String reqNo) async {
    findLatLng();
    try {
      //test
      // List<String> lineToken = [];
      // lineToken.add("gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz");
      if (widget.userModel.userID.contains('506429')) {
        lineToken = [];
        lineToken.add("gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz");
      }

      final client = HttpClient();
      for (int i = 0; i < lineToken.length; i++) {
        print('####--->  line Token  :  ${lineToken[i]}');
        final request = await client
            .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
        String msg = "📣 ใบงาน : $reqNo" +
            "\n" +
            widget.MenuName +
            " : " +
            widget.MenuSubName +
            "\n" +
            "\n" +
            widget.userModel.firstName +
            " " +
            widget.userModel.lastName +
            "\n" +
            widget.userModel.deptName +
            "\n" +
            MyConstant.strDateNow +
            "\n" +
            "https://wesafe.pea.co.th/admin/detail.aspx?WebGetReqNO=$reqNo";

        request.headers.contentType =
            new ContentType("application", "json", charset: "utf-8");

        request.write('{"strMsg": "$msg",   "strToken": "${lineToken[i]}"}');
        final response = await request.close();

        //output return
        response.transform(utf8.decoder).listen((contents) {
          print("###### notification reply : $contents");
        });
      }
    } catch (e) {
      normalDialog(context, 'Error', e.toString());
    }
  }

  Future<Null> findLatLng() async {
    Position position = await Geolocator.getLastKnownPosition();

    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    print('#--------> $lat   :    $lng');
  }

  List generateImage(String strImg) {
    List arr = new List();
    arr = strImg.split(',');
    //print('### generateImage --- > ${arr[0].toString()}');
    return arr;
  }

  Future<Null> getToken() async {
    //print("#--------> get line token");
    final bool isConnect = await InternetConnectionChecker().hasConnection;
    MastMainMenuModel _mainMenuModel;
    try {
      if (isConnect) {
        // print("#--------> get line token   : " +
        //     isConnect.toString() +
        //     "    rsg : " +
        //     widget.userModel.rsg);

        final client = HttpClient();

        final request = await client
            .postUrl(Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu"));
        request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
        request.write(
            '{"Owner_ID": "H",   "REGION_CODE": "${widget.userModel.rsg}"}');
        final response = await request.close();

        response.transform(utf8.decoder).listen(
          (contents) {
            if (contents.contains('Error')) {
              contents = contents.replaceAll("[", "").replaceAll("]", "");
              normalDialog(context, 'Error', contents);
            } else {
              // print("### return  : " + contents);
              _mainMenuModel =
                  MastMainMenuModel.fromJson(json.decode(contents));

              for (int i = 0; i < 1; i++) {
                setState(() {
                  load = false;
                  lineToken = _mainMenuModel.result[i].lineToken;
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
