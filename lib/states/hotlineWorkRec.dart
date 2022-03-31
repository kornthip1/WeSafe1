import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/outageWorklist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class HotlineWorkRec extends StatefulWidget {
  final String workType;
  final String workName;
  final SQLiteUserModel userModel;
  final String mainID;
  final String mainName;
  final int workID;
  final int workList;
  final int listStatus;
  final String isMainLine;
  HotlineWorkRec(
      {@required this.workType,
      this.workName,
      this.userModel,
      this.mainID,
      this.mainName,
      this.workID,
      this.workList,
      this.listStatus,
      this.isMainLine});

  @override
  _HotlineWorkRecState createState() => _HotlineWorkRecState();
}

class _HotlineWorkRecState extends State<HotlineWorkRec> {
  TextEditingController workController = TextEditingController();
  TextEditingController TextOtetController = TextEditingController();
  SQLiteUserModel userModel;
  List<File> files = [];
  int rows = 1;
  String choose = "1";
  int workID;
  List<SQLiteWorklistOutageModel> workingModels = [];

  @override
  void initState() {
    super.initState();
    workID = widget.workID;
    readWorkList();
    userModel = widget.userModel;
    for (var i = 0; i < rows; i++) {
      files.add(null);
    }
  }

  Future<Null> readWorkList() async {
    SQLiteHelperOutage().selectWorkList(workID.toString(), "1").then((result) {
      if (result == null) {
        print("Error : " + result.toString());
      } else {
        setState(() {
          workingModels = result;
        });
      }
    });
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
                          "1") //buildRadio(widget.workName,'1')
                      : Text(""),
              widget.workType == "4"
                  ? expandPanel("ไม่" + widget.workName,
                      "0") //buildRadio("ไม่"+ widget.workName,'0')
                  : widget.workType == "3"
                      ? buildOtherText()
                      : Text(""),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 40,
          child: ElevatedButton(
            child: ShowTitle(title: "ยืนยัน"),
            onPressed: () async {
              try {
                print("choose : " + choose);
                bool canSave = false;
                if (widget.mainID == "999") {
                  if (widget.workType == "2") {
                    if (null == files[0]) {
                      normalDialog(
                          context, "เตือน", "กรุณาถ่ายภาพอย่างน้อย 1 ภาพ");
                    } else {
                      canSave = true;
                    }
                  } else {
                    if (TextOtetController.text.trim() == "") {
                      normalDialog(context, "เตือน", "กรุณาระบุรายละเอียด");
                    } else {
                      canSave = true;
                    }
                  }
                } else {
                  if (choose == "1") {
                    //ต้องถ่ายภาพ
                    print("files : " + files[0].toString());
                    if (null == files[0]) {
                      normalDialog(
                          context, "เตือน", "กรุณาถ่ายภาพอย่างน้อย 1 ภาพ");
                    } else {
                      canSave = true;
                    }
                  } else if (choose == "0") {
                    //ไม่ปฏิบัติ ต้องระบุเหตุผล
                    print("value Text : " + workController.text);
                    if (workController.text.trim() == "") {
                      normalDialog(context, "เตือน", "กรุณาระบุเหตุผล");
                    } else {
                      canSave = true;
                    }
                  }
                }

                if (canSave) {
                  List<String> base64Strs = [];
                  for (var item in files) {
                    if (item != null) {
                      List<int> imageBytes =
                          Io.File(item.path).readAsBytesSync();
                      String base64Str = base64Encode(imageBytes);
                      base64Strs.add(base64Str);
                    }
                  }
                  // print('base64Strs lenght : ' + base64Strs.length.toString());

                  // SQLiteHelperOutage.updateWorkList(
                  //     1, workID.toString(), widget.workList);
                  print('before save  $workID , ${widget.workList}');
                  SQLiteHelperOutage().updateWorkList(
                    2,
                    workID.toString(),
                    "1",
                    widget.workList,
                    base64Strs
                        .toString()
                        .replaceAll("[", "")
                        .replaceAll("]", ""),
                    int.parse(choose),
                    workController.text,
                    widget.mainID == "999" ? TextOtetController.text : "",
                    int.parse(widget.isMainLine),
                  );
                  if (widget.listStatus != 2) {
                    SQLiteHelperOutage().updateWorkList(
                        1,
                        workID.toString(),
                        "1",
                        widget.workList + 1,
                        base64Strs
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        int.parse(choose),
                        workController.text,
                        widget.mainID == "999" ? TextOtetController.text : "",
                        int.parse(widget.isMainLine));
                  }

                  //***** Get Image************ */

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OutageWorkList(
                              userModel: userModel,
                              mainName: widget.mainName,
                              mainID: widget.mainID,
                              workId: workID,
                              isMainLine: widget.isMainLine,
                              workPerform: widget.mainID == "999"
                                  ? TextOtetController.text
                                  : "",
                            )),
                  );
                }
              } catch (e) {
                await http.post(
                  Uri.parse('${MyConstant.newService}log/create_error'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body:
                      '[{"Req_no": "${workingModels[0].reqNo}",   "Error": "${e.toString()}" , "CodeFrom":"mobile " , "DateTimeError":"${MyConstant.strDateNow}" }]',
                );

                //+++++++++++ alert Line++++++++++++++++++++++++++++++++
                final client = HttpClient();
                final request = await client.postUrl(
                    Uri.parse("${MyConstant.webService}WeSafe_SendToken"));
                String msg =
                    'workrecord  ## ReqNO = ${workingModels[0].reqNo}   send to server error  : ${e.toString()}';
                request.headers.contentType =
                    new ContentType("application", "json", charset: "utf-8");
                request.write(
                    '{"strMsg": "$msg",   "strToken": "gaEbl4Srq7bn0Z0IFJpcIOft30u3Z5kLVNw1I2JrYhz"}');
                await request.close();
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildOtherText() {
    return TextFormField(
      maxLines: 5,
      controller: TextOtetController,
      validator: (value) {
        if (value.isEmpty) {
          return 'กรุณาระบุรายละเอียด';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800], width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800], width: 2.0),
        ),
        prefixIcon: Icon(
          Icons.description,
          color: Colors.blue[700],
        ),
        labelText: 'รายละเอียด',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget expandPanel(String word, String values) {
    return Card(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              ExpansionTile(
                onExpansionChanged: (value) {
                  setState(() {
                    if (values.contains("0")) {
                      choose = "0";
                    } else {
                      choose = "1";
                    }
                  });
                },
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Radio(
                        value: values,
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
                      child: values == "1"
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
                      widget.workList.toString() + "  : " + widget.workName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
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

      // setState(() {
      //   files[index] = File(object.path);
      // });

      _cropImage(object.path, index);
    } catch (e) {}
  }

  void _cropImage(filepath, int index) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filepath, maxWidth: 800, maxHeight: 800);
    if (null != croppedImage) {
      setState(() {
        files[index] = croppedImage;
      });
    }
  }
} //class
