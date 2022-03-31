import 'package:flutter/material.dart';
import 'package:wesafe/models/MastOutageMenuModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/hotlineWorkRec.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showProgress.dart';
import 'package:wesafe/widgets/showTitle.dart';

class HotlineWorklist extends StatefulWidget {
  final String MenuName;
  final int MenuID;
  final int MenuSubID;
  final String MenuSubName;
  final SQLiteUserModel userModel;
  HotlineWorklist(
      {@required this.MenuName,
      this.MenuID,
      this.MenuSubID,
      this.MenuSubName,
      this.userModel});

  @override
  State<HotlineWorklist> createState() => _HotlineWorklistState();
}

class _HotlineWorklistState extends State<HotlineWorklist> {
  List<MastOutageMenuModel> listMenu = [];
  bool load = true;
  @override
  void initState() {
    workListInfo();
  }

  void workListInfo() {
    try {
      SQLiteHotline()
          .selectChecklist(widget.MenuID, widget.MenuSubID)
          .then((result) {
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

    double size = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ShowTitle(title: "บันทึกงาน", index: 3),
        ),
        drawer: ShowDrawer(userModel: widget.userModel),
        body: load
            ? ShowProgress()
            : Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 15.0) ,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.MenuName, style: TextStyle(
                      fontSize: size * 0.05,
                      fontWeight: FontWeight.bold,
                    ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.MenuSubName,style: TextStyle(
                      fontSize: size * 0.043,
                      fontWeight: FontWeight.bold,
                    ),),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      buildListView(),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          height: 40,
          child: ElevatedButton(
            child: ShowTitle(
              title: "ยืนยัน",
              index: 3,
            ),
            onPressed: () {
              //
            },
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    double size = MediaQuery.of(context).size.width;

    return new Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 25.0),
        width: size * 0.9,
        child: ListView.builder(
          itemCount: listMenu.length - 1,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              //normalDialog(context, "title", "message");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (HotlineWorkRec(
                    workType: listMenu[index].type,
                    isMainLine: "",
                    listStatus: 1,
                    mainID: listMenu[index].menuMainID.toString(),
                    mainName: listMenu[index].menuMainName,
                    userModel: widget.userModel,
                    workID: 1,
                    workList: listMenu[index].menuListID,
                    workName: listMenu[index].menuListName,
                  )),
                ),
              );

              //HotlineWorkRec
            },
            child: Card(
              color: // listMenu[index].workstatus == 2
                  //? Colors.green[200]
                  Colors.grey[300],
              child: ListTile(
                leading: Container(
                  width: size * 0.13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(""), //showIconList(index, 0),
                  ),
                ),
                title: Text(
                  listMenu[index].menuListName,
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
    );
  }
}
