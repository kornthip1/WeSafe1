import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/models/mastOfficeAddrModel.dart';
import 'package:wesafe/models/sqliteOfficeAddr.dart';
import 'package:wesafe/states/myservice.dart';
import 'package:wesafe/states/pincode.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqliteHotline.dart';
import 'package:wesafe/widgets/showImage.dart';
import 'package:wesafe/widgets/showTitle.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double size;
  bool remember = false;
  String ip;
  String currentVersion = "1.3.1";
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage(),
                // buildShowTitle(),
                buildUser(),
                buildPassword(),
                //  buildRemember(),
                buildLogin()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10, left: 110),
        width: size * 0.6,
        child: Text("WeSafe Version " + currentVersion + "   12/04/2022"),
      ),
    );
  }

  Container buildRemember() {
    return Container(
      width: size * 0.6,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: ShowTitle(
          title: 'Remember Me',
          index: 1,
        ),
        value: remember,
        onChanged: (value) {
          setState(() {
            remember = value;
            print('#### remember = $remember');
          });
        },
      ),
    );
  }

  Container buildLogin() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            checkLogin(userController.text, passwordController.text);
          }
        },
        child: Text('ลงทะเบียน'),
      ),
    );
  }

  Future<Null> checkLogin(String user, String pass) async {
    try {
      final client = HttpClient();

      final request = await client.postUrl(
          Uri.parse("${MyConstant.webService}WeSafeCheckEmp")); //CheckEmp
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write('{"userName": "$user",   "passwd": "$pass"}');
      final response = await request.close();
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      UserModel userModel;

      // error  status
      response.transform(utf8.decoder).listen(
        (contents) {
          contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");
          if (contents.contains('Error')) {
            contents = contents.replaceAll("[", "").replaceAll("]", "");
            normalDialog(context, 'Error', contents);
          } else {
            // getIp();
            userModel = UserModel.fromJson(json.decode(contents));
            preferences.setString(MyConstant.keyUser, userController.text);
            preferences.setString(MyConstant.appVersion, currentVersion);
            insertLog(userModel);

            //4//6
            if (userModel.result.userRole.contains("4") ||
                userModel.result.userRole.contains("6") ||
                userModel.result.userRole.contains("7")) {
              //get OFFICE for prepair
              prepareOfficeAddr(userModel.result.rEGIONCODE).then((value) {
                print('after prepareOfficeAddr () : value = $value');
                if (value != null) {
                  routeToCreatePinCode(userModel);
                }
              });
            } else {
              normalDialog(context, "ไม่สามารถเข้าระบบได้",
                  "ไม่มีสิทธิ์เข้าใช้งานระบบ WeSafe");
            }
          } //else
        },
      );
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }

  void routeToMultiOwner(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Myservice(
            //user_model: userModel,
            ),
      ),
    );
  }

  void routeToCreatePinCode(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinCodeAuthen(
          userModels: userModel,
        ),
      ),
    );
  }

  Future<Null> insertLog(UserModel userModel) async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();
      print("#----------> IP : " +
          data
              .toString()
              .replaceAll("{", "")
              .replaceAll("}", "")
              .replaceAll(":", "")
              .replaceAll("ip", "")
              .trim());
      ip = data
          .toString()
          .replaceAll("{", "")
          .replaceAll("}", "")
          .replaceAll(":", "")
          .replaceAll("ip", "")
          .trim();

      final response = await http.post(
        Uri.parse('${MyConstant.newService}log/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            '[{"Employee_ID": "${userModel.result.eMPLOYEEID}",   "IPAddress": "$ip" , "Activity":"log login" , "Desc":"เข้าใช้งาน Application wesafe" }]',
      );
      print('insert log : ${response.statusCode}');
    } catch (e) {
      print("insert log  error : " + e.toString());
    }
  }

  // ShowTitle buildShowTitle() => ShowTitle(
  //     //  title: MyConstant.appName,
  //       index: 0,
  //     );

  Container buildImage() {
    return Container(
      width: size * 0.5,
      child: ShowImage(),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: size * 0.6,
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill password';
          } else {
            return null;
          }
        },
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: size * 0.6,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill User';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<String> getIp() async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    print("#----------> IP : " +
        data
            .toString()
            .replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll(":", "")
            .replaceAll("ip", "")
            .trim());
    setState(() {
      ip = data
          .toString()
          .replaceAll("{", "")
          .replaceAll("}", "")
          .replaceAll(":", "")
          .replaceAll("ip", "")
          .trim();
    });

    return data
        .toString()
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll(":", "")
        .replaceAll("ip", "")
        .trim();
  }

  Future<String> prepareOfficeAddr(String area) async {
    try {
      area = area.substring(0, 1);
      //print('prepareOfficeAddr --->  Area = $area');
      final response = await http.post(
        Uri.parse('${MyConstant.newService}office/get'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: '{"Area": "$area" }',
      );
      // print('####### --> ${response.body}');
      MastOfficeAddrModel model =
          MastOfficeAddrModel.fromJson(jsonDecode(response.body));
      for (var item in model.result) {
        //print('#######---> ${item.rEGIONGROUP}');
        SQLiteMastOfficeAddrModel sqlModel = SQLiteMastOfficeAddrModel(
            peaName: item.pEAName, regionGroup: item.rEGIONGROUP);

        SQLiteHotline().insertOffice(sqlModel);
      }
      return "Success";
    } catch (e) {
      normalDialog(context, 'Error', e.toString());
      return null;
    }
  }
}
