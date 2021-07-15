import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/insertWorklistModel.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/mainMenu.dart';

import 'package:wesafe/states/workRecord.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/utility/Test.dart';
import 'package:wesafe/states/checkWork.dart';

class MainList extends StatefulWidget {
  final SQLiteUserModel user_model;
  final SQLiteWorklistModel sqLiteWorklistModel;
  MainList({@required this.user_model, this.sqLiteWorklistModel});
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
  @override
  void initState() {
    super.initState();
    userModel = widget.user_model;
    _sqLiteWorklistModel = widget.sqLiteWorklistModel;

    //readWorklist();
  }

  Future<Null> readWorklist() async {
    List<SQLiteWorklistModel> models = [];
    await SQLiteHelper().readWorkDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        SQLiteWorklistModel sqLiteWorklistModel;
        for (var item in models) {
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

            //setLine();

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
          child: Text("ยืนยัน"),
        ),
      ],
    );
  }

  Future<void> insertDataTOServer() async {
    List<SQLiteWorklistModel> models = [];
    List<String> listValues = [];
    try {
      await SQLiteHelper().readWorkDatabase().then((result) {
        if (result == null) {
        } else {
          models = result;
          InsertWorklistModel insertWorklistModel;

          for (var item in models) {
            generateImage(item.imgList);
            print("###### check user model  : $userModel");
            insertWorklistModel = InsertWorklistModel(
                deptName: userModel.deptName == null ? "" : userModel.deptName,
                dateTimeWorkFinish: "",
                docRequire: item.workDoc == null ? "" : item.workDoc,
                empLeaderID: userModel.leaderId,
                employeeID: userModel.userID == null ? "" : userModel.userID,
                gNDReason: "",
                iPAddress: "",
                image: generateImage(item.imgList).replaceAll("[", "").replaceAll("]", ""),
                isOffElect: "0",
                isSortGND: "0",
                locationLat: "",
                locationLng: "",
                macAddress: "",
                menuChecklistID: item.checklistID == null? "" : item.checklistID.toString(),
                menuMainID: item.mainWorkID == null? "" : item.mainWorkID.toString(),
                menuSubID: item.subWorkID == null? "" : item.subWorkID.toString(),
                offElectReason: "",
                ownerID: item.ownerID == null ? "" : item.ownerID,
                parcel: "",
                province: item.workProvince == null ? "" : item.workProvince,
                regionCode: userModel.rsg,
                remark: "",
                sender: userModel.userID == null ? "" : userModel.userID,
                station: item.workStation == null ? "" : item.workStation,
                tokenNoti: "",
                waitApprove: "",
                workArea: item.workRegion == null ? "" : item.workRegion,
                workPerform: item.workPerform == null ? "" : item.workPerform,
                workStatus: "1",
                workType: item.workType == null ? "" : item.workType,
                );

            String _strJson = json.encode(insertWorklistModel);
            listValues.add(_strJson);
          }
        }
      });

      print("########## listValues lenhtg >> ${listValues.length}");
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse(
          "${MyConstant.webService}WeSafe_InsertTransaction")); //CheckEmp
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json;charset=utf-8");
      var data = listValues.toString();
      request.write(data);

      final response = await request.close();

      response.transform(utf8.decoder).listen(
        (contents) {
          contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");
          if (contents.contains('Error')) {
            print("########## return Error  content  >> $contents");
          } else {
            print("########## return Insert  content  >> $contents");
          } //else
        },
      );
    } catch (E) {
      print("PREPair Error : $E");
    }
  }

  String generateImage(String strImg) {
    List arr;
    arr = strImg.split(',');
    // print("########## generateImage arr >> ${arr.length}");
    // print("########## generateImage value >> ${arr.toString()}");

    return arr.toString();
  }
  // Future<Null> insertDataTOServer() async {

  //   try {
  //     final client = HttpClient();

  //     final request = await client.postUrl(Uri.parse(
  //         "${MyConstant.webService}WeSafe_InsertTransaction")); //CheckEmp
  //     request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
  //     var values = '[{"tt" : "122"}]';

  //     String _json = json.encode(_sqLiteWorklistModel);

  //     request.write(values);

  //     final response = await request.close();
  //     response.transform(utf8.decoder).listen(
  //       (contents) {
  //         contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");
  //         if (contents.contains('Error')) {
  //         } else {} //else
  //       },
  //     );
  //   } catch (e) {
  //     normalDialog(context, "Error", e.toString());
  //   }
  // }

  Future<Null> setLine() async {
    DateTime now = DateTime.now();
    final client = HttpClient();
    final request = await client.postUrl(
        Uri.parse("${MyConstant.webService}WeSafe_SendToken")); //CheckEmp
    //request.headers.set(HttpHeaders.contentTypeHeader, "application/json",);
    String msg = "📣 ใบงาน : WSI2021OZ0000000001" +
        "\n" +
        "การปฏิบัติงานภายในสถานีและระบบไฟฟ้า :  ก่อนปฏิบัติงาน " +
        "\n" +
        "\n" +
        //"งานสำหรับ สนญ.   " +
        _sqLiteWorklistModel.workRegion +
        "  " +
        _sqLiteWorklistModel.workProvince +
        "  " +
        _sqLiteWorklistModel.workStation +
        "\n" +
        "\n" +
        userModel.firstName +
        "  " +
        userModel.lastName +
        "\n" +
        userModel.deptName +
        "\n" +
        "\n" +
        now.toString() +
        "\n" +
        "\n" +
        "https://wesafe.pea.co.th/admin/detail.aspx?WebGetReqNO=WSI2021OZ0000000001";
    request.headers.contentType =
        new ContentType("application", "json", charset: "utf-8");
    request.write(
        '{"strMsg": "$msg",   "strToken": "UZ8IMR9PKBxJyjDdZTPmD0vlRDuvzOoQuS7vpWhhDGG"}');

    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print("###### $contents");
    });
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
    double sizH = MediaQuery.of(context).size.height;
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
    List<ListItem> _listwork = [];
    _sqLiteWorklistModel.remark == "9" || _sqLiteWorklistModel.remark == "11"
        ? _listwork = [
            ListItem("3", "ลักษณะงาน"), //3
            ListItem("2", "ภาพการประชุมชี้แจงงาน"),
            ListItem("2", "ภาพผู้ปฏิบัติงานสวมใส่ PPE "),
            ListItem("3", "ภาพการตรวจวัดเเรงดัน"),
            ListItem("2", "ภาพเครื่องมือปฏิบัติงาน"),
            ListItem("3", "ภาพการต่อลงดิน"),
            ListItem("5", "จำนวน พัสดุ ที่ใช้งาน"),
          ]
        : _listwork = [
            ListItem("3", "ลักษณะงาน"), //3
            ListItem("2", "ภาพการประชุมชี้แจงงาน"),
            ListItem("2", "ภาพผู้ปฏิบัติงานสวมใส่ PPE "),
            ListItem("3", "ภาพการตรวจวัดเเรงดัน"),
            ListItem("2", "ภาพเครื่องมือปฏิบัติงาน"),
            ListItem("3", "ภาพการต่อลงดิน"),
          ];

    return new Expanded(
      child: Container(
        child: new ListView.builder(
          itemCount: _listwork.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              DateTime now = DateTime.now();

              SQLiteWorklistModel sqLiteWorklistModel = SQLiteWorklistModel(
                  checklistID: index,
                  createDate: now.toString(),
                  isChoice: 0,
                  userID: "",
                  lat: "",
                  lng: "",
                  workDoc: docController.text,
                  workID: _sqLiteWorklistModel.workID,
                  workPerform: workController.text,
                  workProvince: _sqLiteWorklistModel.workProvince,
                  workRegion: _sqLiteWorklistModel.workRegion,
                  workStation: _sqLiteWorklistModel.workStation,
                  workType: _sqLiteWorklistModel.workType,
                  remark: null);

              sqLiteWorklistModel = _sqLiteWorklistModel == null
                  ? readWorklist()
                  : sqLiteWorklistModel;
              //SQLiteHelper().insertWorkDatebase(sqLiteWorklistModel);

              setState(() {
                _sqLiteWorklistModel = sqLiteWorklistModel;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkRecord(
                    sqLiteUserModel: userModel,
                    index: index,
                    indexWork: int.parse(
                      _listwork[index].value,
                    ), //index is work type 0 = checklist, 1 = text , 2 = pic , 3 = radio
                    workListname: _listwork[index].name.contains("ลักษณะงาน")
                        ? "ดับทั้งสถานีไฟฟ้า"
                        : _listwork[index].name.contains("ตรวจวัดเเรงดัน")
                            ? "ตรวจวัดเเรงดัน"
                            : _listwork[index].name.contains("ต่อลงดิน")
                                ? "Sort GND"
                                : "",
                    sqLiteWorklistModel: sqLiteWorklistModel,
                  ),
                ),
              );
            },
            child: Card(
              color: //Colors.grey,
                  _sqLiteWorklistModel.remark == "1" &&
                          _sqLiteWorklistModel.checklistID >= index
                      ? Colors.green
                      : _sqLiteWorklistModel.remark == "9" && index != 6
                          ? Colors.green
                          : _sqLiteWorklistModel.remark == "11"
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
                                        : Icons.more_horiz_outlined

                        // index == 0
                        //     ? Icons.camera_alt_outlined
                        //     : index == 1
                        //         ? Icons.offline_bolt_outlined
                        //         : index == 2
                        //             ? Icons.fence_outlined
                        //             : Icons.check_circle_outline

                        ,
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
}
