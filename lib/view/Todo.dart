import 'package:flutter/material.dart';

import '../config/Style.dart';

class TodoWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Todo();

}

class Todo extends State<TodoWidget> {

  @override
  Widget build(BuildContext context) {

    return  Container(

      color: Style.bgColor,

      child: Text("todo"),
    );
  }
}

