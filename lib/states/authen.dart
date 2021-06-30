import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/MastWorkListModel.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/states/myservice.dart';
import 'package:wesafe/states/pincode.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/my_constainDB.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showImage.dart';
import 'package:wesafe/widgets/showTitle.dart';

class Authen extends StatefulWidget {
  
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double size;
  bool remember = false;
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
                buildShowTitle(),
                buildUser(),
                buildPassword(),
                buildRemember(),
                buildLogin()
              ],
            ),
          ),
        ),
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
            // print('NO space');
            checkLogin(userController.text, passwordController.text);
          }
        },
        child: Text('ลงทะเบียน'),
      ),
      // ElevatedButton(
      //   onPressed: () {
      //     SQLiteHelperWorkList sqlite = new SQLiteHelperWorkList();
      //     sqlite.dropDB();
      //   },
      //   child: Text('DROP DB'),
      // ),
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
      // response.transform(utf8.decoder).listen((contents) {
      //   contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");
      //   userModel = UserModel.fromJson(json.decode(contents));

      // });

      response.transform(utf8.decoder).listen(
        (contents) {
          contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");

          //if (contents.contains('Error')) {
           // print('##### if   Error : $contents');
          //   contents = contents.replaceAll("[", "").replaceAll("]", "");
          //   errorModel = Errormodel.fromJson(json.decode(contents));
          //   normalDialog(context, 'Error', errorModel.error);
         // } else {


            //  print('##### else   content : $contents');
            //  userModel = UserModel.fromJson(json.decode(contents));
            //  routeToWorkMainMenu(userModel);


            SQLiteHelperWorkList sqLiteHelperWorkList = new SQLiteHelperWorkList();
            sqLiteHelperWorkList.connectedDatabase();

MastWorkListModel mastWorkListModel = MastWorkListModel(
              workID: 2,
              userID: 'aaaa',
              rsg: 'I03155',
              ownerID: '12345',
              mainWorkID: '12345',
              subWorkID: 6,
              checklistID: 3,
              lat: '12345',
              lng: '12345',
              workPerform: 'TEST343434',
              remark: '12345',
              isChoice: 0,
              reason: '12345',
              msgFromWeb: '12345',
              createDate: '12345',
              uploadDate: '12345',
            );

            SQLiteHelperWorkList().insertDatebase(mastWorkListModel).then(
                  (value) => normalDialog(context, 'SQLite', 'Success'),
                );


            readDataSQLite2();

            // if (remember) {
            //   preferences.setString(MyConstant.keyPincode, "123456");
            // }

            // userModel = UserModel.fromJson(json.decode(contents));
            // if (userModel.result.length > 0) {
            //   if (userModel.result[0].ownerID.length > 1) {

            //     print('######## LOGIN >>>  ${userModel.result[0].fIRSTNAME}');
            //    print('######## PINCODE >>>  ${userModel.result[0].pinCode}');
            //     //routeToMultiOwner(userModel);
            //     // } else {
            //     //routeToWorkMainMenu(userModel);
            //     // insert to sqlite and go to pincode.dart

            //   }
            // }
         // }
        
        },
      );
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }





 Future<Null> readDataSQLite2() async {
    List<MastWorkListModel> models = [];
    print('####### readDataSQLite() ');
    await SQLiteHelperWorkList().readDatabase().then((result) {
      if (result == null) {
        normalDialog(context, 'SQLite', 'no data');
      } else {
        print('####### readData  result: $result');
        models = result;
        for (var item in models) {
          normalDialog(
              context, 'SQLite', '${item.workID}  :    ${item.workPerform}');
        }
      }
    });
  }


  void routeToMultiOwner(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Myservice(
          user_model: userModel,
        ),
      ),
    );
  }

  void routeToWorkMainMenu(UserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PinCodeAuthen(user_model: userModel,
            ),
      ),
    );
  }

  ShowTitle buildShowTitle() => ShowTitle(
        title: MyConstant.appName,
        index: 0,
      );

  Container buildImage() {
    return Container(
      width: size * 0.6,
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
      margin: EdgeInsets.only(top: 16),
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
}
