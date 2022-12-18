import 'package:flutter/material.dart';

class Style{

  static Color fontMenuColor=const Color(0xffa2a2a2);



  static FontWeight fontMenuW=FontWeight.w400;

  static double fontSize=15;

  // static Color choiceBtn=Color(0xffffffff);
  static Color choiceBtn=const Color(0xfffafafa);

  static Color unchoiceBtn=const Color(0xfff3f3f3);

  static Color unUseBtn=const Color(0xffcccccc);

  static Color bgColor =const Color(0xfffafafa);

  //菜单栏样式
  static TextStyle menuStyle() {
    return TextStyle(
      fontSize: Style.fontSize,
      fontWeight: Style.fontMenuW,
      color: Style.fontMenuColor,
    );
  }

}