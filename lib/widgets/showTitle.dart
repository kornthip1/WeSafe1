import 'package:flutter/material.dart';

class ShowTitle extends StatelessWidget {
  String title;
  
  int index;

  ShowTitle({@required this.title, this.index});

  TextStyle h1Style() => TextStyle(
    fontSize: 24, 
    fontWeight: FontWeight.bold
    );

  TextStyle h2Style() => TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w700
    );

  TextStyle h3Style() => TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.normal
    );

    TextStyle h4Style() => TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w700,
    color : Colors.white
    );

    TextStyle h5Style() => TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w700,
    color : Colors.black
    );

  TextStyle h6Style() => TextStyle(
    fontSize: 10, 
    fontWeight: FontWeight.w400,
    color : Colors.black,
    
    
    );

  @override
  Widget build(BuildContext context) {
    List<TextStyle> textStyles=[h1Style(),h2Style(),h3Style(),h4Style(),h5Style(),h6Style()];
    if (index == null) {
      index = 2;      
    }
    
    return Text(
      title,
      style: textStyles[index],
    );
  }
}