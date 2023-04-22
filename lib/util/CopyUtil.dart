import 'package:flutter/services.dart';

class CopyUtil{

  static bool copy(String str){
    Clipboard.setData(ClipboardData(text: str));
    return true;
  }
}