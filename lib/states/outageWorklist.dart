// import 'dart:_http';
import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/InsertWorklistOutageModel.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/mastcheckListModel.dart';
import 'package:wesafe/models/responeModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/outageMainMenu.dart';
import 'package:wesafe/states/outageWorkRec.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/offliceAlert.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgree.dart';
import 'package:wesafe/widgets/showTitle.dart';

class OutageWorkList extends StatefulWidget {
  final SQLiteUserModel userModel;
  final String mainID;
  final String mainName;
  final int workId;
  final String workPerform;
  final String isMainLine;
  OutageWorkList(
      {@required this.userModel,
      this.mainID,
      this.mainName,
      this.workId,
      this.workPerform,
      this.isMainLine});

  @override
  _OutageWorkListState createState() => _OutageWorkListState();
}

class _OutageWorkListState extends State<OutageWorkList> {
  SQLiteUserModel userModel;
  TextEditingController workController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  MastCheckListModel checklistmodel;
  String choose;
  int workID;
  bool isConnected = false;
  List<MastOutageMenuModel> checkListModels;
  List<SQLiteWorklistOutageModel> workingModels = [];
  List<String> lineToken;
  double lat, lng;
  bool load = true;
  String workMain;
  @override
  void initState() {
    super.initState();
    choose = widget.isMainLine.isEmpty ? "1" : widget.isMainLine;
    workController.text = widget.workPerform.isEmpty ? "" : widget.workPerform;
    workID = widget.workId;
    userModel = widget.userModel;
    workMain = widget.mainID;

    checkConnection(context);
    readWorkList();
    prepareWorking();
    findLatLng();
    getToken();
  }

