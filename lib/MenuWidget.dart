import 'package:flutter/material.dart';
import 'package:zi_yu_job/AbstractModule.dart';
import 'package:zi_yu_job/WidgetManage.dart';
import './Main.dart';
import 'MenuStyle.dart';

///左侧菜单
class MenuWidget extends StatefulWidget {
  final Menu menu = Menu();

  @override
  State<StatefulWidget> createState() => menu;
}

class Menu extends State<StatefulWidget> {
  double _btnWidth = 120;
  double _blank = 10;

  bool isLogin = Main.isLogin();

  String chosenBtn = "";

  var modulesBtnWidget = <Widget>[];

  Menu() {
    ///将所有模块加载
    WidgetManage.widgets.forEach((key, value) {
      modulesBtnWidget.add(newBtn(value.abstractModule));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: isLogin ? MenuStyle.unChosenBtn : MenuStyle.unUseBtn,
        child: AnimatedSize(
            alignment: Alignment.centerLeft,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
                width: _btnWidth,
                height: MediaQuery.of(context).size.height * 1,
                child: Column(children: [
                  Expanded(child: ListView(children: modulesBtnWidget)),
                  spreadBtn()
                ]))));
  }

  ColoredBox newBtn(AbstractModule module) {
    isLogin = Main.isLogin();
    return ColoredBox(
        color: isLogin || module.moduleName == "用户信息"
            ? chosenBtn == module.moduleName
                ? MenuStyle.chosenBtn
                : MenuStyle.unChosenBtn
            : MenuStyle.unUseBtn,
        child: (TextButton(
          onPressed: isLogin || module.moduleName == "用户信息"
              ? () {
                  choice(module.moduleName);
                  WidgetManage.contentWidgets.content
                      .changeWidget(module.moduleName);
                }
              : null,
          child: Row(
            children: [
              Icon(
                module.icon,
                color: MenuStyle.fontMenuColor,
              ),
              SizedBox(
                width: _blank,
              ),
              Text(
                _btnWidth == 40 ? "" : module.moduleName,
                style: MenuStyle.menuStyle(),
              )
            ],
          ),
        )));
  }

  void choice(String moduleName) {
    setState(() {
      chosenBtn = moduleName;
      modulesBtnWidget = [];
      WidgetManage.widgets.forEach((key, value) {
        modulesBtnWidget.add(newBtn(value.abstractModule));
      });
    });
  }

  spreadBtn() {
    return Container(
        width: _btnWidth,
        color: isLogin ? MenuStyle.unChosenBtn : MenuStyle.unUseBtn,
        child: (TextButton(
          onPressed: () => spread(),
          child: Icon(
            Icons.switch_left,
            color: MenuStyle.fontMenuColor,
          ),
        )));
  }

  spread() {
    if (_btnWidth == 40) {
      setState(() {
        _btnWidth = 120;
        _blank = 10;
      });
    } else {
      setState(() {
        _btnWidth = 40;
        _blank = 0;
      });
    }
    choice(chosenBtn);
  }

  void uploadLoginState() {
    setState(() {
      isLogin = Main.isLogin();
    });
  }
}
