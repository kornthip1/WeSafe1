import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wesafe/models/insertWorklistModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/sqliteChecklistModel.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/responeModel.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/mainMenu.dart';

import 'package:wesafe/states/workRecord.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/utility/Test.dart';

class MainList extends StatefulWidget {
  final SQLiteUserModel user_model;
  final SQLiteWorklistModel sqLiteWorklistModel;
  final int countList;
  MainList(
      {@required this.user_model, this.sqLiteWorklistModel, this.countList});
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  SQLiteUserModel userModel;
  int index = 0;
  List<String> titles = MyConstant.listMenu;
  TextEditingController workController = TextEditingController();
  TextEditingController docController = TextEditingController();
  SQLiteWorklistModel _sqLiteWorklistModel;
  int _countList;
  double lat, lng;
  bool locationServiceEnable, load = true, denieBool = false;
  LocationPermission locationPermission;
  List<String> lineToken;
  List<ListItem> _listwork = [];
  bool isInitial = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userModel = widget.user_model;
    _sqLiteWorklistModel = widget.sqLiteWorklistModel;
    _countList = widget.countList;

    getWorkMenu(userModel.ownerID, userModel.rsg);
    getcheckList();
    readWorklist();
  }

  Future<Null> readWorklist() async {
    List<SQLiteWorklistModel> models = [];
    await SQLiteHelper().readWorkDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        SQLiteWorklistModel sqLiteWorklistModel;
        print("###### mainlist  model lenght :  ${models.length}");
        int count = 0;
        for (var item in models) {
          count++;
          isInitial = false;
          sqLiteWorklistModel = SQLiteWorklistModel(
              checklistID: item.checklistID,
              createDate: item.createDate,
              isChoice: 0,
              userID: "",
              lat: "",
              lng: "",
              workDoc: item.workDoc,
              workID: item.workID,
              workPerform: item.workPerform,
              workProvince: item.workProvince,
              workRegion: item.workRegion,
              workStation: item.workStation,
              workType: item.workType,
              remark: item.remark,
              isComplete: item.isComplete,
              gNDReason: item.gNDReason,
              ownerID: item.ownerID,
              rsg: item.rsg);
          print("########## $count ###############");
          print("  Main List >> ########   id :${item.id}");
          print("  Main List >> ########  work id :${item.workID}");
          print("  Main List >> ########   Req No :${item.reqNo}");
          print("  Main List >> ########  work Perfom :${item.workPerform}");
          print("  Main List >> ########  work Doc :${item.workDoc}");
          print("  Main List >> ########  checklist id :${item.checklistID}");
          print("  Main List >> ########  isCpmplete :${item.isComplete}");
          print("  Main List >> ########  image id :${item.imgList.length}");
          print(
              "  Main List >> ########  gnd id :${item.isSortGND}  :  ${item.gNDReason}");
          print(
              "  Main List >> ########  elec id :${item.isOffElect}  :  ${item.offElectReason}");
        } //for
        setState(() {
          _sqLiteWorklistModel = sqLiteWorklistModel;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formKey,
      appBar: AppBar(
        title: ShowTitle(title: 'บันทึกงาน', index: 1),
      ),
      drawer: ShowDrawer(userModel: userModel),
      body: Scrollbar(child: buildBodyContent()),
      bottomNavigationBar: Container(
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            if (_countList >= 6) {
              insertDataTOServer();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainMenu(
                      // userModel: userModel,
                      //  ownerId: userModel.ownerID,
                      ),
                ),
              );
            }
          },
          child: ShowTitle(
            title: "ยืนยัน",
            index: _countList >= 6 ? 3 : 4,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) =>
                  _countList >= 6 ? MyConstant.primart : Colors.grey[200])),
        ),
      ),
    );
  }

  Widget buildBodyContent() {
    _countList = _countList == null ? 0 : _countList;
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: buildWorkPerform(),
        ),
        Divider(
          color: Colors.grey,
          indent: 5.0,
          endIndent: 5.0,
        ),
        buildDoc(),
        buildListView(),
      ],
    );
  }

  Future<void> insertDataTOServer() async {
    List<SQLiteWorklistModel> models = [];
    List<String> listValues = [];
    String _strJson;
    int workId;
    InsertWorklistModel insertWorklistModel;
    try {
      await SQLiteHelper().readWorkDatabase().then((result) {
        if (result == null) {
        } else {
          double lat, lng;

          models = result;
          for (var item in models) {
            workId = item.workID == null ? "" : item.workID;
            insertWorklistModel = InsertWorklistModel(
              deptName: userModel.deptName == null ? "" : userModel.deptName,
              dateTimeWorkFinish: "",
              docRequire: item.workDoc == null ? "" : item.workDoc,
              empLeaderID: userModel.leaderId == null ? "" : userModel.leaderId,
              employeeID: userModel.userID == null ? "" : userModel.userID,
              iPAddress: "",
              image: item.imgList == null ? [""] : generateImage(item.imgList),
              isOffElect: item.isOffElect == null ? "" : item.isOffElect,
              offElectReason:
                  item.offElectReason == null ? "" : item.offElectReason,
              isSortGND: item.isSortGND == null ? "" : item.isSortGND,
              gNDReason: item.gNDReason == null ? "" : item.gNDReason,
              locationLat: "13.886555475448976",
              locationLng: "100.2603517379212",
              macAddress: "",
              menuChecklistID:
                  item.checklistID == null ? "" : item.checklistID.toString(),
              menuMainID:
                  item.mainWorkID == null ? "" : item.mainWorkID.toString(),
              menuSubID: "1",
              ownerID: item.ownerID == null ? "" : item.ownerID,
              parcel: "",
              province: item.workProvince == null ? "" : item.workProvince,
              regionCode: userModel.rsg == null ? "" : userModel.rsg,
              remark: "",
              sender: userModel.userID == null ? "" : userModel.userID,
              station: item.workStation == null ? "" : item.workStation,
              tokenNoti: "",
              waitApprove: "",
              workArea: item.workRegion == null ? "" : item.workRegion,
              workPerform: item.workPerform == null ? "" : item.workPerform,
              workStatus: "0",
              workType: item.workType == null ? "" : item.workType,
              reqNo: "",
            );

            _strJson = json.encode(insertWorklistModel);
            listValues.add(_strJson);
          }
        }
      });

      final response = await http.post(
        Uri.parse('${MyConstant.webService}WeSafe_InsertTransaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(listValues.toString()),
      );
      print("#######----> rsg ${userModel.rsg}");
      ResponeModel responeModel =
          ResponeModel.fromJson(jsonDecode(response.body));
      SQLiteHelper()
          .updateWorkReqNo(responeModel.result.reply.toString(), workId);

      print("Insert success  req_no = ${responeModel.result.reply.toString()}");

      //setLine(responeModel.result.reply.toString());


    } catch (E) {
      print("PREPair Error : $E");
    }
  }

  List generateImage(String strImg) {
    List arr = new List();
    arr = strImg.split(',');
    return arr;
  }

  Future<Null> setLine(String reqNo) async {
    DateTime now = DateTime.now();
    final client = HttpClient();

    for (int i = 0; i < lineToken.length; i++) {
      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
      String msg = "📣 ใบงาน : $reqNo" +
          "\n" +
          "การปฏิบัติงานภายในสถานีและระบบไฟฟ้า :  ก่อนปฏิบัติงาน " +
          "\n" +
          "\n" +
          "สถานี  : " +
          _sqLiteWorklistModel.workStation +
          "\n" +
          "จังหวัด" +
          _sqLiteWorklistModel.workProvince +
          "\n" +
          "การไฟฟ้าเขต :" +
          _sqLiteWorklistModel.workRegion +
          "\n" +
          "งานประเภท :" +
          _sqLiteWorklistModel.workType +
          "\n" +
          "\n" +
          "ผู้ส่งข้อมูล : " +
          "\n" +
          userModel.firstName +
          "  " +
          userModel.lastName +
          "\n" +
          userModel.deptName +
          "\n" +
          "รายละเอียดงาน : " +
          _sqLiteWorklistModel.workPerform +
          "\n" +
          now.toString() +
          "\n" +
          "\n" +
          "https://wesafe.pea.co.th/admin/detail.aspx?WebGetReqNO=$reqNo";

      print("#######  Token   ${lineToken[i]} ");

      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.write(
          '{"strMsg": "$msg",   "strToken": "m49F7ajqHy0ic6wanQ5VWael9vo8dCFHz4oR1DJhR3q"}');
      //  request.write('{"strMsg": "$msg",   "strToken": "${lineToken[i]}"}');

      final response = await request.close();
      response.transform(utf8.decoder).listen((contents) {
        print("###### notification reply : $contents");
      });
    }

    SQLiteHelper().updateWorkComplete(reqNo);
  }

  Widget buildWorkPerform() {
    double size = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Container(child: Text("รายละเอียดงาน")),
            ),
          ],
        ),
        Container(
          width: size * 0.7,
          child: TextFormField(
            controller: workController,
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาระบุรายละเอียดงาน';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.work_rounded),
              labelText: _sqLiteWorklistModel == null
                  ? 'รายละเอียดงาน :'
                  : _sqLiteWorklistModel.workPerform == null
                      ? 'รายละเอียดงาน :'
                      : _sqLiteWorklistModel.workPerform.trim() == ""
                          ? 'รายละเอียดงาน :'
                          : _sqLiteWorklistModel.workPerform,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDoc() {
    double size = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Container(child: Text("เอกสารขอดับไฟ")),
            ),
          ],
        ),
        Container(
          width: size * 0.7,
          child: TextFormField(
            controller: docController,
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาระบุเอกสารขอดับไฟ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.description),
              labelText: _sqLiteWorklistModel == null
                  ? 'เอกสารขอดับไฟ :'
                  : _sqLiteWorklistModel.workDoc == null
                      ? 'เอกสารขอดับไฟ :'
                      : _sqLiteWorklistModel.workDoc.trim() == ""
                          ? 'เอกสารขอดับไฟ :'
                          : _sqLiteWorklistModel.workDoc,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          indent: 5.0,
          endIndent: 5.0,
        )
      ],
    );
  }

  Expanded buildListView() {
    SQLiteWorklistModel sqLiteWorklistModel;
    return new Expanded(
      child: Container(
        child: new ListView.builder(
          itemCount: _listwork.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              bool isContinue = false;

              if (_countList == null) {
                _countList = 0;
              }

              print(
                  "mainlist ######   list > $_countList  :    index > $index");
              if (_countList >= index) {
                DateTime now = DateTime.now();

                if (isInitial) {
                  workController.text == null
                      ? normalDialog(context, "กรุณาระบุ", "รายละเอียดงาน")
                      : workController.text == ""
                          ? normalDialog(context, "กรุณาระบุ", "รายละเอียดงาน")
                          : isContinue = true;

                  if (isContinue) {
                    isContinue = false;
                    docController.text == null
                        ? normalDialog(context, "กรุณาระบุ", "เอกสารขอดับไฟ")
                        : docController.text == ""
                            ? normalDialog(
                                context, "กรุณาระบุ", "เอกสารขอดับไฟ")
                            : isContinue = true;
                  }

                  print(
                      "mainlistttt    workController.text   : $workController.text");

                  print(
                      "mainlistttt    workController.text   : $workController.text");

                  if (isContinue) {
                    print(
                        "############ mainlist  province  :  ${widget.sqLiteWorklistModel.workProvince}");
                    sqLiteWorklistModel = SQLiteWorklistModel(
                        checklistID: index,
                        subWorkID: 1,
                        createDate: now.toString(),
                        isChoice: 0,
                        userID: "",
                        lat: "",
                        lng: "",
                        workDoc: docController.text,
                        workID: 1,
                        workPerform: workController.text,
                        workProvince: widget.sqLiteWorklistModel.workProvince,
                        workRegion: widget.sqLiteWorklistModel.workRegion,
                        workStation: widget.sqLiteWorklistModel.workStation,
                        workType: widget.sqLiteWorklistModel.workType,
                        rsg: userModel.rsg,
                        remark: null);

                    // sqLiteWorklistModel = _sqLiteWorklistModel == null
                    //     ? readWorklist()
                    //     : sqLiteWorklistModel;

                    setState(() {
                      _sqLiteWorklistModel = sqLiteWorklistModel;
                    });
                  }
                } else {
                  readWorklist();
                  isContinue = true;
                }

                print("mainlistttt    isContinue   : $isContinue");
                print(
                    "mainlistttt    widget.countList   : ${widget.countList}");
                if (isContinue) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkRecord(
                        sqLiteUserModel: userModel,
                        index: index + 1,
                        indexWork: int.parse(
                          _listwork[index].value,
                        ), //index is work type 0 = checklist, 1 = text , 2 = pic , 3 = radio
                        workListname:
                            _listwork[index].name.contains("ตรวจวัดเเรงดัน")
                                ? "ตรวจวัดเเรงดัน"
                                : _listwork[index].name.contains("ต่อลงดิน")
                                    ? "ตรวจสอบการต่อลงดิน"
                                    : _listwork[index].name,
                        sqLiteWorklistModel: _sqLiteWorklistModel,
                        countList:
                            widget.countList == null ? 0 : widget.countList,
                      ),
                    ),
                  );
                }
              }
            },
            child: Card(
              color: _sqLiteWorklistModel == null
                  ? Colors.grey
                  : _sqLiteWorklistModel.isComplete == 1 &&
                          _sqLiteWorklistModel.checklistID >= index + 1
                      ? Colors.green
                      : Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    child: ListTile(
                      leading: Icon(
                        int.parse(_listwork[index].value) == 0
                            ? Icons.check
                            : int.parse(_listwork[index].value) == 1
                                ? Icons.description_outlined
                                : int.parse(_listwork[index].value) == 2
                                    ? Icons.camera_alt_outlined
                                    : int.parse(_listwork[index].value) == 3
                                        ? Icons.radio_button_checked_outlined
                                        : Icons.more_horiz_outlined,
                        size: 36,
                        color: MyConstant.primart,
                      ),
                      title: Text('${index + 1}  :   ${_listwork[index].name}'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> getcheckList() async {
    List<SQLiteChecklistModel> models = [];
    List<ListItem> listwork = [];
    await SQLiteHelper().selectCheclList().then((result) {
      if (result == null) {
      } else {
        models = result;
        for (int i = 0; i < models.length; i++) {
          listwork.add(ListItem(models[i].type.toString(),
              models[i].menuChecklistName.toString()));
        }

        setState(() {
          _listwork = listwork;
        });
      }
    });
  }

  ListView buildChecklist() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => index == 0
                ? Authen()
                : MainList(
                    user_model: userModel,
                  ),
          ),
        ),
        child: Card(
          color: index == 0
              ? Colors.orange[900]
              : index == 1
                  ? Colors.yellow[700]
                  : index == 2
                      ? Colors.teal[600]
                      : index == 3
                          ? Colors.blueGrey
                          : Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ShowTitle(title: '$index  : Work  ', index: 1),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> findLatLng() async {
    Position position = await Geolocator.getLastKnownPosition();

    print("############# >>>  ${position.latitude}");
    /*
    await Geolocator.isLocationServiceEnabled().then((value) async {
      setState(() {
        load = false;
      });
      locationServiceEnable = value;

      if (locationServiceEnable) {
        locationPermission = await Geolocator.checkPermission();
        print(
            '######### your permission ==>  ${locationPermission.toString()}');
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(
              context, 'หาพิกัดไม่ได้', 'กรุณาเปิดอนุญาติการหาพิกัดก่อน');
          setState(() {
            denieBool = true;
          });
        } else if (locationPermission == LocationPermission.denied) {
          locationPermission = await Geolocator.requestPermission();
          denieBool = true;

          if (locationPermission == LocationPermission.deniedForever) {
            normalDialog(
                context, 'หาพิกัดไม่ได้', 'กรุณาเปิดอนุญาติการหาพิกัดก่อน');
            setState(() {
              denieBool = true;
            });
          }
        } else {
          print('#### else');
          Position position = await findLatLng();
          setState(() {
            lat = position.latitude;
            lng = position.longitude;
            print('############  lat = $lat   lng == $lng');
          });
        }
      } else {
        normalDialog(
            context, 'location service off', 'Please Open location service');
      }
    });\\*/
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }

    return position;
  } //

  Future<Null> getWorkMenu(String ownerID, String rsg) async {
    MastMainMenuModel _mainMenuModel;
    try {
      final client = HttpClient();

      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu"));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write('{"Owner_ID": "$ownerID",   "REGION_CODE": "$rsg"}');
      final response = await request.close();

      response.transform(utf8.decoder).listen(
        (contents) {
          if (contents.contains('Error')) {
            contents = contents.replaceAll("[", "").replaceAll("]", "");
            normalDialog(context, 'Error', contents);
          } else {
            _mainMenuModel = MastMainMenuModel.fromJson(json.decode(contents));

            for (int i = 0; i < 1; i++) {
              lineToken = _mainMenuModel.result[i].lineToken;
            }
          } //else
        },
      );
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }
}
