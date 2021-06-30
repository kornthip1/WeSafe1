import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/utility/my_constain.dart';
import 'package:wesafe/widgets/showTitle.dart';

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
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              //clearSharedPeference();
              print("#### usermodel  : ${userModel.result.pincode}");
             

               

            },
            style: ElevatedButton.styleFrom(primary: MyConstant.primart),
            child: Text('เข้าสู่ระบบ'),
          ),
        
        ],
      ),
    );
  }

  Future<Null> clearSharedPeference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
