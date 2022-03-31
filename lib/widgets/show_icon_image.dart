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
                : fromMenu == "image"
                    ? Image.asset(MyConstant.image)
                    : fromMenu == "mainO2"
                        ? Image.asset(MyConstant.imageMenuO_2)
                        : fromMenu == "mainO3"
                            ? Image.asset(MyConstant.imageMenuO_3)
                            : fromMenu == "mainO4"
                                ? Image.asset(MyConstant.imageMenuO_4)
                                : fromMenu == "mainH1" 
                                ? Image.asset(MyConstant.imageMenuH_1)
                                : Image.asset(MyConstant.man);
  }
}
