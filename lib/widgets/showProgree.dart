import 'package:flutter/material.dart';
import 'package:wesafe/utility/my_constain.dart';

class ShowProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.grey[300],
      color: MyConstant.primart,
      strokeWidth: 10,
    ));
  }
}
