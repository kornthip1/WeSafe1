import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:numeric_keyboard/numeric_keyboard.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:passcode_screen/keyboard.dart';
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
                  children: [
                    buildPinCodeTextField(),
                    buildNumericKeyboard(),
                  ],
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

  NumericKeyboard buildNumericKeyboard() {
    return NumericKeyboard(
      onKeyboardTap: _onKeyboardTap,
    );
  }

  _onKeyboardTap(String value) {
    if (_textEditingController.text.length < 6) {
      setState(() {
        _textEditingController.text = _textEditingController.text + value;
      });
    } else {
      buildNumericKeyboard();
    }
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
            hideDefaultKeyboard: true,
            pinBoxWidth: winsize * 0.09, //40
            pinBoxHeight: winsize * 0.1,
            autofocus: false,
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
          insertStationInfo();
          if (preferences.getString('PINCODE') == null) {
            preferences.setString(
                MyConstant.keyPincode, _textEditingController.text);
            userModel.result.pincode = _textEditingController.text;
            print("pincode ######  rsg  : ${userModel.result.rEGIONCODE}");
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
                  print("pincode ###### 1. rsg  : ${item.rsg}");
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
            //userModel: userModel,
            // ownerId: userModel.ownerID.substring(0, 1),
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

    try {
      final response = await http.post(
        Uri.parse('${MyConstant.webService}WeSafe_SelectStation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "{ 'strMsg' : 'Station' }",
      );

      MastStationModel mastStationModel =
          MastStationModel.fromJson(jsonDecode(response.body));

      SQLiteStationModel sqLiteStationModel;
      for (int i = 0; i < mastStationModel.result.length; i++) {
        sqLiteStationModel = SQLiteStationModel(
          id: i,
          province: mastStationModel.result[i].stationProvince,
          regionCode: "",
          regionName: mastStationModel.result[i].stationPEA,
          stationId: mastStationModel.result[i].stationID,
          stationName: mastStationModel.result[i].stationName,
        );
        SQLiteHelper().insertStation(sqLiteStationModel);
      }
    } catch (e) {
      normalDialog(context, "Error", e.toString());
    }
  }
}
