import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';

class MainInfo extends StatefulWidget {
  final SQLiteUserModel userModel;
  MainInfo({@required this.userModel});

  @override
  State<MainInfo> createState() => _MainInfoState();
}

class _MainInfoState extends State<MainInfo> {
  // preferences.setString(MyConstant.appVersion, currentVersion);
  String appVersion = "";
  @override
  // ignore: must_call_super
  Future<void> initState() {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // appVersion = preferences.getString("APPVERSION") == null
    //     ? ""
    //     : preferences.getString("APPVERSION");

    //test
    appVersion = "1.3.0";
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double sizeH = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ShowTitle(title: "เวอร์ชัน", index: 3),
        ),
        drawer: ShowDrawer(userModel: widget.userModel),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: buildHeader(size, sizeH),
            ),
            buildUpdateVersion(size),
          ],
        ),
      ),
    );
  }

  Container buildHeader(double size, double sizeH) {
    return new Container(
      height: sizeH * 0.3,
      color: Colors.transparent,
      child: new Container(
          decoration: new BoxDecoration(
              color: Colors.purple,
              borderRadius: new BorderRadius.only(
                bottomRight: const Radius.circular(20.0),
                bottomLeft: const Radius.circular(20.0),
              )),
          child: new Center(
            child: Column(
              children: [
                Image.asset(
                  MyConstant.imageMenuH_1,
                  height: 150,
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                   
                    child: Container(
                      decoration: new BoxDecoration(borderRadius: BorderRadius.circular(3),color: Colors.deepOrange[400]),
                      //color: Colors.orange[300],
                      width: size * 0.3,
                      child: Center(
                        child: new Text(
                          "V. 1.3.0 ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildUpdateVersion(double size) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Card(
        child: Container(
          width: size*0.95,
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ListTile(
                    leading: Container(
                      width: size * 0.13,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.settings,
                          size: size * 0.1,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    title: Align(
                      alignment:Alignment.center,
                      child: Column(
                        
                        children: [
                          Text(
                            'ตรวจสอบและอัพเดท',
                            style: TextStyle(
                              fontSize: size * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('สามารถตรวจสอบและอัพเดทได้ที่'),
                          ElevatedButton(
                            onPressed: () {
                              print('call api and update..');
                            },
                            child: Container(
                              width: size * 0.3,
                              child: Row(
                                children: [
                                  Icon(Icons.store),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'อัพเดท version',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
