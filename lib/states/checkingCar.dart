import 'package:flutter/material.dart';
import 'package:wesafe/models/sqliteUserModel.dart';
import 'package:wesafe/widgets/showDrawer.dart';
import 'package:wesafe/widgets/showTitle.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckingCar extends StatefulWidget {
  final SQLiteUserModel userModel;
  CheckingCar({@required this.userModel});

  @override
  State<CheckingCar> createState() => _CheckingCarState();
}

class _CheckingCarState extends State<CheckingCar> {
  WebViewController _controller;

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
          title: ShowTitle(title: "ตรวจสอบยานพาหนะ", index: 3),
        ),
        drawer: ShowDrawer(userModel: widget.userModel),
        body: Center(
          child: WebView(
            initialUrl:
                'https://wesafe.pea.co.th/car/index.php/validate/index/${widget.userModel.rsg}/${widget.userModel.userID}/',
            // initialUrl:
            //     'https://wesafe.pea.co.th/checkcar/?trsg=${widget.userModel.rsg}&empCode=${widget.userModel.userID}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
          ),
        ),
      ),
    );
  }
}
