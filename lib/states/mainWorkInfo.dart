import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/mainlist.dart';

import 'package:wesafe/states/workRecord.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

import 'package:wesafe/utility/Test.dart';

class MainWorkInfo extends StatefulWidget {
  final SQLiteUserModel user_model;
  MainWorkInfo({@required this.user_model});
  @override
  _MainWorkInfoState createState() => _MainWorkInfoState();
}

class _MainWorkInfoState extends State<MainWorkInfo> {
  SQLiteUserModel userModel;
  int index = 0;
  List<String> titles = MyConstant.listMenu;
  String choose;
  double size;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.user_model;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: ShowTitle(title: 'MAIN LIST', index: 1),
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
      body: buildBodyContent(),
    );
  }

  Widget buildBodyContent() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          buildDept(),
          buildRegion(),
          buildRegion(),
          buildRegion(),
          buildRadio(),
          buildNext(),
        ],
      ),
    );
  }

  Widget buildNext() {
    size = MediaQuery.of(context).size.height;
    double bttn = size*0.3;
    return Container(
      padding: const EdgeInsets.only(bottom: 1.5,top: 200.0  ),
      child: Center(
        child: Column(
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () {
                  routeToMainList();
                },
                child: Container(child: Text('ถัดไป')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDept() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: Text("หน่วยงาน")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child:
                    Text(userModel == null ? "กบส.สนญ." : userModel.teamName)),
          ),
        ],
      ),
    );
  }

  Widget buildRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("ประเภทงาน"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 'PM',
              groupValue: choose,
              onChanged: (value) {
                setState(() {
                  choose = value;
                });
              },
            ),
            Text("PM")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 'CM',
              groupValue: choose,
              onChanged: (value) {
                setState(() {
                  choose = value;
                });
              },
            ),
            Text("CM")
          ],
        ),
      ],
    );
  }

  Row buildRegion() {
    List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
    ListItem _selectedItem;

    List<ListItem> _dropdownItems = [
      ListItem("A", "กฟน.1"),
      ListItem("B", "กฟน.2"),
      ListItem("C", "กฟน.3"),
      ListItem("D", "กฟฉ.1"),
      ListItem("E", "กฟฉ.2"),
      ListItem("F", "กฟฉ.3"),
      ListItem("G", "กฟก.1"),
      ListItem("H", "กฟก.2"),
      ListItem("I", "กฟก.3"),
      ListItem("J", "กฟต.1"),
      ListItem("K", "กฟต.2"),
      ListItem("L", "กฟต.3"),
    ];
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("เขต"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<ListItem>(
            value: _selectedItem,
            items: _dropdownMenuItems,
            onChanged: (value) {
              _selectedItem = value;
              print("selected >>>>>> ${_selectedItem.name}");
            },
          ),
        ),
      ],
    );
  }

  void routeToMainList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainList(user_model: userModel,
          
        ),
      ),
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
        title: MyConstant.listMenu[0],
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

  ListTile buildNewJob(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.date_range,
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
