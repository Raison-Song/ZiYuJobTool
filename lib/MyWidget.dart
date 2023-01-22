import 'package:flutter/cupertino.dart';
import 'package:zi_yu_job/AbstractModule.dart';

class MyWidget extends StatefulWidget{

  AbstractModule abstractModule;

  MyWidget(this.abstractModule, {super.key});

  @override
  State<StatefulWidget> createState() => abstractModule;

}