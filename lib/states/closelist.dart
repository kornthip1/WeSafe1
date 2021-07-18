import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wesafe/models/insertWorklistModel.dart';
import 'package:wesafe/models/checkStatusModel.dart';
import 'package:wesafe/models/sqlitePercelModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/responeModel.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/closeRecord.dart';
import 'package:wesafe/states/mainMenu.dart';
import 'package:wesafe/states/workRecord.dart';

import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/states/checkWork.dart';

class CloseList extends StatefulWidget {
  final SQLiteUserModel user_model;
  final CheckStatusModel checkStatusModel;
  final SQLitePercelModel sqLitePercelModel;
  final SQLiteWorklistModel sqLiteWorklistModel;
  CloseList(
      {@required this.user_model,
      this.checkStatusModel,
      this.sqLitePercelModel,
      this.sqLiteWorklistModel});
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
  @override
  void initState() {
    super.initState();
    _sqLiteWorklistModel = widget.sqLiteWorklistModel;
    readWorklist();
    userModel = widget.user_model;
    _checkSatatusModel = widget.checkStatusModel;
    _sqLitePercelModel = widget.sqLitePercelModel;
  }

  Future<Null> readWorklist() async {
    print("###closelist   readWorklist()");
    List<SQLiteWorklistModel> models = [];
    await SQLiteHelper().readWorkDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        SQLiteWorklistModel sqLiteWorklistModel;
        for (var item in models) {
          print("##### workperform : ${item.workPerform}");
          print("##### work doc: ${item.workDoc}");
          sqLiteWorklistModel = SQLiteWorklistModel(
            //.result[index].reqNo
            reqNo: _checkSatatusModel == null
                ? _sqLiteWorklistModel.reqNo
                : _checkSatatusModel.result[index].reqNo == ""
                    ? _sqLiteWorklistModel.reqNo
                    : _checkSatatusModel.result[index].reqNo,
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
          );
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
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildNewJob(context),
                buildCheckStatus(context),
              ],
            ),
            buildSignOut()
          ],
        ),
      ),
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MainMenu(
            //       userModel: userModel,
            //       ownerId: userModel.ownerID,
            //     ),
            //   ),
            // );
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
    int workId;

    try {
      InsertWorklistModel insertWorklistModel = InsertWorklistModel(
        reqNo: _sqLitePercelModel.reqNo,
        deptName: userModel.deptName == null ? "" : userModel.deptName,
        dateTimeWorkFinish: "",
        docRequire: _sqLiteWorklistModel.workDoc == null
            ? ""
            : _sqLiteWorklistModel.workDoc,
        empLeaderID: userModel.leaderId == null ? "" : userModel.leaderId,
        employeeID: userModel.userID == null ? "" : userModel.userID,
        iPAddress: "",
        image: [],
        isOffElect: _sqLiteWorklistModel.isOffElect == null
            ? ""
            : _sqLiteWorklistModel.isOffElect,
        offElectReason: _sqLiteWorklistModel.offElectReason == null
            ? ""
            : _sqLiteWorklistModel.offElectReason,
        isSortGND: _sqLiteWorklistModel.isSortGND == null
            ? ""
            : _sqLiteWorklistModel.isSortGND,
        gNDReason: _sqLiteWorklistModel.gNDReason == null
            ? ""
            : _sqLiteWorklistModel.gNDReason,
        locationLat: "13.886555475448976",
        locationLng: "100.2603517379212",
        macAddress: "",
        menuChecklistID: "7",
        menuMainID: "300",
        menuSubID: "2",
        ownerID: "Z",
        parcel: _sqLitePercelModel.item,
        sender: userModel.userID == null ? "" : userModel.userID,
        workStatus: "5",
        province: "",
        regionCode: "",
        remark: "",
        station: "",
        tokenNoti: "",
        waitApprove: "",
        workArea: "",
        workPerform: "",
        workType: "",
      );
      print("#######----> reqNO  ${_sqLitePercelModel.reqNo}");
      print("######-----> sub menu  ${insertWorklistModel.menuSubID}");
      _strJson = json.encode(insertWorklistModel);
      listValues.add(_strJson);

      final response = await http.post(
        Uri.parse('${MyConstant.webService}WeSafe_InsertTransaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: utf8.encode(listValues.toString()),
      );

      ResponeModel responeModel =
          ResponeModel.fromJson(jsonDecode(response.body));
      SQLiteHelper()
          .updateWorkReqNo(responeModel.result.reply.toString(), workId);

      print("Insert success  req_no = ${responeModel.result.reply.toString()}");

      setLine(responeModel.result.reply.toString());
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
    final request = await client
        .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
    String msg = "📣 ปิดงาน : $reqNo" +
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
    request.headers.contentType =
        new ContentType("application", "json", charset: "utf-8");
    request.write(
        '{"strMsg": "$msg",   "strToken": "6Yjnn2gWWRU5oloUt1guihtMiL9BIZjYQBtYkvUH5SK"}');

    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print("###### notification reply : $contents");
    });
  }

  Widget buildWorkPerform() {
    print("################## - buildWorkPerform() - ##################");
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
              title: _sqLiteWorklistModel.workDoc == null
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
              print("######## userModel  ${userModel.userID}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkRecord(
                    sqLiteUserModel: userModel,
                    index: 7,
                    indexWork: 7,
                    workListname: "จำนวน พัสดุ ที่ใช้งาน",
                    sqLiteWorklistModel: _sqLiteWorklistModel,
                    countList: 6,
                  ),
                ),
              );
            },
            child: Card(
              color: _sqLitePercelModel == null
                  ? Colors.grey
                  : _sqLitePercelModel.checklistID == 7
                      ? Colors.green
                      : Colors.grey,
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

  ListTile buildCheckStatus(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_outline,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[1],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckWork(),
          ),
        );
      },
    );
  }

  ListTile buildNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[0],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        //Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenu(
              userModel: userModel,
              ownerId: userModel.ownerID,
            ),
          ),
        );
      },
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();
            SQLiteHelper().deleteWorkAll();
            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: Colors.red[900],
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign out',
            index: 3,
          ),
        ),
      ],
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primart),
      currentAccountPicture: ShowMan(),
      accountName: userModel == null
          ? Text('Name')
          : Text('${userModel.firstName}  ${userModel.lastName}'),
      accountEmail: userModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${userModel.deptName}'),
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
}
