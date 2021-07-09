import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/states/mainlist.dart';
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
  SQLiteUserModel _userModel;
  SQLiteWorklistModel _sqLiteWorklistModel;
  String tt = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //readUserInfo();
    //readWorklist();
  }

  @override
  Widget build(BuildContext context) {
     readUserInfo();
     readWorklist();
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
    print("#### buildListView()");
    readWorklist();
    readUserInfo();

    if(_sqLiteWorklistModel == null){
    _sqLiteWorklistModel = SQLiteWorklistModel(
              checklistID: 1,
              createDate: "",
              isChoice: 0,
              userID: "",
              lat: "",
              lng: "",
              workDoc: "",
              workID: 1,
              workPerform: "",
              workProvince: "กฟฉ.3",
              workRegion: "กาญจนบุรี",
              workStation: "สถานีไฟฟ้า C",
              workType: "PM",
              remark: "9",
            );
    }

    return Container(
      child: new ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            print("ontap  : $tt");

            print("ontap  : ${_sqLiteWorklistModel.remark}");
            print("ontap  userID : ${_userModel.userID}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainList(
                  sqLiteWorklistModel: _sqLiteWorklistModel,
                  user_model: _userModel ,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    ShowTitle(
                      title: "WSI2021OZ0000000001",
                      index: 4,
                    ),
                    ShowTitle(
                      title: "การปฏิบัติงานภายในสถานีไฟฟ้าและระบบไฟฟ้า",
                      index: 2,
                    ),
                    ShowTitle(
                      title: _sqLiteWorklistModel.workRegion +
                          " " +
                          _sqLiteWorklistModel.workStation,
                      index: 2,
                    ),
                    ShowTitle(
                      title: "ตรวจสอบแล้วรอปิดงาน",
                      index: 4,
                    )
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
    print("#### readWorklist()");

    SQLiteWorklistModel sqLiteWorklistModel;
    List<SQLiteWorklistModel> models = [];
    await SQLiteHelper().readWorkDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        print("#### CHECK readWorklist()   models size  : ${models.length}");
        for (var item in models) {
           if (item.id == models.length) {
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
              workID: 1,
              workPerform: item.workPerform,
              workProvince: item.workProvince,
              workRegion: item.workRegion,
              workStation: item.workStation,
              workType: item.workType,
              remark: "9",
            );
            _sqLiteWorklistModel = sqLiteWorklistModel;
           }
        } //for
        
      }
    });

   

   
    tt = "TEST";
  }

  Future<Null> readUserInfo() async {
    print("#### readWorklist()");

    SQLiteUserModel sqLiteUserModel;
    List<SQLiteUserModel> models = [];
    await SQLiteHelper().readUserDatabase().then((result) {
      if (result == null) {
      } else {
        models = result;
        print("#### readUserInfo()   models size  : ${models.length}");
        for (var item in models) {
          print("CHECK()  #####  id ${item.userID}");
          print("CHECK()  #####  id ${item.firstName}");
          print("CHECK()  #####  region ${item.ownerID}");
          print("CHECK()  #####  region ${item.ownerName}");

          sqLiteUserModel = SQLiteUserModel(
            userID: item.userID,
            firstName: item.firstName,
            lastName: item.lastName,
            deptCode: item.deptCode,
            ownerID: item.ownerID,
            ownerName: item.ownerName,
            pincode: item.pincode,
          );
        } //for
      }
    });
    _userModel = sqLiteUserModel;
    tt = "TEST";
  }

/************ LEFT MENU */
  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primart),
      currentAccountPicture: ShowMan(),
      accountName: _userModel == null
          ? Text('Name')
          : Text('${_userModel.firstName}  ${_userModel.lastName}'),
      accountEmail: _userModel == null
          ? Text('Position')
          : Text('ตำแหน่ง  :  ${_userModel.deptCode}'),
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
              userModel: _userModel,
              ownerId: _userModel.ownerID,
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
