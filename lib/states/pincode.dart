import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/models/sqliteStationModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/models/mastStation.dart';
import 'package:wesafe/states/mainMenu.dart';
import 'package:wesafe/utility/dialog.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/utility/sqlite_helper.dart';
import 'package:wesafe/widgets/showTitle.dart';

import 'myservice.dart';

class PinCodeAuthen extends StatefulWidget {
  final UserModel user_model;
  PinCodeAuthen({@required this.user_model});
  @override
  _PinCodeAuthenState createState() => _PinCodeAuthenState();
}

class _PinCodeAuthenState extends State<PinCodeAuthen> {
  TextEditingController _textEditingController = TextEditingController();
  UserModel userModel;

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '123456' == _textEditingController.text;
    _verificationNotifier.add(isValid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.user_model;
  }

  @override
  Widget build(BuildContext context) {
    return buildPinCode();
  }

  MaterialApp buildPinCode() {
    return MaterialApp(
      title: 'pincode',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.primart,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShowTitle(
                  title: 'PINCODE',
                  index: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [buildPinCodeTextField()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSignIn(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PasscodeScreen buildPasscodeScreen() {
    return PasscodeScreen(
      title: Text('PINCODE'),
      passwordEnteredCallback: _onPasscodeEntered,
      cancelButton: Text('CANCEL'),
      deleteButton: Text('DELETE'),
      shouldTriggerVerification: _verificationNotifier.stream,
    );
  }

  Widget buildPinCodeTextField() {
    double winsize = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(left: 50),
      child: Row(
        children: [
          PinCodeTextField(
            pinBoxWidth: winsize * 0.09, //40
            pinBoxHeight: winsize * 0.1,
            autofocus: true,
            controller: _textEditingController,
            maxLength: 6,
            highlight: true,
            hasUnderline: true,
            hideCharacter: true,
            pinBoxColor: MyConstant.primart,
            highlightPinBoxColor: MyConstant.primart,
            onDone: (text) {
              print(_textEditingController.text);
            },
            highlightColor: MyConstant.primart,
            defaultBorderColor: MyConstant.primart,
            hasTextBorderColor: MyConstant.primart,
            maskCharacter: '⚡',
          ),
          IconButton(
            icon: Icon(Icons.backspace_sharp),
            onPressed: () {
              _textEditingController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget buildSignIn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();

          if (preferences.getString('PINCODE') == null) {
            preferences.setString(
                MyConstant.keyPincode, _textEditingController.text);
            userModel.result.pincode = _textEditingController.text;
            DateTime now = new DateTime.now();
            SQLiteUserModel sqLiteUserModel = SQLiteUserModel(
                deptName: userModel.result.dEPTNAME == null
                    ? ""
                    : userModel.result.dEPTNAME.replaceAll('/', ' '),
                firstName: userModel.result.fIRSTNAME,
                lastName: userModel.result.lASTNAME,
                createdDate: now.toString(),
                leaderName: userModel.result.learderName,
                pincode: _textEditingController.text,
                ownerID: checkIntList(userModel.result.ownerID),
                ownerName: userModel.result.ownerName == null
                    ? ""
                    : userModel.result.ownerName.replaceAll('/', ' '),
                position: "",
                teamName: userModel.result.tEAM,
                userID: userModel.result.eMPLOYEEID,
                leaderId: userModel.result.learderID.toString(),
                canApprove: userModel.result.canApprove.toString(),
                ownerDesc: checkIntList(userModel.result.ownerIDDesc),
                rsg: userModel.result.rEGIONCODE.toString(),
                userRole: userModel.result.userRole.toString());

            SQLiteHelper().insertUserDatebase(sqLiteUserModel);

            //SQLiteHelper().insertUserDatebase(userModel);

            insertStationInfo();

            if (userModel.result.ownerID.length > 1) {
              routeToMultiOwner(userModel, sqLiteUserModel);
            } else {
              routeToMainMenu(sqLiteUserModel);
            }
          } else {
            List<SQLiteUserModel> models = [];
            await SQLiteHelper().readUserDatabase().then((result) {
              if (result == null) {
              } else {
                models = result;
                SQLiteUserModel sqLiteUserModel = SQLiteUserModel();
                for (var item in models) {
                  sqLiteUserModel = SQLiteUserModel(
                    deptName: item.deptName,
                    createdDate: item.createdDate,
                    firstName: item.firstName,
                    lastName: item.lastName,
                    leaderName: item.leaderName,
                    ownerID: item.ownerID,
                    ownerName: item.ownerName,
                    pincode: item.pincode,
                    position: item.position,
                    teamName: item.teamName,
                    userID: item.userID,
                    userRole: item.userRole,
                    rsg: item.rsg,
                    ownerDesc: item.ownerDesc,
                    canApprove: item.canApprove,
                    leaderId: item.leaderId,
                  );
                } //for

                if (sqLiteUserModel.pincode.trim() ==
                    _textEditingController.text.trim()) {
                  routeToMainMenu(sqLiteUserModel);
                } else {
                  normalDialog(context, "เตือน", "PINCODE ไม่ถูกต้อง");
                }
              }
            });
          }
        },
        style: ElevatedButton.styleFrom(primary: MyConstant.primart),
        child: Text('เข้าสู่ระบบ'),
      ),
    );
  }

  String checkIntList(List<String> list) {
    List<String> newList = [];
    for (int i = 0; i < list.length; i++) {
      newList.add(list[i].replaceAll('/', '').replaceAll(' ', '').toString());
    }

    return newList.toString().replaceAll("[", "").replaceAll("]", "");
  }

  Future<Null> clearSharedPeference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void routeToMainMenu(SQLiteUserModel userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenu(
          userModel: userModel,
          ownerId: userModel.ownerID.substring(0,1),
        ),
      ),
    );
  }

  void routeToMultiOwner(UserModel userModel, SQLiteUserModel sqLiteUserModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Myservice(
          user_model: userModel,
          sqliteeUserModel: sqLiteUserModel,
        ),
      ),
    );
  }

  Future<void> insertStationInfo() async {
    print("########  insertStationInfo()");
    MastStationModel mastStationModel;
    //try {
      /*******
      * 

      HttpLink link = HttpLink(
  uri: 'https://api.github.com/graphql',
  headers: <String, String>{
    'Authorization': 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    'Content-Type': 'application/json; charset=utf-8',
   },
);

      */

      /*
      final client = HttpClient();

      final request = await client
          .postUrl(Uri.parse("${MyConstant.webService}WeSafe_SelectStation"));
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        "application/json;charset=UTF-8",
      );
      request.write('{"strMsg": "Station"}');

      final response = await request.close();
      response.transform(utf8.decoder).listen(
        (contents) {
          //contents = contents.replaceAll("[{", "{").replaceAll("}]", "}");
          if (contents.contains('Error')) {
            contents = contents.replaceAll("[", "").replaceAll("]", "");
            normalDialog(context, 'Error', contents);
          } else {
            mastStationModel = MastStationModel.fromJson(json.decode(  contents    ));
          } //else
        },
      );
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }

    SQLiteStationModel _sqLiteStationModel;
    int count;
    for (var item in mastStationModel.result) {
      count++;
      _sqLiteStationModel = SQLiteStationModel(
        id: count,
        province: item.stationProvince,
        regionCode: "",
        regionName: item.stationPEA,
        stationId: item.stationID,
        stationName: item.stationName,
      );
      //SQLiteHelper().insertStation(_sqLiteStationModel);
    }

*/




    SQLiteStationModel sqLiteStationModel = SQLiteStationModel(
      id: 1,
      province: "นครปฐม",
      regionCode: "I",
      regionName: "กฟก.3",
      stationId: "S0001",
      stationName: "สถานีไฟฟ้า นครปฐม",
    );
    SQLiteHelper().insertStation(sqLiteStationModel);
    sqLiteStationModel = SQLiteStationModel(
      id: 2,
      province: "กาญจนบุรี",
      regionCode: "I",
      regionName: "กฟก.3",
      stationId: "S0002",
      stationName: "สถานีไฟฟ้า กาญจนบุรี",
    );
    SQLiteHelper().insertStation(sqLiteStationModel);
    sqLiteStationModel = SQLiteStationModel(
      id: 2,
      province: "กาญจนบุรี",
      regionCode: "I",
      regionName: "กฟก.3",
      stationId: "S0003",
      stationName: "อื่นๆ",
    );
    SQLiteHelper().insertStation(sqLiteStationModel);
    sqLiteStationModel = SQLiteStationModel(
      id: 3,
      province: "เชียงใหม่",
      regionCode: "A",
      regionName: "กฟน.1",
      stationId: "S0005",
      stationName: "สถานีไฟฟ้า เชียงใหม่",
    );
    SQLiteHelper().insertStation(sqLiteStationModel);

    sqLiteStationModel = SQLiteStationModel(
      id: 4,
      province: "ยะลา",
      regionCode: "L",
      regionName: "กฟต.1",
      stationId: "S0007",
      stationName: "สถานีไฟฟ้า ยะลา",
    );
    SQLiteHelper().insertStation(sqLiteStationModel);
  }
}
