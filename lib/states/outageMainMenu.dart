import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistOutageModel.dart';
import 'package:wesafe/states/outageWorklist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteOutage.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class OutageMainMenu extends StatefulWidget {
  final SQLiteUserModel userModel;
  OutageMainMenu({@required this.userModel});
  @override
  _OutageMainMenuState createState() => _OutageMainMenuState();
}

class _OutageMainMenuState extends State<OutageMainMenu> {
  TextEditingController workController = TextEditingController();

  SQLiteUserModel userModel;
  MastMainMenuModel _mainMenuModel;
  String choose;
  List<SQLiteWorklistOutageModel> models = [];
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readWorkList();
  }

  Future<Null> readWorkList() async {
    try {
      final client = HttpClient();
      final request = await client.postUrl(
          Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu")); //CheckEmp
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write(
          '{"Owner_ID": "${userModel.ownerID}",   "REGION_CODE": "${userModel.rsg}"}');
      final response = await request.close();

      response.transform(utf8.decoder).listen((contents) {
        print("worklist content return  : " + contents);
        if (contents.contains('Error')) {
          contents = contents.replaceAll("[", "").replaceAll("]", "");
          normalDialog(context, 'Error', contents);
        } else {
          setState(() {
            print("set state 1");
            print("contents.length  : " + contents.length.toString());
            if (contents.length >= 10) {
              _mainMenuModel = MastMainMenuModel.fromJson(jsonDecode(contents));
              for (int i = 0; i < _mainMenuModel.result.length; i++) {
                SQLiteWorklistOutageModel model = SQLiteWorklistOutageModel(
                  id: i,
                  user: userModel.userID,
                  region: userModel.rsg,
                  mainmenu: _mainMenuModel.result[i].menuMainID,
                  submenU: _mainMenuModel.result[i].menuMainName,
                  checklist: i + 1,
                  reqNo: null,
                  doOrNot: null,
                  reseanNOT: null,
                  workperform: null,
                  workstatus: 0,
                  isComplete: null,
                  imgList: null,
                  isMainLine: null,
                  latitude: null,
                  longtitude: null,
                  remark: null,
                  dateCreated: null,
                );
                SQLiteHelperOutage().insertWorkList(model);
              }
            } //for loop

            //test read DB
            // List<SQLiteWorklistOutageModel> models = [];
            print("model lenght : " + models.length.toString());
            SQLiteHelperOutage().readWorkList().then((result) {
              if (result == null) {
                normalDialog(context, "Error", "ไม่มีข้อมูล");
              } else {
                setState(() {
                  models = result;
                });
              }
            });
          });
        } //else
      });
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
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
          title: ShowTitle(title: 'งานปฏิบัติการและบำรุงรักษา', index: 3),
        ),
        drawer: ShowDrawer(userModel: userModel),
        body: buildGridViewMainMenu(context),
      ),
    );
  }

  Widget buildGridViewMainMenu(BuildContext context) {
    double widthsize = 0.0;
    widthsize = MediaQuery.of(context).size.width;
    return GridView.count(
        padding: models.length > 4
            ? const EdgeInsets.only(top: 0.0)
            : const EdgeInsets.only(left: 90.0, right: 90.0),
        crossAxisCount: models.length > 4 ? 2 : 1,
        children: List.generate(models.length, (index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ElevatedButton(
                  onPressed: () {
                    print("main Menu " +
                        models[index].mainmenu +
                        "   subMenu :" +
                        (index + 1).toString());
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OutageWorkList(
                          userModel: userModel,
                          mainID: models[index].mainmenu,
                          mainName: models[index].submenU,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: widthsize * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ShowIconImage(
                              fromMenu: index == 0
                                  ? "mainO"
                                  : index == 1
                                      ? "mainO2"
                                      : index == 2
                                          ? "mainO3"
                                          : index == 3
                                              ? "mainO4"
                                              : "mainOther",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          models[index].submenU,
                          style: TextStyle(
                            color: index == models.length - 1
                                ? Colors.white
                                : Colors.black,
                            fontSize: widthsize * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: index == 0
                          ? MyConstant.outageMenu2
                          : index == 1
                              ? MyConstant.outageMenu1
                              : index == 2
                                  ? MyConstant.outageMenu3
                                  : index == 3
                                      ? MyConstant.outageMenu4
                                      : MyConstant.primart),
                ),
              ));
        }));
  }


  
}
