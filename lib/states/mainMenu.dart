import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/mastWorkListDB_Model.dart';
import 'package:wesafe/models/user_Model.dart';
import 'package:wesafe/states/mainlist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class MainMenu extends StatefulWidget {
  final UserModel userModel;
  final String ownerId;
  MainMenu({@required this.userModel, this.ownerId});
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  UserModel userModel;
  String onwerId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    onwerId = widget.ownerId;
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
      crossAxisCount: 2,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainList(user_model: userModel),
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
                        fromMenu: "mainO",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ShowTitle(
                    title: 'item  $index',
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
            SQLiteHelperWorkList().deleteSQLiteAll();
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

            SQLiteHelperWorkList().insertDatebase(mastWorkListModel).then(
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
    await SQLiteHelperWorkList().readDatabase().then((result) {
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
          : Text('${userModel.fIRSTNAME}  ${userModel.lASTNAME}'),
      accountEmail: userModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${userModel.dEPTNAME}'),
    );
  }
}
