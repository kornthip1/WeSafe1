import 'package:flutter/material.dart';

class MyConstant {
  static final String authen = 'images/newLogo.jpg'; //'images/WeSafe.png';
  static final String man = 'images/man.png';
  static final String image = 'images/image.png';
  static final String imageOutage = 'images/hotline.png';
  static final String imageHotline = 'images/outage.png';
  static final String imageOtherWork = 'images/other.png';

  static final String keyPincode = "PINCODE";
  static final String keyUser = "USER";

  static final String nameDatabase = 'wesafe.db';
  static final String appName = 'WeSafe';
  static final String webService =
      "https://wesafe.pea.co.th/webservicemobile/api/wesafe/";

  static final List<String> listMenu = [
    'บันทึกงานใหม่',
    'ตรวจสอบสถานะการทำงาน',
    'ประวัติการทำงาน',
    'แสดงพิกัด',
  ];

  //Color
  static final Color primart = Color.fromARGB(255, 112, 55, 133);
  static final Color floralWhite = Color.fromARGB(255, 255, 249, 244);

  static final strDateNow = getDateNow();
}

String getDateNow() {
  final DateTime now = DateTime.now();
  return now.toString();
}
