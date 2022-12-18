import 'package:flutter/material.dart';

import '../config/Style.dart';

class FastTxtWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FastTxt();

}

class FastTxt extends State<FastTxtWidget> {

  @override
  Widget build(BuildContext context) {

    return new Container(

      color: Style.bgColor,
      child: Text("快速txt"),
    );
  }
}

