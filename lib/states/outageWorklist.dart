import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wesafe/models/mastcheckListModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/outageWorkRec.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';

class OutageWorkList extends StatefulWidget {
  final SQLiteUserModel userModel;
  final String mainID;
  final String mainName;
  OutageWorkList({@required this.userModel, this.mainID, this.mainName});

  @override
  _OutageWorkListState createState() => _OutageWorkListState();
}

class _OutageWorkListState extends State<OutageWorkList> {
  SQLiteUserModel userModel;
  TextEditingController workController = TextEditingController();
  MastCheckListModel checklistmodel;
  String choose;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readWorkList();
  }

  Future<Null> readWorkList() async {
    final response = await http.post(
      Uri.parse('${MyConstant.webService}WeSafeSelectWorkList'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: '{"mainMenu": "${widget.mainID}",   "subMenu": "1"}',
    );
    setState(() {
      checklistmodel = MastCheckListModel.fromJson(jsonDecode(response.body));
    });

    print("### getCheckList  = ${checklistmodel.result.length}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: ShowTitle(title: widget.mainName, index: 3),
          ),
          drawer: ShowDrawer(userModel: userModel),
          body: Center(
            child: Column(
              children: [
                buildRadioMainLine(),
                buildWorkPerform(),
                Divider(
                  color: Colors.grey,
                  indent: 4.0,
                  endIndent: 4.0,
                ),
                buildListView()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 40,
            child: ElevatedButton(
              child: ShowTitle(
                title: "ยืนยัน",
                index: 3,
              ),
              onPressed: () {},
            ),
          )),
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;
    // print("size of model : " + checklistmodel.result.length.toString());
    return new Expanded(
      child: Container(
        width: size * 0.9,
        child: ListView.builder(
          itemCount: checklistmodel.result.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              //normalDialog(context, "title", "message");
              if (checklistmodel.result[index].type.contains("1")) {
                print("insert db and update work status");
              } else {
                if (checklistmodel.result[index].waitApprove == '66') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OutageWorkRecord(
                        userModel: userModel,
                        workType: checklistmodel.result[index].type,
                        workName:
                            checklistmodel.result[index].menuChecklistName,
                      ),
                    ),
                  );
                }
              }
            },
            child: Card(
              color: Colors.grey[300],
              child: ListTile(
                leading: Container(
                  width: size * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showIconList(index,0),
                  ),
                ),
                title: Text(
                  checklistmodel.result[index].menuChecklistName ,
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
  } //build

  Image showIconList(int index, int status) {
    
    return checklistmodel.result[index].isChoice.contains("1")
        ? Image.asset(
            MyConstant.imgIconCheckList2,
            color: status == 0 ? Colors.white.withOpacity(0.5) : null,
            colorBlendMode: status == 0 ? BlendMode.modulate : null,
          )
        : checklistmodel.result[index].isChoice.contains("2")
            ? Image.asset(
                MyConstant.imgIconCheckList3,
                color: status == 0 ? Colors.white.withOpacity(0.5) : null,
                colorBlendMode: status == 0 ? BlendMode.modulate : null,
              )
            : checklistmodel.result[index].isChoice.contains("3")
                ? Image.asset(
                    MyConstant.imgIconCheckList4,
                    color: status == 0 ? Colors.white.withOpacity(0.5) : null,
                    colorBlendMode: status == 0 ? BlendMode.modulate : null,
                  )
                : checklistmodel.result[index].isChoice.contains("4")
                    ? Image.asset(
                        MyConstant.imgIconCheckList5,
                        color:
                            status == 0 ? Colors.white.withOpacity(0.5) : null,
                        colorBlendMode: status == 0 ? BlendMode.modulate : null,
                      )
                    : Image.asset(
                        MyConstant.imgIconCheckList1,
                        color:
                            status == 0 ? Colors.white.withOpacity(0.5) : null,
                        colorBlendMode: status == 0 ? BlendMode.modulate : null,
                      );
  }

  Widget buildWorkPerform() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: size * 0.9,
        child: TextFormField(
          controller: workController,
          validator: (value) {
            if (value.isEmpty) {
              return 'กรุณาระบุงานที่ปฏิบัติ';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[300], width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[500], width: 2.0),
            ),
            prefixIcon: Icon(
              Icons.description,
              color: Colors.green[600],
            ),
            labelText: 'งานที่ปฏิบัติ',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildRadioMainLine() {
    double size = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: size * 0.9,
        child: Row(
          children: [
            Expanded(
              child: RadioListTile(
                value: '0',
                groupValue: choose,
                onChanged: (value) {
                  setState(() {
                    choose = value;
                  });
                },
                title: Text('MAIN LINE'),
              ),
            ),
            Expanded(
              child: RadioListTile(
                value: '1',
                groupValue: choose,
                onChanged: (value) {
                  setState(() {
                    choose = value;
                  });
                },
                title: Text('DROP OUT'),
              ),
            )
          ],
        ),
      ),
    );
  }
}//class
