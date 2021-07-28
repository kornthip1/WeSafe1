import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/checkStatusModel.dart';
import 'package:wesafe/models/mastWorkListModel_test.dart';
import 'package:wesafe/models/sqlitePercelModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/states/closelist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

import 'mainlist.dart';

class WorkRecord extends StatefulWidget {
  final int index;
  final int indexWork;
  final String workListname;
  final SQLiteUserModel sqLiteUserModel;
  final SQLiteWorklistModel sqLiteWorklistModel;
  final int countList;
  WorkRecord(
      {@required this.index,
      this.indexWork,
      this.workListname,
      this.sqLiteUserModel,
      this.sqLiteWorklistModel,
      this.countList});

  @override
  _WorkRecordState createState() => _WorkRecordState();
}

class _WorkRecordState extends State<WorkRecord> {
  int _index;
  int indexWork;
  double size;
  double sizeH;
  String choose;
  //image
  List<File> files = [];
  int amountPic;
  String workListname = "";
  SQLiteUserModel userModel;
  TextEditingController dataController = TextEditingController();
  TextEditingController dataEffController = TextEditingController();

  TextEditingController percelController = TextEditingController();
  TextEditingController amounrController = TextEditingController();
  SQLiteWorklistModel _sqLiteWorklistModel;

  int rows = 1;

  List<String> listPercel = [];
  List<String> listAmount = [];
  @override
  void initState() {
    super.initState();
    indexWork = widget.indexWork;

    for (var i = 0; i < rows; i++) {
      files.add(null);
      listPercel.add(null);
      listAmount.add(null);
    }

    amountPic = files.length;
    workListname = widget.workListname;
    userModel = widget.sqLiteUserModel;
    _sqLiteWorklistModel = widget.sqLiteWorklistModel;
    _index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(workListname),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          indexWork == 0
              ? buildCheckList()
              : indexWork == 1
                  ? buildTextBox()
                  : indexWork == 2
                      ? buildPicture()
                      : workListname.contains("ลักษณะงาน")
                          ? buildRadioWorkType()
                          : _index == 7
                              ? buildCloseWork()
                              : buildRadio(),
          buildSave(),
        ],
      ),
    );
  }

