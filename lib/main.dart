import 'package:flutter/material.dart';
import 'package:scheduled_timer/scheduled_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/models/UserModel.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/pincode.dart';
import 'package:wesafe/utility/sqlite_helper.dart';

UserModel _userModel;
final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/mainMenu': (BuildContext context) => PinCodeAuthen(
        userModels: _userModel,
      ),
};

String initialRoute;

void main() async {
  SQLiteHelper sqLiteHelperWorkList = new SQLiteHelper();
  WidgetsFlutterBinding.ensureInitialized();
  //

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String pincode = preferences.getString('PINCODE');

  if (pincode == null) {
    sqLiteHelperWorkList.initailDatabase();
    initialRoute = '/authen';
    runApp(MyApp());
  } else {
    initialRoute = '/mainMenu';
    runApp(MyApp());
    // goto pincode
  }

  // ScheduledTimer example1;
  // example1 = ScheduledTimer(
  //     id: 'example1',
  //     onExecute: () {
  //       print('Executing example1');
  //     },
  //     defaultScheduledTime: DateTime.now().add(Duration(seconds: 5)),
  //     onMissedSchedule: () {
  //       example1.execute();
  //     });
  // check : Background processes
  // Executing Dart in the Background with Flutter Plugins and Geofencing
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'kanit'),
    );
  }
}
