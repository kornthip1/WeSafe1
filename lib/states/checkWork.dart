import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

import 'mainMenu.dart';

class CheckWork extends StatefulWidget {
  @override
  _CheckWorkState createState() => _CheckWorkState();
}

class _CheckWorkState extends State<CheckWork> {
  int index = 0;
  SQLiteUserModel userModel;
  SQLiteWorklistModel _sqLiteWorklistModel;
  String tt = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readWorklist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ตรวจสอบสถานะการทำงาน"),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildNewJob(context),
                buildCheckStatus(context),
              ],
            ),
            buildSignOut()
          ],
        ),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    
    print("CHECCK >>>>>  remark : ${_sqLiteWorklistModel.remark}");
    return Container(
      child: new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => (

            //     ),
            //   ),
            // );
          },
          child: Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Text("AAAAAA"),
                    Text("BBBBB"),
                    Text("CCCCCC"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> readWorklist() async {
    List<SQLiteWorklistModel> models = [];
    await SQLiteHelper().readWorkDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        SQLiteWorklistModel sqLiteWorklistModel;
        for (var item in models) {
          print("CHECK()  #####  id ${item.id}");

          print("CHECK()  #####  id ${item.id}");

          print("CHECK()  #####  workID ${item.workID}");

          print("CHECK()  #####  region ${item.workRegion}");
          print("CHECK()  #####  region ${item.workRegion}");
          print("CHECK()  #####  Province ${item.workProvince}");
          print("CHECK()  #####  Station  ${item.workStation}");
          sqLiteWorklistModel = SQLiteWorklistModel(
            checklistID: item.checklistID,
            createDate: item.createDate,
            isChoice: 0,
            userID: "",
            lat: "",
            lng: "",
            workDoc: item.workDoc,
            workID: item.workID,
            workPerform: item.workPerform,
            workProvince: item.workProvince,
            workRegion: item.workRegion,
            workStation: item.workStation,
            workType: item.workType,
            remark: "9",
          );
        } //for
        setState(() {
          _sqLiteWorklistModel = sqLiteWorklistModel;
        });
      }
    });
  }

/************ LEFT MENU */
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

  ListTile buildNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[0],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
        //Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenu(
              userModel: userModel,
              ownerId: userModel.ownerID,
            ),
          ),
        );
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

  ListTile buildCheckStatus(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check_circle_outline,
        size: 36,
        color: MyConstant.primart,
      ),
      title: ShowTitle(
        title: MyConstant.listMenu[1],
        index: 1,
      ),
      onTap: () {
        setState(() {
          index = 0;
        });
      },
    );
  }
}
