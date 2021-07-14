import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/sqliteStationModel.dart';
import 'package:wesafe/states/mainlist.dart';
import 'package:wesafe/utility/dialog.dart';

import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';

import 'package:wesafe/utility/Test.dart';
import 'package:wesafe/states/checkWork.dart';

import 'mainMenu.dart';

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
  ListItem _selectedRegionItem;
  ListItem _selectedProviceItem;
  ListItem _selectedStationItem;
List<ListItem> _dropdownItems;

  List<String> listProvince = [];
  String _myProvince;
  @override
  void initState() {
    
    userModel = widget.user_model;
    super.initState();
     _getStateList();
     readStationInfo();
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: ShowTitle(title: 'MAIN INFO', index: 1),
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
      body: Stack(
        children: [
          buildBodyContent(),
          buildNext(),
        ],
      )

      //Stack(child: buildBodyContent()),
      ,
    );
  }

  Widget buildBodyContent() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          buildDept(),
          buildDivider(),
          buildRegion(),
          buildDivider(),
          buildProvince(),
          buildDivider(),
          buildStation(),
          buildDivider(),
          buildRadio(),
          //buildNext(),
        ],
      ),
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        endIndent: 10.0,
        indent: 10.0,
        thickness: 2,
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
            child: Container(
              child: ShowTitle(
                title: "หน่วยงาน",
                index: 4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child:
                    Text(userModel == null ? "กบส.สนญ." : userModel.deptCode)),
          ),
        ],
      ),
    );
  }

  Widget buildRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: "ประเภทงาน",
          index: 4,
        ),
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
            Text("PM(ZPM4)")
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
            Text("CM(ZPM2)")
          ],
        ),
      ],
    );
  }

  List statesList;
  String _myState;
  List<String> listRegion = [];

  Widget buildRegion() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _myState,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Select Region'),
                  onChanged: (String newValue) {
                    setState(() {
                      _myState = newValue;
                      _selectedRegionItem = ListItem("1", _myState);
                      _getProvinceList();
                      //print("####  my state : $_myState");
                    });
                  },
                  items: listRegion.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProvince() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _myProvince,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Select Province'),
                  onChanged: (String newValue) {
                    setState(() {
                      _myProvince = newValue;
                      _selectedProviceItem =  ListItem("2", _myProvince);
                      _getStationList();
                    });
                  },
                  items: listProvince.map((String values) {
                    return DropdownMenuItem<String>(
                      value: values,
                      child: Text(values),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStation() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _myStation,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Select Station'),
                  onChanged: (String newValue) {
                    setState(() {
                      _myStation = newValue;
                      _selectedStationItem =  ListItem("3", _myStation);
                    });

                    print("####   _myStation : $_myStation");
                  },
                  items: listStation.map((String values) {
                    return DropdownMenuItem<String>(
                      value: values,
                      child: Text(values),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//******STATION INFO ****/

  Future<Null> _getStateList() async {
    print("#### _getStateList()");
    List<SQLiteStationModel> models = [];
    listRegion = [];
    await SQLiteHelper().readStation().then((result) {
      if (result == null) {
      } else {
        models = result;
        for (var item in models) {
          listRegion.add(item.regionName);
        }
      }
    });
  }

  Future<Null> _getProvinceList() async {
    _myProvince = null;
    _myStation = null;
    listStation = [];
    print("#### state : $_myState     my province : $_myProvince");
    List<SQLiteStationModel> models = [];
    listProvince.clear();
    await SQLiteHelper().readStationByRegion(_myState).then((result) {
      if (result == null) {
      } else {
        models = result;

        for (var item in models) {
          setState(() {
            listProvince.add(item.province);
          });
        }
      }
    });
  }

  List<String> listStation = [];
  String _myStation;
  Future<Null> _getStationList() async {
    _myStation = null;
    print("#### province : $_myProvince     my Station : $_myStation");
    listStation.clear();
    List<SQLiteStationModel> models = [];
    await SQLiteHelper().readStationByProvince(_myProvince).then((result) {
      if (result == null) {
      } else {
        models = result;

        for (var item in models) {
          setState(() {
            listStation.add(item.stationName);
          });
        }
      }
    });
  }

/*******************/ /// */
  void routeToMainList(SQLiteWorklistModel sqLiteWorklistModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainList(
          user_model: userModel,
          sqLiteWorklistModel: sqLiteWorklistModel,
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
        title: MyConstant.listMenu[1],
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

  Column buildNext() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  // SQLiteWorklistModel sqLiteWorklistModel = SQLiteWorklistModel(
                  //   checklistID: 0,
                  //   createDate: "",
                  //   isChoice: 0,
                  //   userID: userModel.userID,
                  //   lat: "",
                  //   lng: "",
                  //   workDoc: "",
                  //   workID: 4,
                  //   workPerform: "",
                  //   workProvince: _selectedProviceItem.name,
                  //   workRegion: _selectedRegionItem.name,
                  //   workStation: _selectedStationItem.name,
                  // );

                  //SQLiteHelper().insertWorkDatebase(sqLiteWorklistModel);
                  SQLiteWorklistModel sqLiteWorklistModel;

                  _selectedRegionItem==null?  normalDialog(context, "เตือน!", "กรุณาเลือก เขต ที่ต้องการปฏิบัติงาน"): 
                  _selectedProviceItem ==null?  normalDialog(context, "เตือน!", "กรุณาเลือก จังหวัดที่ต้องการปฏิบัติงาน"):
                  _selectedStationItem==null? normalDialog(context, "เตือน!", "กรุณาเลือก สถานีที่ต้องการปฏิบัติงาน") : 
                  sqLiteWorklistModel = SQLiteWorklistModel(
                    checklistID: 0,
                    createDate: "",
                    isChoice: 0,
                    userID: userModel.userID,
                    lat: "",
                    lng: "",
                    workDoc: "",
                    workID: 4,
                    workPerform: "",
                    workProvince: _selectedProviceItem.name,
                    workRegion: _selectedRegionItem.name,
                    workStation: _selectedStationItem.name,
                  );
                  _selectedRegionItem = null; _selectedProviceItem = null; _selectedStationItem = null;

                  // print("NEXT Region -----> ${_selectedRegionItem.name}");
                  // print("NEXT Provice -----> ${_selectedProviceItem.name}");
                  // print("NEXT Station -----> ${_selectedStationItem.name}");

                  routeToMainList(sqLiteWorklistModel);
                },
                child: Text("ถัดไป")),
          ],
        )
      ],
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
            SQLiteHelper().deleteStationAll();
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


    Future<Null> readStationInfo() async {
    List<SQLiteStationModel> models = [];
    await SQLiteHelper().readStation().then((result) {
      if (result == null) {
      } else {
        models = result;
        SQLiteStationModel sqLiteStationModel;
        _dropdownItems = [];
        for (var item in models) {
          setState(() {
            _dropdownItems.add(ListItem(item.regionCode, item.regionName));
          });
        }
      }
    });
  }
}
