// 一般来说, app没有使用Scaffold的话，会有一个黑色的背景和一个默认为黑色的文本颜色。
// 这个app，将背景色改为了白色，并且将文本颜色改为了黑色以模仿Material app

import 'package:flutter/material.dart';
import 'package:zi_yu_job/WidgetManage.dart';
import 'package:zi_yu_job/module/LoginModule.dart';

import 'package:zi_yu_job/util/SqliteUtil.dart';

import 'MenuWidget.dart';
import 'MyWidget.dart';
import 'module/FileModule.dart';
import 'module/fileModule/GetData.dart';

class Main {
  static const String _noUser = "NoUser";

  //登陆用户id
  static String _user = _noUser;
  //文件缓存位置
  static String _folderAddress="";

  static final MenuWidget _menu = MenuWidget();

  static Future<void> initMain() async {

    WidgetManage.scanWidgets();

    ///查询是否有登陆
    var db = await DBManager().getDatabase();
    var getUser = await db.query("users", where: "is_use=?", whereArgs: [1]);
    print("（初始化）查询到上次登陆的用户：$getUser");
    //如果登陆账户只有一个
    if (getUser.length == 1) {

      await Main.setUser(getUser[0]["id"].toString());

      _folderAddress=getUser[0]["folder_address"].toString();

      print("跳转到文件管理页面");
      //跳转到文件管理页面
      Main.getMenu().menu.choice("文件管理");
      WidgetManage.contentWidgets.content.changeWidget("文件管理");

      //文件页面初始化
      GetData().updateFileTree("main");
      //刷新登录页面
      LoginModule loginModule= (WidgetManage.widgets.putIfAbsent("用户信息",
              () => MyWidget(LoginModule())).abstractModule as LoginModule);
      loginModule.update();

    } else if (getUser.length > 1) {
      //将所有用户下线
      db.update("users", {'is_use': '0'});
      //跳转到登陆页面
      Main.getMenu().menu.choice("用户信息");
      WidgetManage.contentWidgets.content.changeWidget("用户信息");

    }else{
      //跳转到登陆页面
      Main.getMenu().menu.choice("用户信息");
      WidgetManage.contentWidgets.content.changeWidget("用户信息");
    }
    // FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
    //         () => MyWidget(FileModule())).abstractModule as FileModule);
    // fileModule.updateGroups();
    //db.close();
  }

  static bool isLogin() {
    return _noUser != _user;
  }

  //更新登陆用户
  static Future<void> setUser(String user) async {
    var db = await DBManager().getDatabase();
    //将其他用户下线
    db.update("users", {'is_use': '0'}, where: "id!=?", whereArgs: [user]);
    _user = user;
    _menu.menu.uploadLoginState();
  }

  static String getUser() {
    return _user;
  }
  ///注销用户
  static void logoutUser() {
    _user = _noUser;
    _menu.menu.uploadLoginState();
  }

  static void setFolderAddress(String add){
    _folderAddress=add;
  }

  static String getFolderAddress(){
    return _folderAddress;
  }

  static MenuWidget getMenu() {
    return _menu;
  }
}

Future<void> main() async {
  //初始化=>获取登陆信息
  Main.initMain();

  //进行页面渲染
  runApp(
    MaterialApp(
      home: Scaffold(
          body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Main.getMenu(),
            Expanded(child: WidgetManage.contentWidgets)
      ])),
    ),
  );
}
