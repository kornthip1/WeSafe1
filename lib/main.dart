import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/pincode.dart';
import 'package:wesafe/utility/sqlite_helper.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/mainMenu': (BuildContext context) => PinCodeAuthen(),
};

String initialRoute;

Future<Null> main() async {
  SQLiteHelper sqLiteHelperWorkList = new SQLiteHelper();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String pincode = preferences.getString('PINCODE');
  if (pincode == null) {
    sqLiteHelperWorkList.initailDatabase();
    initialRoute = '/authen';
    runApp(MyApp());
  }else{
  initialRoute = '/mainMenu';
    runApp(MyApp());
    // goto pincode
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'kanit'),
    );
  }
}
