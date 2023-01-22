import 'package:flutter/material.dart';

class MenuStyle{

  static Color fontMenuColor=const Color(0xffa2a2a2);

  static FontWeight fontMenuW=FontWeight.w400;

  static double fontSize=15;

  // static Color choiceBtn=Color(0xffffffff);
  static Color chosenBtn=const Color(0xfffafafa);

  static Color unChosenBtn=const Color(0xfff3f3f3);

  static Color unUseBtn=const Color(0xffcccccc);

  static Color bgColor =const Color(0xfffafafa);

  //菜单栏样式
  static TextStyle menuStyle() {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontMenuW,
      color: fontMenuColor,
    );
  }

}