import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wesafe/models/insertWorklistModel.dart';
import 'package:wesafe/models/checkStatusModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/sqlitePercelModel.dart';
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

class CloseList extends StatefulWidget {
  final SQLiteUserModel user_model;
  final String reqNo;
  final bool isComplate;
  CloseList({@required this.user_model, this.reqNo, this.isComplate});
  @override
  _CloseListState createState() => _CloseListState();
}

class _CloseListState extends State<CloseList> {
  SQLiteUserModel userModel;
  int index = 0;
  List<String> titles = MyConstant.listMenu;
  TextEditingController workController = TextEditingController();
  TextEditingController docController = TextEditingController();
  SQLiteWorklistModel _sqLiteWorklistModel;
  CheckStatusModel _checkSatatusModel;
  SQLitePercelModel _sqLitePercelModel;
  int _countList;
  double lat, lng;
  bool locationServiceEnable, load = true, denieBool = false;
  LocationPermission locationPermission;
  List<String> lineToken;
  @override
  void initState() {
    super.initState();
    readWorklist();
    userModel = widget.user_model;
  }

  Future<Null> readWorklist() async {
    //print("###closelist   readWorklist()");
    List<SQLiteWorklistModel> models = [];
    await SQLiteHelper().readWorkByReqNo(widget.reqNo).then((result) {
      if (result == null) {
      } else {
        models = result;
        SQLiteWorklistModel sqLiteWorklistModel;
        for (var item in models) {
          // print("##### workperform : ${item.workPerform}");
          print("##### region code: ${item.rsg}");
          sqLiteWorklistModel = SQLiteWorklistModel(
              //.result[index].reqNo
              reqNo: item.reqNo,
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
              rsg: item.rsg);
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
      appBar: AppBar(
        title: ShowTitle(title: 'MAIN LIST', index: 1),
      ),
      drawer: ShowDrawer(userModel: userModel),
      body: Scrollbar(child: buildBodyContent()),
    );
  }

  Widget buildBodyContent() {
    _countList = _countList == null ? 0 : _countList;
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: buildWorkPerform(),
        ),
        Divider(
          color: Colors.grey,
          indent: 5.0,
          endIndent: 5.0,
        ),
        buildDoc(),
        buildListView(),
        ElevatedButton(
          onPressed: () {
            insertDataTOServer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainMenu(
                    // userModel: userModel,
                    // ownerId: userModel.ownerID,
                    ),
              ),
            );
          },
          child: Text("ปิดงาน"),
        ),
      ],
    );
  }

  Future<void> insertDataTOServer() async {
    List<SQLiteWorklistModel> models = [];
    List<String> listValues = [];
    String _strJson;
    String _strPercelItem = "";
    List<SQLitePercelModel> percelModels = [];
    await SQLiteHelper()
        .selectPercelByID(widget.reqNo.substring(9, widget.reqNo.length))
        .then((result) {
      if (result == null) {
      } else {
        percelModels = result;
        for (var item in percelModels) {
          print("######## --- > percel  : ${item.item}");
          print("######## --- > workID  : ${item.workID}");
          _strPercelItem = item.item;
        }
      }
    });

    //for

    try {
      //user_model

      print("########### ---- > Region : ${widget.user_model.rsg}");
      InsertWorklistModel insertWorklistModel = InsertWorklistModel(
        reqNo: widget.reqNo,
        deptName: userModel.deptName == null ? "" : userModel.deptName,
        dateTimeWorkFinish: "",
        docRequire: _sqLiteWorklistModel == null
            ? ""
            : _sqLiteWorklistModel.workDoc == null
                ? ""
                : _sqLiteWorklistModel.workDoc,
        empLeaderID: userModel.leaderId == null ? "" : userModel.leaderId,
        employeeID: userModel.userID == null ? "" : userModel.userID,
        iPAddress: "",
        image: [""],
        isOffElect: _sqLiteWorklistModel == null
            ? ""
            : _sqLiteWorklistModel.isOffElect == null
                ? ""
                : _sqLiteWorklistModel.isOffElect,
        offElectReason: _sqLiteWorklistModel == null
            ? ""
            : _sqLiteWorklistModel.offElectReason == null
                ? ""
                : _sqLiteWorklistModel.offElectReason,
        isSortGND: _sqLiteWorklistModel == null
            ? ""
            : _sqLiteWorklistModel.isSortGND == null
                ? ""
                : _sqLiteWorklistModel.isSortGND,
        gNDReason: _sqLiteWorklistModel == null
            ? ""
            : _sqLiteWorklistModel.gNDReason == null
                ? ""
                : _sqLiteWorklistModel.gNDReason,
        locationLat: "13.886555475448976",
        locationLng: "100.2603517379212",
        macAddress: "",
        menuChecklistID: "1",
        menuMainID: "300",
        menuSubID: "2",
        ownerID: userModel.ownerID == null ? "" : userModel.ownerID,
        parcel: _strPercelItem,
        sender: userModel.userID == null ? "" : userModel.userID,
        workStatus: "5",
        province: "",
        regionCode: userModel == null
            ? ""
            : userModel.rsg == null
                ? ""
                : userModel.rsg,
        remark: "",
        station: "",
        tokenNoti: "",
        waitApprove: "",
        workArea: "",
        workPerform: "",
        workType: "",
      );
      print("#######----> reqNO  ${widget.reqNo}");
      print("######-----> sub _strPercelItem  $_strPercelItem");
      _strJson = json.encode(insertWorklistModel);
      listValues.add(_strJson);

      print("############ --->  ${listValues.toString()}");
      final response = await http.post(
        Uri.parse(
            '${MyConstant.webService}WeSafe_Insert_TransactionWork_Close'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(listValues.toString()),
      );

      ResponeModel responeModel =
          ResponeModel.fromJson(jsonDecode(response.body));
      // SQLiteHelper()
      //     .updateWorkReqNo(responeModel.result.reply.toString(), workId);

      print("update Close reply = ${responeModel.result.reply.toString()}");
      print("update Close reply  message = ${responeModel.message}");

      setLine(widget.reqNo, _strPercelItem);
    } catch (E) {
      print("PREPair Error : $E");
    }
  }

  List generateImage(String strImg) {
    List arr = new List();
    arr = strImg.split(',');
    return arr;
  }

  Future<Null> setLine(String reqNo, String _strPercelItem) async {
    DateTime now = DateTime.now();
    final client = HttpClient();
    final request = await client
        .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
    String msg = "📣 ปิดงาน : $reqNo" +
        "\n" +
        "การปฏิบัติงานภายในสถานีและระบบไฟฟ้า :  หลังปฏิบัติงาน " +
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
        "อุปกรณ์ที่ใช้ไป : " +
        _strPercelItem +
        "\n" +
        now.toString() +
        "\n" +
        "\n" +
        "https://wesafe.pea.co.th/admin/detail.aspx?WebGetReqNO=$reqNo";
    request.headers.contentType =
        new ContentType("application", "json", charset: "utf-8");
    request.write(
        '{"strMsg": "$msg",   "strToken": "m49F7ajqHy0ic6wanQ5VWael9vo8dCFHz4oR1DJhR3q"}');

    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print("###### notification reply : $contents");
    });
  }

  Widget buildWorkPerform() {
    if (_sqLiteWorklistModel == null) {
      readWorklist();
    }
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
          child: ShowTitle(
            title: _sqLiteWorklistModel == null
                ? ""
                : _sqLiteWorklistModel.workPerform,
            index: 4,
          ),
        ),
      ],
    );
  }

  Widget buildDoc() {
    if (_sqLiteWorklistModel == null) {
      readWorklist();
    }
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShowTitle(
              title: _sqLiteWorklistModel == null
                  ? ""
                  : _sqLiteWorklistModel.workDoc == null
                      ? ""
                      : _sqLiteWorklistModel.workDoc,
              index: 4,
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
    return new Expanded(
      child: Container(
        child: new ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              SQLiteWorklistModel modelss;
              if (_sqLiteWorklistModel == null ||
                  _sqLiteWorklistModel.reqNo == null) {
                setState(() {
                  modelss = SQLiteWorklistModel(reqNo: widget.reqNo);
                });
              } else {
                modelss = _sqLiteWorklistModel;
              }
              print("######## userModel  ${userModel.userID}");
              print("######## req no  ${modelss.reqNo}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkRecord(
                    sqLiteUserModel: userModel,
                    index: 7,
                    indexWork: 7,
                    workListname: "จำนวน พัสดุ ที่ใช้งาน",
                    sqLiteWorklistModel: modelss,
                    countList: 6,
                  ),
                ),
              );
            },
            child: Card(
              color: widget.isComplate?Colors.green:Colors.grey,
              // color: _sqLitePercelModel == null
              //     ? Colors.grey
              //     : _sqLitePercelModel.checklistID == 7
              //         ? Colors.green
              //         : Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.calculate_outlined,
                        size: 36,
                        color: MyConstant.primart,
                      ),
                      title: Text(' จำนวน พัสดุ ที่ใช้งาน '),
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

  ListView buildChecklist() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => index == 0 ? Authen() : CloseList(),
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
  }

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
