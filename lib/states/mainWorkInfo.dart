import 'package:flutter/material.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/sqliteWorklistModel.dart';
import 'package:wesafe/models/sqliteStationModel.dart';
import 'package:wesafe/states/mainlist.dart';
import 'package:wesafe/utility/dialog.dart';

import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';

import 'package:wesafe/utility/Test.dart';

class MainWorkInfo extends StatefulWidget {
  final SQLiteUserModel user_model;
  final int workID;
  MainWorkInfo({@required this.user_model, this.workID});
  @override
  _MainWorkInfoState createState() => _MainWorkInfoState();
}

class _MainWorkInfoState extends State<MainWorkInfo> {
  SQLiteUserModel userModel;
  int _workId;
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
  bool isOtherStation = false;
  TextEditingController _otherStation = TextEditingController();
  @override
  void initState() {
    userModel = widget.user_model;
    _workId = widget.workID;
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
      drawer: ShowDrawer(userModel: userModel),
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
          if (isOtherStation == true) buildOtherStation(),
          if (isOtherStation == true) buildDivider(),
          buildRadio(),
          //buildNext(),
        ],
      ),
    );
  }

  Widget buildOtherStation() {
    double size = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShowTitle(
                    title: "สถานีไฟฟ้า",
                    index: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: size * 0.7,
          child: TextFormField(
            controller: _otherStation,
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาสถานีไฟฟ้า';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.add_location_alt_rounded),
              labelText: 'สถานีไฟฟ้า :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
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
                    Text(userModel == null ? "กบส.สนญ." : userModel.deptName)),
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
                      _selectedProviceItem = ListItem("2", _myProvince);
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
                      _selectedStationItem = ListItem("3", _myStation);
                      _myStation.contains("อื่น")
                          ? isOtherStation = true
                          : isOtherStation = false;
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
          listStation.add(item.stationName);
        }
        setState(() {
          listStation.add("อื่นๆ");
        });
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

  Column buildNext() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  //SQLiteHelper().insertWorkDatebase(sqLiteWorklistModel);
                  SQLiteWorklistModel sqLiteWorklistModel;
                  if (_selectedRegionItem == null) {
                    normalDialog(
                        context, "กรุณาเลือก", "เขต ที่ต้องการปฏิบัติงาน");
                  } else if (_selectedProviceItem == null) {
                    normalDialog(
                        context, "กรุณาเลือก", "จังหวัดที่ต้องการปฏิบัติงาน");
                  } else if (_selectedStationItem == null ||
                      (_selectedStationItem.name.contains("อื่น") &&
                          _otherStation.text == "")) {
                    normalDialog(
                        context, "กรุณาเลือก", "สถานีที่ต้องการปฏิบัติงาน");
                  } else if (choose == null) {
                    normalDialog(context, "กรุณาเลือก", "ประเภทงาน");
                  } else {
                    // print("NEXT WORK -----> $_workId");
                    // print("NEXT Region -----> ${_selectedRegionItem.name}");
                    // print("NEXT Provice -----> ${_selectedProviceItem.name}");
                    // print("NEXT Station -----> ${_selectedStationItem.name}");
                    // print("NEXT WORK TYPE -----> $choose");

                    sqLiteWorklistModel = SQLiteWorklistModel(
                      checklistID: 0,
                      createDate: "",
                      isChoice: 0,
                      userID: userModel.userID,
                      lat: "",
                      lng: "",
                      workDoc: "",
                      workID: _workId,
                      workPerform: null,
                      workProvince: _selectedProviceItem.name,
                      workRegion: _selectedRegionItem.name,
                      workStation: _selectedStationItem.name.contains("อื่น")
                          ? _otherStation.text
                          : _selectedStationItem.name,
                      workType: choose,
                      remark: null,
                    );

                    _selectedRegionItem = null;
                    _selectedProviceItem = null;
                    _selectedStationItem = null;

                    routeToMainList(sqLiteWorklistModel);
                  }
                },
                child: Text("ถัดไป")),
          ],
        )
      ],
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