//ElevatedButton(onPressed: (){}, child: Text("บันทึก"))
  Widget buildRadioWorkType() {
    double size = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    RadioListTile(
                      value: '1',
                      groupValue: choose,
                      onChanged: (value) {
                        setState(() {
                          choose = value;
                        });
                      },
                      title: Text('ดับไฟทั้งสถานี'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RadioListTile(
                      value: '2',
                      groupValue: choose,
                      onChanged: (value) {
                        setState(() {
                          choose = value;
                        });
                      },
                      title: Text('ดับไฟ้าบางส่วน ระบุจุดดับไฟ'),
                    ),
                    Container(
                      width: size * 0.6,
                      child: TextFormField(
                        controller: dataController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill information';
                          } else {
                            return null;
                          }
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.text_format),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RadioListTile(
                      value: '0',
                      groupValue: choose,
                      onChanged: (value) {
                        setState(() {
                          choose = value;
                        });
                      },
                      title: Text('ไม่มีการดับไฟสถานีไฟฟ้า'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadio() {
    double size = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    RadioListTile(
                      value: '1',
                      groupValue: choose,
                      onChanged: (value) {
                        setState(() {
                          choose = value;
                        });
                      },
                      title: Text(workListname),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: rows, //files.length,
                      itemBuilder: (context, index) => Column(
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
                                    : Image.file(files[index]),
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
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      rows = rows + 1;
                                      files.add(null);
                                    });
                                  },
                                  child: Text("เพิ่มรูปถ่าย"))
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RadioListTile(
                      value: '0',
                      groupValue: choose,
                      onChanged: (value) {
                        setState(() {
                          choose = value;
                        });
                      },
                      title: Text('ไม่ $workListname'),
                    ),
                    Container(
                      width: size * 0.6,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.notes),
                          labelText: 'เหตุผลที่ไม่ $workListname ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCloseWork() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ShowTitle(
            //   title: "Take Pic",
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShowTitle(
                title: '1. ภาพอะไหล่อุปกรณ์ที่ใช้ไป',
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: 1,
              itemBuilder: (context, index) => Column(
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
                            : Image.file(files[0]),
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
                    thickness: 1,
                  ),
                ],
              ),
            ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShowTitle(
                title: '2. อะไหล่อุปกรณ์และจำนวนที่ใช้ไป',
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: rows,
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(child: Text('${index + 1}')),
                      buildPercel(index),
                      buildAmountPercel(index),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            //listPercel[index] = percelController.text;
                            rows = rows + 1;
                            listPercel.add(null);
                            listAmount.add(null);

                            // listPercel.add(percelController.text);
                            // listAmount.add(amounrController.text);
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text(""),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),

            // buildUpload(),
          ],
        ),
      ),
    );
  }

  Container buildPercel(int index) {
    //print("#### Percel lenght : ${listPercel.length}");
    // for (int x = 0; x < listPercel.length; x++) {
    //   print("#### Percel  : ${listPercel[x]}");
    // }
    //print("#### Percel index : ${listPercel[index]}");

    return Container(
      // margin: EdgeInsets.only(top: 5),
      width: size * 0.5,
      height: 50.0,
      child: TextFormField(
        controller: rows - 1 > index ? null : percelController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill ...';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: listPercel.length == 0
              ? "อุปกรณ์"
              : listPercel[index] == null
                  ? "อุปกรณ์"
                  : rows > index
                      ? "อุปกรณ์"
                      : listPercel[index],
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          listPercel[index] = value;
        },
      ),
    );
  }

  Container buildAmountPercel(int index) {
    return Container(
      // margin: EdgeInsets.only(top: 5),
      width: size * 0.3,
      height: 50.0,
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: rows - 1 > index ? null : amounrController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill ...';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: listAmount.length == 0
              ? "จำนวน"
              : listAmount[index] == null
                  ? "จำนวน"
                  : rows > index
                      ? "จำนวน"
                      : listAmount[index],
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          listAmount[index] = value;
        },
      ),
    );
  }

  Widget buildPicture() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 1,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: rows, //files.length,
              itemBuilder: (context, index) => Column(
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
                            : Image.file(files[index]),
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
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              rows = rows + 1;
                              files.add(null);
                            });
                          },
                          child: Text("เพิ่มรูปถ่าย"))
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> createImage(int index, ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        files[index] = File(object.path);
      });
    } catch (e) {}
  }

  Widget buildTextBox() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 18),
        width: size * 0.8,
        child: Column(
          children: [
            TextFormField(
              controller: dataController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please fill information';
                } else {
                  return null;
                }
              },
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.text_format),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckList() {
    return Center(
      child: Container(
        child: Column(
          children: [
            Text("data for check list"),
          ],
        ),
      ),
    );
  }

