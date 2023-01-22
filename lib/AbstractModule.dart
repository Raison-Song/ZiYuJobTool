import 'package:flutter/material.dart';
import 'package:zi_yu_job/MyWidget.dart';
import 'package:zi_yu_job/WidgetManage.dart';

///抽象模块
abstract class AbstractModule extends State<StatefulWidget>{
  ///模块名
  abstract String moduleName;

  ///模块图标
  abstract IconData icon;

  ///模块描述
  abstract String moduleDescription;

  ///模块作者
  abstract String moduleCreator;

  ///向WidgetManage注册模块
  void registerModule(){
    // print(this);

    WidgetManage.widgets.putIfAbsent(moduleName, () => MyWidget(this));
  }

}