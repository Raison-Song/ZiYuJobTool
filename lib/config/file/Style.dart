import 'package:flutter/material.dart';

class FileStyle{

  static Color white=Colors.white;
  //搜索文字样式
  TextStyle getChoiceFont() {
    return const TextStyle(
        color: Color(0xff3877bd),

      fontWeight: FontWeight.normal
    );
  }

  TextStyle getUnChoiceFont() {
    return const TextStyle(
        color: Color(0xffb1ccef),
        fontWeight: FontWeight.normal
    );
  }


  TextStyle getFileFont(){
    return const TextStyle(
        color: Color(0xff000000),
        fontWeight: FontWeight.normal
    );
  }
}