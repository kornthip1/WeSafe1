import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class OutageWorkRecord extends StatefulWidget {
  final String workType;
  final String workName;
  final SQLiteUserModel userModel;
  OutageWorkRecord({@required this.workType, this.workName, this.userModel});

  @override
  _OutageWorkRecordState createState() => _OutageWorkRecordState();
}

class _OutageWorkRecordState extends State<OutageWorkRecord> {
  SQLiteUserModel userModel;
  List<File> files = [];
  int rows = 1;
  String choose;

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
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: ShowTitle(title: "บันทึกการปฏิบัติงาน", index: 3),
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
                      ? buildRadio()
                      : Text(""),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 40,
          child: ElevatedButton(
            child: ShowTitle(title: "ยืนยัน"),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget buildRadio() {
    return Card(
      child: Container(
        child: RadioListTile(
          value: '1',
          groupValue: choose,
          onChanged: (value) {
            setState(() {
              choose = value;
            });
          },
          title: Text(widget.workName),
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
                      child: Text(widget.workType + "  : " + widget.workName)),
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

                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Container(
                //         width: size * 0.1,
                //         child: ElevatedButton(
                //           onPressed: () {
                //             setState(() {
                //               rows = rows + 1;
                //               files.add(null);
                //             });
                //           },
                //           child: Text("+"),
                //         ),
                //       ),
                //     ),

                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Container(
                //         width: size * 0.1,
                //         child: ElevatedButton(
                //           onPressed: () {
                //             setState(() {
                //               if (rows != 1) {
                //                 rows = rows - 1;
                //               }
                //             });
                //           },
                //           child: Text("-"),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
                // Divider(
                //   thickness: 1,
                // ),
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
