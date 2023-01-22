import 'package:flutter/material.dart';
import 'package:zi_yu_job/MyWidget.dart';
import 'package:zi_yu_job/module/ClipboardModule.dart';
import 'package:zi_yu_job/module/FastTxtModule.dart';
import 'package:zi_yu_job/module/FileModule.dart';
import 'package:zi_yu_job/module/LoginModule.dart';
import 'AbstractModule.dart';


class WidgetManage{

  // static final WidgetManage manage=WidgetManage();

  ///保存的所有模块
  static Map<String,MyWidget> widgets={};

  static ContentWidgets contentWidgets=ContentWidgets();

  static void initContentWidgets(){
    // contentWidgets=ContentWidgets();
  }

  /// 注册所有模块
  static void scanWidgets(){
    AbstractModule login=LoginModule();
    login.registerModule();

    AbstractModule file=FileModule();
    file.registerModule();

    AbstractModule fastTxt=FastTxtModule();
    fastTxt.registerModule();

    AbstractModule clipBoard=ClipboardModule();
    clipBoard.registerModule();

    initContentWidgets();
  }
}


class ContentWidgets extends StatefulWidget{
  Content content=Content();

  @override
  State<StatefulWidget> createState() => content;
}

///右边的内容部分显示
class Content extends State<StatefulWidget> {
  ///当前选择的内容
  static String _selectedIndex = "登录";

  ///加载所有模块的内容，并对非选择的内容进行隐藏
  ///widget一旦脱离树，就会执行销毁
  List<Offstage> getOffstages(){
    List<Offstage> returnData=[];
    WidgetManage.widgets.forEach((key, value) {
      returnData.add(
        Offstage(
          offstage: key!=_selectedIndex,
          child: value,
        )
      );
    });
    return returnData;
  }
  ///提供方法供菜单栏选择页面
  void changeWidget(String index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: getOffstages());
  }
}