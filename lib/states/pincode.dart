import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/states/mainMenu.dart';
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
    return Container(
      margin: EdgeInsets.only(left: 50),
      child: Row(
        children: [
          PinCodeTextField(
            pinBoxWidth: 40,
            pinBoxHeight: 40,
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
      
        child :
          ElevatedButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
             
              if (preferences.getString('PINCODE') == null) {
                preferences.setString(
                    MyConstant.keyPincode, _textEditingController.text);
                userModel.result.pincode = _textEditingController.text;
                DateTime now = new DateTime.now();
                SQLiteUserModel sqLiteUserModel = SQLiteUserModel(
                    deptCode: userModel.result.dEPTNAME,
                    firstName: userModel.result.fIRSTNAME,
                    lastName: userModel.result.lASTNAME,
                    createdDate: now.toString(),
                    leaderName: userModel.result.learderName,
                    pincode: _textEditingController.text,
                    owerID: userModel.result.ownerID[0],
                    owerName: userModel.result.ownerName,
                    position: "",
                    teamName: userModel.result.tEAM,
                    userID: userModel.result.eMPLOYEEID);

                SQLiteHelper().insertUserDatebase(sqLiteUserModel);

               
                if (userModel.result.ownerID.length > 1) {
                    routeToMultiOwner(userModel,sqLiteUserModel);
                } else {
                  routeToMainMenu(sqLiteUserModel);
                }


              } else {
                List<SQLiteUserModel> models = [];
                await SQLiteHelper().readUserDatabase().then((result) {
                  if (result == null) {
                  } else {
                    models = result;
                    print(">>>>>>>  result  : ${result}");
                    SQLiteUserModel sqLiteUserModel = SQLiteUserModel();
                    for (var item in models) {
                      SQLiteUserModel sqLiteUserModel = SQLiteUserModel(
                          deptCode: item.deptCode,
                          createdDate: item.createdDate,
                          firstName: item.firstName,
                          lastName: item.lastName,
                          leaderName: item.leaderName,
                          owerID: item.owerID,
                          owerName: item.owerName,
                          pincode: item.pincode,
                          position: item.position,
                          teamName: item.teamName,
                          userID: item.userID);
                    } //for
                    print(">>>>>>>  sqLiteUserModel  : ${sqLiteUserModel.owerID}");
                    routeToMainMenu(sqLiteUserModel);
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(primary: MyConstant.primart),
            child: Text('เข้าสู่ระบบ'),
          ),
       
     
    );
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
          ownerId: userModel.owerID,
        ),
      ),
    );
  }

    void routeToMultiOwner(UserModel userModel,SQLiteUserModel sqLiteUserModel) {
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

}
