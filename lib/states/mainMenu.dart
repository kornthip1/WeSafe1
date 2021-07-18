import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/mastMainMenuModel.dart';
import 'package:wesafe/states/mainWorkInfo.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';
import 'package:wesafe/states/checkWork.dart';

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
  List<String> mainMenuZ = [];
  int workID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userModel = widget.userModel;
    onwerId = widget.ownerId;
    getWorkMenu(onwerId, userModel.rsg);
  }

  Future<Null> getWorkMenu(String ownerID, String rsg) async {
    MastMainMenuModel _mainMenuModel;
    try {
      final client = HttpClient();

      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafeCheckMainMenu"));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write('{"Owner_ID": "$ownerID",   "REGION_CODE": "$rsg"}');
      final response = await request.close();

      response.transform(utf8.decoder).listen(
        (contents) {
          if (contents.contains('Error')) {
            contents = contents.replaceAll("[", "").replaceAll("]", "");
            normalDialog(context, 'Error', contents);
          } else {
            _mainMenuModel = MastMainMenuModel.fromJson(json.decode(contents));
            for (var item in _mainMenuModel.result) {
              if (item.menuMainName != null)
                setState(() {
                  print("#### mainMenu  :  ${item.menuMainName}");
                  mainMenuZ.add(item.menuMainName);
                });
            }
          } //else
        },
      );

      List<SQLiteWorklistModel> models = [];
      await SQLiteHelper().selectLastestWorkID().then((result) {
        if (result == null) {
        } else {
          models = result;
          if (models.length == 0) {
            setState(() {
              workID = 1;
            });
          } else {
            for (var item in models) {
              setState(() {
                workID = item.workID;
              });
            }
          }
        }
      });
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
        title: Text('MAINMENU'),
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
    double winsize = MediaQuery.of(context).size.width;
    return GridView.count(
      padding: mainMenuZ.length > 4
          ? const EdgeInsets.only(top: 0.0)
          : const EdgeInsets.only(left: 100.0, right: 100.0),
      crossAxisCount: mainMenuZ.length > 4 ? 2 : 1,
      children: List.generate(mainMenuZ.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainWorkInfo(
                    user_model: userModel,
                    workID: workID,
                  ),
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
                        fromMenu: index == 0 ? "mainO" : "mainOther",
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        child: Padding(
                          padding: mainMenuZ[index].length > 30
                              ? const EdgeInsets.all(0.0)
                              : const EdgeInsets.only(top: 18),
                          child: Text(
                            mainMenuZ[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: mainMenuZ[index].length > 30
                                    ? winsize * 0.04
                                    : winsize * 0.05),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(primary: MyConstant.floralWhite),
          ),
        );
      }),
    );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckWork(),
          ),
        );
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
          : Text('ตำแหน่ง  :  ${userModel.deptName}'),
    );
  }
}
