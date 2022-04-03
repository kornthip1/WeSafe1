import 'package:flutter/material.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/hotlineWorklist.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:wesafe/widgets/show_icon_image.dart';

class HotlineSubMenu extends StatefulWidget {
  final String MenuName;
  final int MenuID;
  final SQLiteUserModel userModel;
  HotlineSubMenu({@required this.MenuName, this.MenuID, this.userModel});

  @override
  State<HotlineSubMenu> createState() => _HotlineSubMenuState();
}

class _HotlineSubMenuState extends State<HotlineSubMenu> {
  List<MastOutageMenuModel> listMenu = [];
  bool load = true;
  @override
  void initState() {
    workListInfo();
  }

  void workListInfo() {
    try {
      SQLiteHotline().selectSubMenu(widget.MenuID).then((result) {
        if (result == null) {
          normalDialog(context, "Error", "ไม่มีข้อมูล");
        } else {
          setState(() {
            listMenu = result;
            load = false;
          });
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ShowTitle(title: widget.MenuName, index: 3),
        ),
        drawer: ShowDrawer(userModel: widget.userModel),
        body: Column(
          children: [
            buildGridViewMainMenu(context),
          ],
        ), // load ? ShowProgress() : buildGridViewMainMenu(context),

        //load
        //? ShowProgress()
        //: buildGridViewMainMenu(
        //   context), //load ? ShowProgress() : buildGridViewMainMenu(context),
      ),
    );
  }

  Widget buildShowInfo() {
    double size = MediaQuery.of(context).size.width;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Container(
          width: size * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(widget.MenuName),
          ),
        ),
      ),
    );
  }

  Widget buildGridViewMainMenu(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return new Expanded(
      child: Center(
        child: Container(
          width: size * 0.85,
          child: Padding(
            padding: const EdgeInsets.only(top: 22.5),
            child: ListView.builder(
              itemCount: listMenu.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (HotlineWorklist(
                        workID: "0",
                        MenuName: listMenu[index].menuMainName,
                        MenuID: listMenu[index].menuMainID,
                        MenuSubID: listMenu[index].menuSubID,
                        MenuSubName: listMenu[index].menuSubName,
                        userModel: widget.userModel,
                      )),
                    ),
                  );

                  //HotlineWorkRec
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.purple,
                          // red as border color
                        ),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Card(
                      color: Colors.purple[100],
                      child: Padding(
                        padding: const EdgeInsets.all(23.0),
                        child: ListTile(
                          leading: Container(
                            width: size * 0.1,
                            child: Image.asset(
                                index == 0
                                    ? MyConstant.imgIconHotSub1
                                    : index == 1
                                        ? MyConstant.imgIconHotSub2
                                        : index == 2
                                            ? MyConstant.imgIconHotSub3
                                            : MyConstant.imgIconHotSub4,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover),
                          ),
                          title: Text(
                            listMenu[index].menuSubName,
                            style: TextStyle(
                              fontSize: size * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
}