  Future<Null> readWorkList() async {
    try {
      if (isConnected) {
        final response = await http.post(
          Uri.parse('${MyConstant.webService}WeSafeSelectWorkList'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: '{"mainMenu": "${widget.mainID}",   "subMenu": "1"}',
        );
        setState(() {
          load = false;
          checklistmodel =
              MastCheckListModel.fromJson(jsonDecode(response.body));
        });
      } else {

        SQLiteHelperOutage()
            .selectChecklist(int.parse(widget.mainID), 1)
            .then((result) {
          if (result == null) {
            print("Error : " + result.toString());
          } else {
            setState(() {
              load = false;
              checkListModels = result;
            });
          }
        });
      } //else

      
    } catch (e) {
      print("Error : " + e.toString());
      SQLiteHelperOutage()
          .selectChecklist(int.parse(widget.mainID), 1)
          .then((result) {
        if (result == null) {
          print("Error : " + result.toString());
        } else {
          setState(() {
            load = false;
            checkListModels = result;
          });
        }
      });
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
            title: ShowTitle(title: widget.mainName, index: 3),
          ),
          drawer: ShowDrawer(userModel: userModel),
          body: load
              ? ShowProgress()
              : Center(
                  child: Column(
                    children: [
                      workMain == "999" ? Text("") : buildRadioMainLine(),
                      workMain == "999" ? Text("") : buildWorkPerform(),
                      Divider(
                        color: Colors.grey,
                        indent: 4.0,
                        endIndent: 4.0,
                      ),
                      load ? ShowProgress() : buildListView(),
                      expandPanel("เพิ่มเติม (ถ้ามี)")
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            height: 40,
            child: ElevatedButton(
              child: ShowTitle(
                title: "ยืนยัน",
                index: 3,
              ),

              onPressed: () {
                setState(() {
                  load = true;
                }); // set loading to true here
                null != workingModels &&
                        workingModels[workingModels.length - 1].workstatus == 2
                    ? sendToServer(workingModels[0].reqNo).then((value) async {
                        setState(() {
                          load = false;
                        }); // set it to false after your operation is done
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
                      })
                    : findLatLng();
              },
              // onPressed: () async  {
              //   ShowProgress();
              //   null != workingModels &&
              //           workingModels[workingModels.length - 1].workstatus == 2
              //       ? sendToServer(
              //           workingModels[0].reqNo) //print("insert and send line")
              //       : findLatLng(); //print("cn not insert");
              // },
              style: ElevatedButton.styleFrom(
                primary: workingModels.length > 0
                    ? workingModels[workingModels.length - 1].workstatus == 2
                        ? MyConstant.primart
                        : Colors.grey[400]
                    : Colors.grey[400],
              ),
            ),
          )),
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;

    return new Expanded(
      child: Container(
        width: size * 0.9,
        child: ListView.builder(
          itemCount: checkListModels.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              //normalDialog(context, "title", "message");
              if (index == 0) {
                prepareWorking();
              }

              if (checkListModels[index].type.contains("1")) {
                print("insert db and update work status   - ID : "+workID.toString());

                SQLiteHelperOutage().updateWorkList(
                    2,
                    workID.toString(),
                    "1",
                    checkListModels[index].menuListID,
                    "",
                    int.parse(choose),
                    workController.text,
                    widget.workPerform,
                    int.parse(widget.isMainLine));
                setState(() {
                  prepareWorking();
                });
              } else {
                print('work perform ------->' + workController.text);
                print('work type ------->' + checkListModels[index].type);
                print('workID   ------->' + workID.toString());
                if (workController.text.trim() != "" || workMain == "999") {
                  Navigator.push(
                    context,
                    workingModels[index].workstatus > 0 || index == 0
                        ? MaterialPageRoute(
                            builder: (context) => OutageWorkRecord(
                              userModel: userModel,
                              workType: checkListModels[index].type,
                              workName: checkListModels[index].menuListName,
                              mainID: widget.mainID,
                              mainName: widget.mainName,
                              workID: workID,
                              workList: checkListModels[index].menuListID,
                              listStatus: workingModels[index].workstatus,
                              isMainLine: choose,
                              workPerform: workController.text,
                            ),
                          )
                        : null,
                  );
                } else {
                  //do something to alert
                  normalDialog(context, "แจ้งเตือน", "กรุณาระบุงานที่ปฏิบัติ");
                }
                //}
              }
            },
            child: Card(
              color: workingModels[index].workstatus == 2
                  ? Colors.green[200]
                  : Colors.grey[300],
              child: ListTile(
                leading: Container(
                  width: size * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showIconList(index, 0),
                  ),
                ),
                title: Text(
                  checkListModels[index].menuListName,
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

  Image showIconList(int index, int status) {
    return checkListModels[index].isChoice.contains("1")
        ? Image.asset(
            MyConstant.imgIconCheckList2,
            color: status == 0 ? Colors.white.withOpacity(0.5) : null,
            colorBlendMode: status == 0 ? BlendMode.modulate : null,
          )
        : checkListModels[index].isChoice.contains("2")
            ? Image.asset(
                MyConstant.imgIconCheckList3,
                color: status == 0 ? Colors.white.withOpacity(0.5) : null,
                colorBlendMode: status == 0 ? BlendMode.modulate : null,
              )
            : checkListModels[index].isChoice.contains("3")
                ? Image.asset(
                    MyConstant.imgIconCheckList4,
                    color: status == 0 ? Colors.white.withOpacity(0.5) : null,
                    colorBlendMode: status == 0 ? BlendMode.modulate : null,
                  )
                : checkListModels[index].isChoice.contains("4")
                    ? Image.asset(
                        MyConstant.imgIconCheckList5,
                        color:
                            status == 0 ? Colors.white.withOpacity(0.5) : null,
                        colorBlendMode: status == 0 ? BlendMode.modulate : null,
                      )
                    : Image.asset(
                        MyConstant.imgIconCheckList1,
                        color:
                            status == 0 ? Colors.white.withOpacity(0.5) : null,
                        colorBlendMode: status == 0 ? BlendMode.modulate : null,
                      );
  }

  Widget buildWorkPerform() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: size * 0.9,
        child: TextFormField(
          controller: workController,
          validator: (value) {
            if (value.isEmpty) {
              return 'กรุณาระบุงานที่ปฏิบัติ';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[300], width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[500], width: 2.0),
            ),
            prefixIcon: Icon(
              Icons.description,
              color: Colors.green[600],
            ),
            labelText: 'งานที่ปฏิบัติ',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildRadioMainLine() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: size * 1,
        child: Row(
          children: [
            Expanded(
              child: RadioListTile(
                value: '1',
                groupValue: choose,
                onChanged: (value) {
                  setState(() {
                    choose = value;
                  });
                },
                title: Text(
                  'การปฏิบัติงานระบบ\nจำหน่าย Main Line',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: RadioListTile(
                value: '0',
                groupValue: choose,
                onChanged: (value) {
                  setState(() {
                    choose = value;
                  });
                },
                title: Text(
                  'การปฏิบัติงานหลังDrop และระบบแรงต่ำ',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkConnection(BuildContext context) async {
    final bool isConn = await InternetConnectionChecker().hasConnection;
    setState(() {
      isConnected = isConn;
    });
  }

  Future<Null> 
  prepareWorking() async {
    if (workID == 0) {
      int lastID = 1;
      await SQLiteHelperOutage().selectLastID().then((result) {
        if (result == null) {
        } else {
          lastID = result;
          setState(() {
            load = false;
            workID = lastID;
          });
        }
      });

      // insert for transaction working
      //print("### getCheckList  = ${checkListModels.length}");
      for (int i = 0; i < checkListModels.length; i++) {
        SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel(
          reqNo: lastID.toString(),
          checklist: checkListModels[i].menuListID,
          mainmenu: checkListModels[i].menuMainID.toString(),
          dateCreated: MyConstant.strDateNow,
          submenU: checkListModels[i].menuSubID.toString(),
          user: userModel.userID,
          isComplete: 0,
          workperform: workController.text,
          isMainLine: int.parse(choose == null ? "0" : choose),
          imgList: "",
          region: userModel.rsg,
          remark: "",
          workstatus: 0,
        );
        SQLiteHelperOutage().insertWorkList(model);
      }
    }
    //else {
    //for check status
    SQLiteHelperOutage().selectWorkList(workID.toString(), "1").then((result) {
      if (result == null) {
        print("Error : " + result.toString());
      } else {
        setState(() {
          load = false;
          workingModels = result;
        });
      }
    });
  }

  Future<Null> setLine(String reqNo) async {
    findLatLng();

    //test
    // List<String> lineToken = [];
    // lineToken.add("gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz");

    final client = HttpClient();
    print('####--->  line Token  :  ${lineToken.length}');
    for (int i = 0; i < lineToken.length; i++) {
      print('####--->  line Token  :  ${lineToken[i]}');
      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
      String msg = "📣 ใบงาน : $reqNo" +
          "\n" +
          widget.mainName +
          " : ก่อนปฏิบัติงาน"
              "\n" +
          "\n" +
          workController.text +
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

      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");

      request.write('{"strMsg": "$msg",   "strToken": "${lineToken[i]}"}');
      // request.write(
      //     '{"strMsg": "$msg",   "strToken": "gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz"}');
      final response = await request.close();
      response.transform(utf8.decoder).listen((contents) {
        print("###### notification reply : $contents");
      });
    }
  }

  Future<Null> sendToServer(String reqNo) async {
    try {
      List<SQLiteWorklistOutageModel> listModels = [];
      String _strJson;
      List<String> listValues = [];
      InsertWorklistOutageModel insertWorklistModel;
      print('connecttion   : $isConnected');
      //test
      // isConnected = true;
      if (isConnected) {
        SQLiteHelperOutage().selectWorkList(reqNo, "1").then((result) async {
          if (result == null) {
            print("Error : " + result.toString());
          } else {
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
                  workPerform: workController.text,
                  workStatus: "0",
                  workType: choose,
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

            print(
                "Insert success  req_no = ${responeModel.result.reply.toString()}");

            SQLiteHelperOutage()
                .updateWorkListReq(reqNo, responeModel.result.reply.toString(),0);

            setLine(responeModel.result.reply.toString());
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => OutageMainMenu(
            //       userModel: userModel,
            //       //  userModel: userModel,
            //       // ownerId: userModel.ownerID,
            //     ),
            //   ),
            // );
          }
        });
      } else {
        offilineAlert(
            context, "OffLine", "ขณะนี้ทำงานแบบ offline", userModel, reqNo, 4);
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
    return arr;
  }

  Future<Null> getToken() async {
    print("#--------> get line token");
    final bool isConnect = await InternetConnectionChecker().hasConnection;
    MastMainMenuModel _mainMenuModel;
    try {
      if (isConnect) {
        print("#--------> get line token   : " +
            isConnect.toString() +
            "    rsg : " +
            userModel.rsg);
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
              print("### return  : " + contents);
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
  // }
} //class
