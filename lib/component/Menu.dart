import 'package:flutter/material.dart';
import 'package:zi_yu_job/component/Content.dart';
import 'package:zi_yu_job/config/MyIcon.dart';
import 'dart:async';
import '../Main.dart';
import '../config/Style.dart';

class MenuWidget extends StatefulWidget {
  final Menu _menu=Menu();

  void choice(int index){
    _menu.choice(index);
  }

  @override
  State<StatefulWidget> createState() => _menu;

  void changeLoginState(bool bool) {
    _menu.changeLoginState(bool);
  }
}

class Menu extends State<MenuWidget> {
  var menuFont = <String>[];
  var menuColor = <Color>[];
  var menuIcon = <IconData>[];
  double _btnWidth = 120;
  double _blank=10;

  bool isLogin=Main.isLogin();

  Menu() {
    menuFont.add("0");
    menuFont.add("用户信息");
    menuFont.add("文件管理");
    menuFont.add(" 粘贴板  ");
    menuFont.add("快速文档");
    menuFont.add("   计划   ");
    menuFont.add("");
    menuFont.add("");

    menuColor = [
      Style.unchoiceBtn,
      Style.choiceBtn,
      Style.unchoiceBtn,
      Style.unchoiceBtn,
      Style.unchoiceBtn,
      Style.unchoiceBtn,
      Style.unchoiceBtn,
      Style.unchoiceBtn
    ];
    menuIcon = [
      Icons.cabin,
      Icons.supervised_user_circle_sharp,
      Icons.folder_copy,
      Icons.file_copy,
      Icons.file_open_sharp,
      Icons.today_sharp,
      Icons.settings,
      Icons.skip_previous_outlined
    ];
  }

  @override
  Widget build(BuildContext context) {

    return ColoredBox(
        color: isLogin? Style.unchoiceBtn:Style.unUseBtn,
        child: AnimatedSize(
            alignment: Alignment.centerLeft,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
                width: _btnWidth, //you sure it should be 0.001?
                height: MediaQuery.of(context).size.height * 1,
                child: Column(children: [
                  Expanded(
                      child: ListView(children: [
                    newBtn(1),
                    newBtn(2,isLogin:isLogin),
                    newBtn(3,isLogin:isLogin),
                    newBtn(4,isLogin:isLogin),
                    newBtn(5,isLogin:isLogin),
                  ])),
                  newBtn(6),
                  newBtn(7)
                ]))));
  }

  ColoredBox newBtn(int index,{bool? isLogin}) {
    isLogin ??= true;
    return ColoredBox(
        color: isLogin? menuColor[index]:Style.unUseBtn,
        child: (TextButton(
          onPressed: isLogin? () {
            if (index == 7) {
              spread();
            } else {
              choice(index);
              getContentWidget.changeWidget(index);
            }
          }:null,
          child: Row(
            children: [
              Icon(
                menuIcon[index],
                color: Style.fontMenuColor,

              ),
              SizedBox(
                width: _blank,
              ),
              Text(
                menuFont[index],
                style: Style.menuStyle(),
              )
            ],
          ),
        )));
  }

  void choice(int which) {
    setState(() {
      for (int i = 0; i < menuColor.length; i++) {
        menuColor[i] = Style.unchoiceBtn;
      }
      menuColor[which] = Style.choiceBtn;
    });
  }

  void changeLoginState(bool _isLogin) {
    setState(() {
      isLogin=_isLogin;
    });
  }

  //更改菜单栏宽度
  void spread() {
    if (menuFont[0] == "1") {
      setState(() {
        menuFont[1] = "用户信息";
        menuFont[2] = "文件管理";
        menuFont[3] = " 粘贴板  ";
        menuFont[4] = "快速文档";
        menuFont[5] = "   计划   ";
        menuFont[0] = "0";

        _btnWidth = 120;
        _blank=10;
      });
    } else {
      setState(() {
        menuFont[1] = "";
        menuFont[2] = "";
        menuFont[3] = "";
        menuFont[4] = "";
        menuFont[5] = "";
        menuFont[0] = "1";
        _btnWidth = 40;
        _blank=0;
      });
    }
  }
}
