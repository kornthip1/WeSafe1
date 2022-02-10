import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/outageWorklist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class OutageWorkRecord extends StatefulWidget {
  final String workType;
  final String workName;
  final SQLiteUserModel userModel;
  final String mainID;
  final String mainName;
  OutageWorkRecord(
      {@required this.workType,
      this.workName,
      this.userModel,
      this.mainID,
      this.mainName});

  @override
  _OutageWorkRecordState createState() => _OutageWorkRecordState();
}

class _OutageWorkRecordState extends State<OutageWorkRecord> {
  TextEditingController workController = TextEditingController();
  SQLiteUserModel userModel;
  List<File> files = [];
  int rows = 1;
  String choose = "0";

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    for (var i = 0; i < rows; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: ShowTitle(title: "บันทึกการปฏิบัติงาน", index: 1),
        ),
        drawer: ShowDrawer(userModel: userModel),
        body: Center(
          child: Column(
            children: [
              buildHeader(size),
              Divider(
                color: Colors.grey,
                indent: 4.0,
                endIndent: 4.0,
              ),
              widget.workType == "2"
                  ? buildPicture()
                  : widget.workType == "4"
                      ? expandPanel(widget.workName,
                          "0") //buildRadio(widget.workName,'1')
                      : Text(""),
              widget.workType == "4"
                  ? expandPanel("ไม่" + widget.workName,
                      "1") //buildRadio("ไม่"+ widget.workName,'0')
                  : Text(""),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 40,
          child: ElevatedButton(
            child: ShowTitle(title: "ยืนยัน"),
            onPressed: () {
              print("choose : " + choose);
              bool canSave = false;
              if (choose == "0") {
                //ต้องถ่ายภาพ
                print("files : " + files[0].toString());
                if (null == files[0]) {
                  normalDialog(context, "เตือน", "กรุณาถ่ายภาพอย่างน้อย 1 ภาพ");
                } else {
                  canSave = true;
                }
              } else if (choose == "1") {
                //ไม่ปฏิบัติ ต้องระบุเหตุผล
                print("value Text : " + workController.text);
                if (workController.text.trim()=="") {
                  normalDialog(context, "เตือน", "กรุณาระบุเหตุผล");
                } else {
                  canSave = true;
                }
              }

              if (canSave) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OutageWorkList(
                            userModel: userModel,
                            mainName: widget.mainName,
                            mainID: widget.mainID,
                          )),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget expandPanel(String word, String value) {
    return Card(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              ExpansionTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Radio(
                        value: value,
                        groupValue: choose,
                        onChanged: (value) {
                          print("Radio values  : " + value);
                          setState(() {
                            choose = value;
                          });
                        },
                      ),
                    ),
                    Text(
                      word,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                children: <Widget>[
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: value == "0"
                          ? buildPicture()
                          : TextFormField(
                              controller: workController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'กรุณาระบุเหตุผล';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue[800], width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue[800], width: 2.0),
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

  Widget buildRadio(String word, String values) {
    return Card(
      child: Container(
        child: RadioListTile(
          value: values,
          groupValue: choose,
          onChanged: (value) {
            setState(() {
              choose = value;
            });
          },
          title: Text(word),
        ),
      ),
    );
  }

  Widget buildHeader(double size) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          children: [
            Container(
              width: size,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    widget.workType + "  : " + widget.workName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } //

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
} //class
