import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/checkWork.dart';
import 'package:wesafe/states/mainMenu.dart';
import 'package:wesafe/states/outageMainMenu.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

class ShowDrawer extends StatelessWidget {
  final SQLiteUserModel userModel;
  ShowDrawer({@required this.userModel});

  List<String> titles = MyConstant.listMenu;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              buildUserAccountsDrawerHeader(),
              buildMenuNewJob(context),
              buildMenuCheckStatus(context),
            ],
          ),
          buildSignOut(context),
        ],
      ),
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
        if (userModel.ownerID.contains("O")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OutageMainMenu(
                userModel: userModel,
                  //  userModel: userModel,
                  // ownerId: userModel.ownerID,
                  ),
            ),
          );
        } else if(userModel.ownerID.contains("Z")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainMenu(
                  //  userModel: userModel,
                  // ownerId: userModel.ownerID,
                  ),
            ),
          );
        }
      },
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckWork(),
          ),
        );
      },
    );
  }

  Column buildSignOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            SQLiteHelper().deleteWorkAll();
            SQLiteHelper().deleteStationAll();
            SQLiteHelper().deleteCheckListAll();
            SQLiteHelper().deletePercelAll();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Authen(),
              ),
            );
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
}
