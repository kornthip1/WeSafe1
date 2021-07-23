import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/mastWorkListModel_test.dart';
import 'package:wesafe/models/sqlitePercelModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/states/closelist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';


class CloseRecord extends StatefulWidget {
  final int index;
  final int indexWork;
  final String workListname;
  final SQLiteUserModel sqLiteUserModel;
  final SQLiteWorklistModel sqLiteWorklistModel;
  final int countList;
  CloseRecord(
      {@required this.index,
      this.indexWork,
      this.workListname,
      this.sqLiteUserModel,
      this.sqLiteWorklistModel,
      this.countList});

  @override
  _CloseRecordState createState() => _CloseRecordState();
}

class _CloseRecordState extends State<CloseRecord> {
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
    }

    amountPic = files.length;
    workListname = widget.workListname;
    userModel = widget.sqLiteUserModel;
    _sqLiteWorklistModel = widget.sqLiteWorklistModel;
    _index = widget.index;

    rows = 1;
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
          buildCloseWork(),
          buildSave(),
        ],
      ),
    );
  }

//ElevatedButton(onPressed: (){}, child: Text("บันทึก"))
 

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
                      buildAmountPercel(),
                      ElevatedButton.icon(
                        onPressed: () {
                          listPercel.add(percelController.text);
                          listAmount.add(amounrController.text);

                          setState(() {
                            rows = rows + 1;
                            percelController.clear();
                            amounrController.clear();
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
    return Container(
      // margin: EdgeInsets.only(top: 5),
      width: size * 0.5,
      height: 50.0,
      child: TextFormField(
        controller: percelController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill ...';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'อุปกรณ์ :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildAmountPercel() {
    return Container(
      // margin: EdgeInsets.only(top: 5),
      width: size * 0.3,
      height: 50.0,
      child: TextFormField(
        controller: amounrController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill ...';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'จำนวน :',
          border: OutlineInputBorder(),
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
                  
                  if (_index != 7) {
                    print("RECORD  >>> ");
                    print(
                        "Workperform  :  ${_sqLiteWorklistModel.workPerform}");
                    print("doc  :  ${_sqLiteWorklistModel.workDoc}");
                 
                
                    //close
                    sqLiteWorklistModel = SQLiteWorklistModel(
                      workPerform: _sqLiteWorklistModel.workPerform,
                      workDoc: _sqLiteWorklistModel.workDoc,
                      reqNo: _sqLiteWorklistModel.reqNo,
                    );
                    if (listPercel.length == 0) {
                      if (percelController != null) {
                        listPercel.add(percelController.text);
                        listAmount.add(amounrController.text);
                      }
                    }
                    print("##### listpercel size  :  ${listPercel.length}");
                    print("##### listamount size  :  ${listAmount.length}");
                    SQLitePercelModel sqLitePercelModel;

                    for (int i = 0; i < listPercel.length; i++) {
                      print('#####---> ${listPercel[i]}  :  ${listAmount[i]}');
                      sqLitePercelModel = SQLitePercelModel(
                        reqNo: _sqLiteWorklistModel.reqNo,
                        checklistID: 7,
                        isComplete: 1,
                        mainWorkID: "300",
                        amount: int.parse(listAmount[i].toString()),
                        item: listPercel[i],
                        subWorkID: 2,
                      );
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CloseList(
                          user_model: userModel,
                          sqLitePercelModel: sqLitePercelModel,
                        ),
                      ),
                    );
                  }
                },
                child: Text("บันทึก")),
          ],
        )
      ],
    );
  }

  
}
