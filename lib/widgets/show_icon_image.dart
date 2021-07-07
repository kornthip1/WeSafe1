import 'package:flutter/material.dart';
import 'package:wesafe/utility/my_constain.dart';

class ShowIconImage extends StatelessWidget {
  final String fromMenu;
  ShowIconImage({@required this.fromMenu});

  @override
  Widget build(BuildContext context) {
    return fromMenu == "mainO"
        ? Image.asset(MyConstant.imageOutage)
        : fromMenu == "mainH"
            ? Image.asset(MyConstant.imageHotline)
            : fromMenu == "mainOther"
                ? Image.asset(MyConstant.imageOtherWork)
                : Image.asset(MyConstant.man);
  }
}
