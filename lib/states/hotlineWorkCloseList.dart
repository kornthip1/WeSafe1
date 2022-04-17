import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wesafe/models/InsertWorklistOutageModel.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/mastOutageCloseWork.dart';
import 'package:wesafe/models/responeModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/hotlineCloseAndCheck.dart';
import 'package:wesafe/states/hotlineMainMenu.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/offliceAlert.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class HotlineWorkCloseList extends StatefulWidget {
  final SQLiteUserModel userModel;
  final String reqNo;
  final int workStatus;
  final String mainID;
  final String subID;

  HotlineWorkCloseList(
      {@required this.userModel,
      this.reqNo,
      this.workStatus,
      this.mainID,
      this.subID});

  @override
  State<HotlineWorkCloseList> createState() => _HotlineWorkCloseListState();
}

class _HotlineWorkCloseListState extends State<HotlineWorkCloseList> {
  List<MastOutageMenuModel> checkListModels = [];
  List<SQLiteWorklistOutageModel> listModels = [];
  List<String> lineToken;
  bool isConnected = false;
  bool load = true;
  int rows = 1;
  List<File> files = [];
  double lat, lng;
  String newReq;
  @override
  void initState() {
    super.initState();
    getToken();
    findLatLng();
    getWork();
    load = false;
    for (var i = 0; i < rows; i++) {
      files.add(null);
    }
  }

