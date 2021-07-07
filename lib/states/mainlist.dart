import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/authen.dart';

import 'package:wesafe/states/workRecord.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showMan.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/utility/Test.dart';

class MainList extends StatefulWidget {
  final SQLiteUserModel user_model;
  MainList({@required this.user_model});
  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  SQLiteUserModel userModel;
  int index = 0;
  List<String> titles = MyConstant.listMenu;
  TextEditingController workController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.user_model;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Scrollbar(child: buildBodyContent()),
    );
  }

  Widget buildBodyContent() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildWorkPerform(),
        ),
        Divider(
          color: Colors.grey,
          indent: 5.0,
          endIndent: 5.0,
        ),
        buildDoc(),
        buildListView(),
      ],
    );
  }

  Widget buildWorkPerform() {
    double size = MediaQuery.of(context).size.width;
    double sizH = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(child: Text("รายละเอียดงาน")),
            ),
          ],
        ),
        Container(
          width: size * 0.7,
          child: TextFormField(
            controller: workController,
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาระบุรายละเอียดงาน';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.work_rounded),
              labelText: 'รายละเอียดงาน :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDoc() {
    double size = MediaQuery.of(context).size.width;
    double sizH = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(child: Text("เอกสารขอดับไฟ")),
            ),
          ],
        ),
        Container(
          width: size * 0.7,
          child: TextFormField(
            controller: workController,
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาระบุเอกสารขอดับไฟ';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.description),
              labelText: 'เอกสารขอดับไฟ :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          indent: 5.0,
          endIndent: 5.0,
        )
      ],
    );
  }

  Expanded buildListView() {
    List<ListItem> _listwork = [
      ListItem("3", "ลักษณะงาน"), //3
      ListItem("2", "ภาพการประชุมชี้แจงงาน"),
      ListItem("2", "ภาพผู้ปฏิบัติงานสวมใส่ PPE "),
      ListItem("3", "ภาพการตรวจวัดเเรงดัน"),
      ListItem("2", "ภาพเครื่องมือปฏิบัติงาน"),
      ListItem("3", "ภาพการต่อลงดิน"),
      // ListItem("5", "จำนวน พัสดุ ที่ใช้งาน"),
    ];

    return new Expanded(
      child: Container(
        child: new ListView.builder(
          itemCount: _listwork.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkRecord(
                  indexWork: int.parse(_listwork[index]
                      .value), //index is work type 0 = checklist, 1 = text , 2 = pic , 3 = radio
                ),
              ),
            ),
            child: Card(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    child: ListTile(
                      leading: Icon(
                        int.parse(_listwork[index].value) == 0
                            ? Icons.check
                            : int.parse(_listwork[index].value) == 1
                                ? Icons.description_outlined
                                : int.parse(_listwork[index].value) == 2
                                    ? Icons.camera_alt_outlined
                                    : int.parse(_listwork[index].value) == 3
                                        ? Icons.radio_button_checked_outlined
                                        : Icons.more_horiz_outlined

                        // index == 0
                        //     ? Icons.camera_alt_outlined
                        //     : index == 1
                        //         ? Icons.offline_bolt_outlined
                        //         : index == 2
                        //             ? Icons.fence_outlined
                        //             : Icons.check_circle_outline

                        ,
                        size: 36,
                        color: MyConstant.primart,
                      ),
                      title: Text('${index + 1}  :   ${_listwork[index].name}'),
                    ),
                  ),
                ),
              ),
            ),
          ),
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

  ListView buildChecklist() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => index == 0
                ? Authen()
                : MainList(
                    user_model: userModel,
                  ),
          ),
        ),
        child: Card(
          color: index == 0
              ? Colors.orange[900]
              : index == 1
                  ? Colors.yellow[700]
                  : index == 2
                      ? Colors.teal[600]
                      : index == 3
                          ? Colors.blueGrey
                          : Colors.purple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ShowTitle(title: '$index  : Work  ', index: 1),
            ),
          ),
        ),
      ),
    );
  }
}