//buildTESTSQLite();

  Future<Null> readDataSQLite() async {
    List<MastWorkListModel> models = [];
    await SQLiteHelper().readDatabase().then((result) {
      if (result == null) {
        normalDialog(context, 'SQLite', 'no data');
      } else {
        models = result;
        for (var item in models) {
          normalDialog(
              context, 'SQLite', '${item.workID}  :    ${item.workPerform}');
        }
      }
    });
  }

  String base64Encode(List<int> bytes) => base64.encode(bytes);
  Column buildSave() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  SQLiteWorklistModel sqLiteWorklistModel;
                  List<String> base64Strs = [];

                  print("RECORD  >>> ");
                  print("Workperform  :  ${_sqLiteWorklistModel.workPerform}");
                  print("doc  :  ${_sqLiteWorklistModel.workDoc}");
                  print("_index  :  $_index");
                  bool canSave = false;
                  if (_index != 7) {
                    String remark = "1";
                    if (_index == 7 || _sqLiteWorklistModel.remark == "9") {
                      remark = "11";
                    }

                    for (var item in files) {
                      if (item != null) {
                        print("Base64  path : " + item.path);
                        List<int> imageBytes =
                            Io.File(item.path).readAsBytesSync();
                        String base64Str = base64Encode(imageBytes);

                        base64Strs.add(base64Str);
                        canSave = true;
                      }
                    }

                    //indexWork
                    if (indexWork == 2 && !canSave) {
                      normalDialog(context, "กรุณา", "ถ่ายภาพอย่างน้อย 1 ภาพ");
                      canSave = false;
                    } else if (indexWork == 3 && choose == null) {
                      normalDialog(context, "กรุณา",
                          "เลือกการปฏิบัติการ " + workListname);
                    } else {
                      canSave = true;
                    }

                    if (canSave) {
                      int i = Random().nextInt(100000);
                      sqLiteWorklistModel = SQLiteWorklistModel(
                          id: i,
                          checklistID: _index,
                          createDate: _sqLiteWorklistModel.createDate,
                          isChoice: 0,
                          userID: "",
                          lat: "",
                          lng: "",
                          workDoc: _sqLiteWorklistModel.workDoc,
                          workID: _sqLiteWorklistModel.workID,
                          workPerform: _sqLiteWorklistModel.workPerform,
                          workProvince: _sqLiteWorklistModel.workProvince,
                          workRegion: _sqLiteWorklistModel.workRegion,
                          workStation: _sqLiteWorklistModel.workStation,
                          workType: _sqLiteWorklistModel.workType,
                          remark: remark,
                          imgList: base64Strs
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          // imgList: base64Strs
                          //     .toString()
                          //     .replaceAll('[', "")
                          //     .replaceAll("]", ""),
                          isComplete: 1,
                          mainWorkID: "300",
                          msgFromWeb: "",
                          ownerID: _sqLiteWorklistModel.ownerID,
                          isOffElect: choose == null
                              ? ""
                              : _index == 3
                                  ? ""
                                  : choose,
                          offElectReason: dataController.text == null
                              ? ""
                              : _index == 3
                                  ? ""
                                  : dataController.text);

                      SQLiteHelper().insertWorkDatebase(sqLiteWorklistModel);

                      routeToMainList(sqLiteWorklistModel);
                    }
                  } else {
                    //if (canSave) {
                    print("###-------->  save to close");
                    print(
                        "###-------->  listPercel leght : ${listPercel.length}");
                    print(
                        "###-------->  listAmount leght : ${listAmount.length}");
                    print("###-------->  save to close");
                    String strPercel = "";
                    String strAmount = "";
                    String percel = "";
                    for (int i = 0; i < listPercel.length; i++) {
                      strPercel = listPercel[i];
                      strAmount = listAmount[i] == null ? "" : listAmount[i];
                      percel = percel + strPercel + ":" + strAmount + ",";
                    }

                    percel = "[" + percel + "]";
                    print("######## ---- > $percel");
                    // String percel = "[" +
                    //     "${percelController.text} : ${amounrController.text}" +
                    //     "]";
                    CheckStatusModel checkStatusModel;
                    SQLitePercelModel percelModel = SQLitePercelModel(

                        workID:  _sqLiteWorklistModel.reqNo.substring(9,_sqLiteWorklistModel.reqNo.length ),
                        amount: 0, checklistID: 7, item: percel);
                    SQLiteHelper().insertPercel(percelModel);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CloseList(
                          user_model: userModel,
                          reqNo: _sqLiteWorklistModel.reqNo,
                        ),
                      ),
                    );

                    //}
                  }
                },
                child: Text("บันทึก")),
          ],
        )
      ],
    );
  }

  Future<void> routeToMainList(SQLiteWorklistModel sqLiteWorklistModel) async {
    SQLiteUserModel sqLiteUserModel;
    List<SQLiteUserModel> models = [];
    await SQLiteHelper().readUserDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        for (var item in models) {
          sqLiteUserModel = SQLiteUserModel(
            userID: item.userID,
            firstName: item.firstName,
            lastName: item.lastName,
            deptName: item.deptName,
            ownerID: item.ownerID,
            ownerName: item.ownerName,
            pincode: item.pincode,
            rsg: item.rsg,
          );
        } //for
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainList(
          user_model: sqLiteUserModel,
          sqLiteWorklistModel: sqLiteWorklistModel,
          countList: widget.countList + 1,
        ),
      ),
    );
  }
}
