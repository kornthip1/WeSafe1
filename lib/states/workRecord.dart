import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/MastWorkListModel_test.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class WorkRecord extends StatefulWidget {
  final int indexWork;
  WorkRecord({@required this.indexWork});

  @override
  _WorkRecordState createState() => _WorkRecordState();
}

class _WorkRecordState extends State<WorkRecord> {
  int indexWork;
  double size;
  double sizeH;
  String choose;
  //image
  List<File> files = [];
  int amountPic;

  TextEditingController dataController = TextEditingController();
  @override
  void initState() {
    super.initState();
    indexWork = widget.indexWork;

    for (var i = 0; i < 3; i++) {
      files.add(null);
    }

    amountPic = files.length;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('WORK  $indexWork'),
        ),
        body: Stack(
          children: [
            indexWork == 0
                ? buildCheckList()
                : indexWork == 1
                    ? buildTextBox()
                    : indexWork == 2
                        ? buildPicture()
                        : buildRadio(),
            buildSave(),
            ElevatedButton(
              onPressed: () {
                buildTESTReadSQLite();
              },
              child: Text('Read DATA'),
            )
          ],
        ));
  }

  Widget buildRadio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            child: Column(
              children: [
                RadioListTile(
                  value: '0',
                  groupValue: choose,
                  onChanged: (value) {
                    setState(() {
                      choose = value;
                    });
                  },
                  title: Text('GND'),
                ),
                RadioListTile(
                  value: '1',
                  groupValue: choose,
                  onChanged: (value) {
                    setState(() {
                      choose = value;
                    });
                  },
                  title: Text('ไม่ GND'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPicture() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowTitle(
              title: "Take Pic",
            ),
            ShowTitle(
              title: 'จำนวนรูป : $amountPic  รูป',
            ),
            Divider(
              thickness: 1,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: files.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${index + 1}'),
                      Container(
                        width: 120,
                        height: 120,
                        child: files[index] == null
                            ? ShowIconImage()
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

  Positioned buildSave() {
    return Positioned(
      child: buildSaveChecklist(),
      bottom: 50.8,
      left: size * 0.4,
    );
  }

  Widget buildSaveChecklist() {
    return Center(
      child: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () {
                //normalDialog(context, 'radio value : ', choose);
                buildTESTSQLite();
              },
              child: Container(child: Text('บันทึก')),
            ),
          ),
        ],
      ),
    );
  }

  Column buildTESTSQLite() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            SQLiteHelper().deleteSQLiteAll();
            MastWorkListModel mastWorkListModel = MastWorkListModel(
              workID: 1,
              userID: 'aaaa',
              rsg: 'I03155',
              ownerID: '12345',
              mainWorkID: '12345',
              subWorkID: 6,
              checklistID: 3,
              lat: '12345',
              lng: '12345',
              workPerform: 'TEST121212',
              remark: '12345',
              isChoice: 0,
              reason: '12345',
              msgFromWeb: '12345',
              createDate: '12345',
              uploadDate: '12345',
            );

            SQLiteHelper().insertDatebase(mastWorkListModel).then(
                  (value) => normalDialog(context, 'SQLite', 'Success'),
                );
          },
          child: Text('บันทึกข้อมูล'),
        ),
      ],
    );
  }

  Column buildTESTReadSQLite() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            readDataSQLite();
          },
          child: Text('อ่านข้อมูล'),
        ),
      ],
    );
  }

  Future<Null> readDataSQLite() async {
    List<MastWorkListModel> models = [];
    print('####### readDataSQLite() ');
    await SQLiteHelper().readDatabase().then((result) {
      if (result == null) {
        normalDialog(context, 'SQLite', 'no data');
      } else {
        print('####### readData  result: $result');
        models = result;
        for (var item in models) {
          normalDialog(
              context, 'SQLite', '${item.workID}  :    ${item.workPerform}');
        }
      }
    });
  }
}
