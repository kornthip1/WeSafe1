import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wesafe/models/user_Model.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/utility/my_constain.dart';
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
    // TODO: implement initState
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
                  groupValue: "",
                  onChanged: (value) {},
                  title: Text('GND'),
                ),
                 RadioListTile(
                  value: '1',
                  groupValue: "",
                  onChanged: (value) {
                  Authen();
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
              onPressed: () {},
              child: Container(child: Text('บันทึก')),
            ),
          ),
        ],
      ),
    );
  }
}
