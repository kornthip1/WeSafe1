import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/MastWorkListModel_test.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/mainWorkInfo.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';
import 'package:wesafe/models/mainListModel.dart';

class MainMenu extends StatefulWidget {
  final SQLiteUserModel userModel;
  final String ownerId;
  MainMenu({@required this.userModel, this.ownerId});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  SQLiteUserModel userModel;
  String onwerId;
  final List<String> mainMenuZ = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userModel = widget.userModel;
    onwerId = widget.ownerId;
    getWorkMenu(onwerId, "I00000");
    mainMenuZ.add("การปฏิบัติงานภายในสถานีไฟฟ้าและระบบไฟฟ้า");
    mainMenuZ.add("อื่นๆ");
  }

  Future<Null> getWorkMenu(String ownerID, String rsg) async {
    try {
      final client = HttpClient();

      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu"));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write('{"Owner_ID": "$ownerID",   "REGION_CODE": "$rsg"}');
      final response = await request.close();
      MainListModel mainListModel;

      response.transform(utf8.decoder).listen(
        (contents) {
          contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");
          if (contents.contains('Error')) {
            contents = contents.replaceAll("[", "").replaceAll("]", "");
            normalDialog(context, 'Error', contents);
          } else {
            //mainListModel = MainListModel.fromJson(json.decode(contents));

            //print(" -------->  menu main : ${mainListModel.result[0].lineToken[0]}");
            

          
          } //else
        },
      );
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }

  int index = 0;
  List<String> titles = MyConstant.listMenu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAINMENU  :  $onwerId'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildMenuNewJob(context),
                buildMenuCheckStatus(context),
              ],
            ),
            buildSignOut(),
          ],
        ),
      ),
      body: buildGridViewMainMenu(context),
    );
  }

  GridView buildGridViewMainMenu(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,//mainMenuZ.length > 4 ? 2 : 1,
      children: List.generate(mainMenuZ.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),  
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainWorkInfo(),
                ),
              );
            },
            child: Column(
              children: [
                Text(''),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Container(
                      width: 60,
                      child: ShowIconImage(
                        fromMenu:   index==0? "mainO" : "mainOther",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ShowTitle(
                    title: mainMenuZ[index],
                    index: 4,
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(primary: Colors.grey[100]),
          ),
        );
      }),
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

  ListTile buildMenuCheckStatus(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_outline,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: titles[1],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildMenuNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: titles[0],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            Navigator.pushNamedAndRemoveUntil(
                context, '/authen', (route) => false);
          },
          tileColor: Colors.red[900],
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'Sign out',
            index: 3,
          ),
        ),
      ],
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primart),
      currentAccountPicture: ShowMan(),
      accountName: userModel == null
          ? Text('Name')
          : Text('${userModel.firstName}  ${userModel.lastName}'),
      accountEmail: userModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${userModel.deptCode}'),
    );
  }


  
}
