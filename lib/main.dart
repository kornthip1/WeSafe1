import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wesafe/states/authen.dart';
import 'package:wesafe/states/myservice.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/myservice': (BuildContext context) => Myservice(),
};

String initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String employedidLogin = preferences.getString('employedid');
  if (employedidLogin == null) {
    initialRoute = '/authen';
    runApp(MyApp());
  }else {
    initialRoute = '/myservice';
    runApp(MyApp());
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