  Future<void> getWork() async {
    try {
      SQLiteHelperOutage()
          .selectChecklist(int.parse(widget.mainID), int.parse(widget.subID))
          .then((result) {
        if (result != null || result.length > 0) {
          setState(() {
            checkListModels = result;
            load = false;
          });

          SQLiteHelperOutage()
              .selectWorkList(widget.reqNo, widget.subID)
              .then((results) {
            //print('********** # results : ${results.length} ');
            if (results.length > 0) {
              setState(() {
                listModels = results;
              });
            } else {
              //print('######### checkListModels : ${checkListModels.length} ');
              for (var item in checkListModels) {
                if (item.menuMainID == int.parse(widget.mainID) &&
                    item.menuSubID == int.parse(widget.subID)) {
                  // print("##########  list  : " + item.menuListID.toString());
                  SQLiteWorklistOutageModel sqlMpdel =
                      SQLiteWorklistOutageModel(
                    checklist: item.menuListID,
                    dateCreated: MyConstant.strDateNow,
                    doOrNot: 0,
                    imgList: null,
                    isComplete: 0,
                    isMainLine: 0,
                    latitude: null,
                    longtitude: null,
                    region: widget.userModel.rsg,
                    reqNo: widget.reqNo,
                    reseanNOT: "",
                    user: widget.userModel.userID,
                    workperform: "",
                    mainmenu: item.menuMainID.toString(),
                    remark: "",
                    submenU: widget.subID,
                    workstatus: widget.workStatus,
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

  Widget buildContent() {
    double size = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Container(
              width: size * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  widget.reqNo,
                  style: TextStyle(
                    fontSize: size * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ),
          Card(
            child: Container(
              width: size * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  checkListModels[0].menuMainName,
                  style: TextStyle(
                    fontSize: size * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ),
          Card(
            child: Container(
              width: size * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  checkListModels[0].menuSubName,
                  style: TextStyle(
                    fontSize: size * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            indent: 4.0,
            endIndent: 4.0,
          ),
          buildListlast(),
        ],
      ),
    );

    //buildListView(),
  }

  Widget buildListlast() {
    double size = MediaQuery.of(context).size.width;
    return new Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => GestureDetector(
            child: Card(
              color: Colors.grey[300],
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: size * 0.13,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(MyConstant.imgIconCheckList2,
                            color: widget.workStatus == 0
                                ? Colors.white.withOpacity(0.5)
                                : null,
                            colorBlendMode: widget.workStatus == 0
                                ? BlendMode.modulate
                                : null),
                      ),
                    ),
                    title: Text(
                      checkListModels[checkListModels.length - 1].menuListName,
                      style: TextStyle(
                        fontSize: size * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  buildPicture(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPicture() {
    double size = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: rows, //files.length,
          itemBuilder: (context, index) => Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child: files[index] == null
                          ? ShowIconImage(
                              fromMenu: "image",
                            )
                          : Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(files[index]),
                              ),
                            ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () =>
                              createImage(index, ImageSource.camera),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_photo_alternate),
                          onPressed: () =>
                              createImage(index, ImageSource.gallery),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  indent: size * 0.1,
                  endIndent: size * 0.1,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size * 0.1,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              rows = rows + 1;
                              files.add(null);
                            });
                          },
                          child: Text("+"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size * 0.1,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (rows != 1) {
                                rows = rows - 1;
                              }
                            });
                          },
                          child: Container(
                              child: Text(
                            "-",
                            style: TextStyle(fontSize: 22),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;
    return new Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 25.0),
        width: size * 0.9,
        child: ListView.builder(
          itemCount: listModels.length - 1,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              //HotlineWorkRec
            },
            child: Card(
              color: listModels[index].workstatus == 4
                  ? Colors.green[200]
                  : Colors.grey[300],
              child: ListTile(
                leading: Container(
                  width: size * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(""), //showIconList(index, 0),
                  ),
                ),
                title: Text(
                  listModels[index].mainmenu +
                      "  : " +
                      listModels[index].submenU +
                      "  : " +
                      listModels[index].workstatus.toString(),
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

  Future<Null> createImage(int index, ImageSource source) async {
    try {
      print('createImage    : $source');
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 600,
        maxHeight: 800,
      );

      // setState(() {
      //   files[index] = File(object.path);
      // });

      _cropImage(object.path, index);
    } catch (e) {}
  }

  void _cropImage(filepath, int index) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filepath, maxWidth: 600, maxHeight: 800);
    if (null != croppedImage) {
      setState(() {
        files[index] = croppedImage;
      });
    }
  }

  Widget buildSaveBtn() {
    //test
    //isConnected = true;
    return Container(
      height: 40,
      child: ElevatedButton(
        child: ShowTitle(
          title: "ยืนยัน",
          index: 3,
        ),
        onPressed: () async {
          listModels.isEmpty
              ? print("")
              : files.length > 0
                  ? files[0] != null
                      ? isConnected
                          ? widget.reqNo.length < 5
                              ? onlineInsert(widget.reqNo)
                              : sendToServer(widget.reqNo)
                          : updateStatusOffline()
                      : normalDialog(
                          context,
                          '',
                          'กรุถ่ายภาพอย่างน้อย 1 ภาพ',
                        )
                  : print("can't insert");
          // ? files[0] == null
          //     ? normalDialog(
          //         context,
          //         '',
          //         'กรุถ่ายภาพอย่างน้อย 1 ภาพ',
          //       )
          //     : isConnected
          //         ? widget.reqNo.length < 5
          //             ? onlineInsert(widget.reqNo)
          //             : sendToServer(widget.reqNo)
          //         : print("can't insert")
          // : SQLiteHelperOutage().updateWorkListStatus(6, widget.reqNo);
        },
        style: ElevatedButton.styleFrom(
          primary: listModels.isEmpty
              ? Colors.grey[300]
              : files.length > 0
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
          builder: (context) => HotlineCheckList(
            userModel: widget.userModel,
          ),
        ),
      );
    });
  }

  Future<Null> onlineInsert(String reqNo) async {
    //test
    final bool isConn = await InternetConnectionChecker().hasConnection;

    if (isConn) {
      InsertWorklistOutageModel insertWorklistModel;
      //List<SQLiteWorklistOutageModel> listModels = [];
      String _strJson;
      List<String> listValues = [];

      int i = 0;
      SQLiteHotline().selectWorkList(reqNo).then((result) async {
        if (result != null || result.length > 0) {
          print(
              'onlineInsert()    Req No :  $reqNo  ---> size : ${result.length}');
          for (var item in result) {
            i++;

            // print(
            //     'onlineInsert()    image :  ${listModels[i].imgList}');

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
                image: files[0] == null ? [""] : generateImage(item.imgList),
                // image: [""],
                isOffElect: "",
                offElectReason: "",
                isSortGND: "",
                gNDReason: "",
                locationLat: lat.toString(),
                locationLng: lng.toString(),
                macAddress: "",
                menuChecklistID:
                    checkListModels == null ? "" : item.checklist.toString(),
                menuMainID: widget.mainID,
                menuSubID: widget.subID,
                ownerID: "H",
                parcel: "",
                province: "",
                regionCode:
                    widget.userModel.rsg == null ? "" : widget.userModel.rsg,
                remark: "off|",
                sender: widget.userModel.userID == null
                    ? ""
                    : widget.userModel.userID,
                station: "",
                tokenNoti: "",
                waitApprove: "",
                workArea: "",
                workPerform: "",
                workStatus: "4",
                workType: "",
                reqNo: widget.reqNo,
                doOrNot: "",
                isMainLine: "",
                reasonNot: "");

            _strJson = json.encode(insertWorklistModel);
            listValues.add(_strJson);
          } //for
        } //if
        //

        print(
            '######  onlineInsert >  listValues.length : ${listValues.length}');

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

        SQLiteHelperOutage()
            .updateWorkListReq(reqNo, responeModel.result.reply.toString(), 1);

        //setState(() {
        //if (responeModel.isSuccess) {
        setState(() {
          newReq = responeModel.result.reply.toString();
          sendToServer(newReq);
          //setLine(newReq);
        });
      });
    } else {
      print('Offline insert...');
      SQLiteHelperOutage().updateWorkListStatus(6, reqNo);
      offilineAlert(context, "OffLine", "ขณะนี้ทำงานแบบ offline",
          widget.userModel, reqNo, 6);
    }
  }

  List<String> generateImage(String strImg) {
    //strImg equal emtry because list for close
    print('####--- > generateImage()  strImg : $strImg ');
    List<String> base64Strs = [];
    if (strImg != "") {
      List arr = new List();
      arr = strImg.split(',');
      base64Strs = arr;
      // List<String> arr = new List();
      // if (files[0] != null) {
      //   for (int i = 0; i < files.length; i++) {
      //     strImg = files[i].toString();
      //     arr.add(strImg);
      //   }
      //   base64Strs = arr;
      // }
    } else {
      //List<String> base64Strs = [];
      for (var item in files) {
        if (item != null) {
          List<int> imageBytes = Io.File(item.path).readAsBytesSync();
          String base64Str = base64Encode(imageBytes);
          base64Strs.add(base64Str);
        }
      }
    }

    return base64Strs;
  }

  Future<Null> findLatLng() async {
    Position position = await Geolocator.getLastKnownPosition();

    setState(() {
      lat = position == null ? 0 : position.latitude;
      lng = position == null ? 0 : position.longitude;
    });
  }

  Future<Null> sendToServer(String reqNo) async {
    try {
      //List<SQLiteWorklistOutageModel> listModels = [];
      String _strJson;
      List<String> listValues = [];
      OutageCloseWork closeListModel;
      print('close : sendToServer() :  ${widget.mainID} , ${widget.subID} ');

      //test
      //isConnected = false;

      // isConnected = true;
      if (isConnected) {
        closeListModel = OutageCloseWork(
          deptName: widget.userModel.deptName == null
              ? ""
              : widget.userModel.deptName,
          dateTimeWorkFinish: "",
          empLeaderID: widget.userModel.leaderId == null
              ? ""
              : widget.userModel.leaderId,
          employeeID:
              widget.userModel.userID == null ? "" : widget.userModel.userID,
          image: files == null ? [""] : generateImage(""),
          isOffElect: "",
          offElectReason: "",
          isSortGND: "",
          gNDReason: "",
          locationLat: lat.toString(),
          locationLng: lng.toString(),
          menuChecklistID:
              checkListModels[checkListModels.length - 1].menuListID == null
                  ? ""
                  : checkListModels[checkListModels.length - 1]
                      .menuListID
                      .toString(),
          menuMainID: widget.mainID == null ? "" : widget.mainID.toString(),
          menuSubID: widget.subID,
          ownerID: widget.userModel.ownerID,
          parcel: "",
          regionCode: widget.userModel.rsg == null ? "" : widget.userModel.rsg,
          remark: "",
          sender:
              widget.userModel.userID == null ? "" : widget.userModel.userID,
          waitApprove: "",
          workPerform: "",
          workStatus: "5",
          reqNo: reqNo,
        );

        _strJson = json.encode(closeListModel);
        listValues.add(_strJson);
        //for

        //print("value  : " + listValues.toString());

        final response = await http.post(
          Uri.parse(
              '${MyConstant.webService}WeSafe_Insert_TransactionWork_CloseO'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: utf8.encode(listValues.toString()),
        );

        print("respond  : " + response.body);
        ResponeModel responeModel =
            ResponeModel.fromJson(jsonDecode(response.body));

        print("Close success  reply = ${responeModel.result.reply.toString()}");

        //if (responeModel.result.reply.toString().contains("Insert")) {
        SQLiteHotline().updateWorkListStatusClose(5, reqNo, 1);

        SQLiteHelperOutage().deleteWorklistByReqNo(reqNo);

        setLine(reqNo);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotlineMainMenu(
              userModel: widget.userModel,
              //  userModel: userModel,
              // ownerId: userModel.ownerID,
            ),
          ),
        );
        // }

      } else {
        print('sendToServer()  Offline insert...');
        SQLiteHelperOutage().updateWorkListStatus(6, reqNo);

        offilineAlert(context, "OffLine", "ขณะนี้ทำงานแบบ offline",
            widget.userModel, reqNo, 6);
      }
    } catch (E) {
      normalDialog(context, "Error", E.toString());
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

  // sentLine

  Future<Null> setLine(String reqNo) async {
    findLatLng();

    //test
    // List<String> lineToken = [];
    // lineToken.add("gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz");
    if (widget.userModel.userID.contains('506429')) {
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
          checkListModels[0].menuMainName +
          " : " +
          checkListModels[0].menuSubName +
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
    //print("#--------> get line token");
    final bool isConnect = await InternetConnectionChecker().hasConnection;
    MastMainMenuModel _mainMenuModel;
    try {
      if (isConnect) {
        print("#--------> get line token   : " +
            isConnect.toString() +
            "    rsg : " +
            widget.userModel.rsg);
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
