import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyConstant {
  static final String authen = 'images/LogoW.png'; //'images/WeSafe.png';
  static final String man = 'images/man.png';
  static final String image = 'images/image.png';
  static final String imageOutage = 'images/hotline.png';
  static final String imageHotline = 'images/outage.png';
  static final String imageOtherWork = 'images/other.png';

  static final String imageMenuO_2 = 'images/Outage2.png';
  static final String imageMenuO_3 = 'images/Outage3.png';
  static final String imageMenuO_4 = 'images/Outage4.png';

  static final String imageMenuH_1 = 'images/menu2.png';

  static final String keyPincode = "PINCODE";
  static final String keyUser = "USER";

  static final String nameDatabase = 'wesafe.db';
  static final String appName = 'WeSafe';
  static final String webService =
      "https://wesafe.pea.co.th/webservicemobile/api/wesafe/";

  static final String newService =
      "https://wesafe.pea.co.th/api_wesafe/index.php/";

  static final List<String> listMenu = [
    'บันทึกงานใหม่',
    'ตรวจสอบสถานะการทำงาน',
    'ประวัติการทำงาน',
    'แสดงพิกัด',
  ];

  //Color
  static final Color primart = Color.fromARGB(255, 112, 55, 133);
  static final Color floralWhite = Color.fromARGB(255, 255, 249, 244);

  static final Color outageMenu1 = Color.fromARGB(255, 240, 162, 143);
  static final Color outageMenu2 = Color.fromARGB(255, 247, 186, 136);
  static final Color outageMenu3 = Color.fromARGB(255, 114, 218, 205);
  static final Color outageMenu4 = Color.fromARGB(255, 133, 180, 199);

  static final String imgIconCheckList1 = "images/search.png";
  static final String imgIconCheckList2 = "images/camera.png";
  static final String imgIconCheckList3 = "images/pressure.png";
  static final String imgIconCheckList4 = "images/grounding.png";
  static final String imgIconCheckList5 = "images/traffic-cone.png";

  static final String imgIconHotSub1 = "images/tower.png";
  static final String imgIconHotSub2 = "images/labor-day.png";
  static final String imgIconHotSub3 = "images/electric-pole.png";
  static final String imgIconHotSub4 = "images/pressure.png";

  static final strDateNow = getDateNow();
}

String getDateNow() {
  final DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd   kk:mm').format(now);
  return formattedDate.toString();
}
