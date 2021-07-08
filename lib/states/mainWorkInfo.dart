import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';

import 'package:wesafe/states/mainlist.dart';

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
  @override
  void initState() {
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
          child: ShowTitle(
            title: "เขต",
            index: 4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<ListItem>(
            value: _selectedItem,
            items: _dropdownMenuItems,
            onChanged: (value) {
              _selectedItem = value;
              _selectedRegionItem = value;
              print("selected >>>>>> ${_selectedItem.name}");
              buildProvince();
            },
          ),
        ),
      ],
    );
  }

  Row buildProvince() {
    List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
    ListItem _selectedItem;

    List<ListItem> _dropdownItems = [
      ListItem("A", "นครปฐม"),
      ListItem("B", "สุพรรณบุรี"),
      ListItem("C", "กาญจนบุรี"),
    ];
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowTitle(
            title: "จังหวัด",
            index: 4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<ListItem>(
            value: _selectedItem,
            items: _dropdownMenuItems,
            onChanged: (value) {
              _selectedItem = value;
              _selectedProviceItem = value;
              print("selected >>>>>> ${_selectedItem.name}");
            },
          ),
        ),
      ],
    );
  }

  Row buildStation() {
    List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
    ListItem _selectedItem;

    List<ListItem> _dropdownItems = [
      ListItem("A", "สถานีไฟฟ้า A"),
      ListItem("B", "สถานีไฟฟ้า B"),
      ListItem("C", "สถานีไฟฟ้า C"),
    ];
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShowTitle(
            title: "สถานีไฟฟ้า",
            index: 4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<ListItem>(
            value: _selectedItem,
            items: _dropdownMenuItems,
            onChanged: (value) {
              _selectedItem = value;
              _selectedStationItem = value;
              print("selected >>>>>> ${_selectedItem.name}");
            },
          ),
        ),
      ],
    );
  }

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
                  //         SQLiteUserModel sqLiteUserModel = SQLiteUserModel(
                  //     deptCode: userModel.result.dEPTNAME,
                  //     firstName: userModel.result.fIRSTNAME,
                  //     lastName: userModel.result.lASTNAME,
                  //     createdDate: now.toString(),
                  //     leaderName: userModel.result.learderName,
                  //     pincode: _textEditingController.text,
                  //     ownerID: userModel.result.ownerID[0],
                  //     ownerName: userModel.result.ownerName,
                  //     position: "",
                  //     teamName: userModel.result.tEAM,
                  //     userID: userModel.result.eMPLOYEEID);

                  // SQLiteHelper().insertUserDatebase(sqLiteUserModel);

                  SQLiteWorklistModel sqLiteWorklistModel = SQLiteWorklistModel(
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

                  //SQLiteHelper().insertWorkDatebase(sqLiteWorklistModel);
                  print("NEXT Region -----> ${_selectedRegionItem.name}");
                  print("NEXT Provice -----> ${_selectedProviceItem.name}");
                  print("NEXT Station -----> ${_selectedStationItem.name}");

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

  Widget dropList() {
    List statesList = [0];
    String _myState;

    statesList.add(1212);
    statesList.add(23232);

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
                  hint: Text('Select State'),
                  onChanged: (String newValue) {
                    // setState(() {
                    //   _myState = newValue;
                    //   _getCitiesList();
                    //   print(_myState);
                    // });
                  },
                  items: statesList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['name']),
                          value: item['id'].toString(),
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
