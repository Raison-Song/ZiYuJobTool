///内容页
import 'package:flutter/material.dart';
import 'package:zi_yu_job/view/Clipboard.dart';
import 'package:zi_yu_job/view/FastTxt.dart';
import 'package:zi_yu_job/view/Login.dart';
import 'package:zi_yu_job/view/ToDo.dart';

import '../view/File.dart';

class getContentWidget {
  //全局Content
  static final ContentWidget contentWidget = ContentWidget();

  static final LoginWidget _loginWidget = LoginWidget();
  static final FileWidget _fileWidget = FileWidget();
  static final ClipboardWidget _clipboardWidget = ClipboardWidget();
  static final FastTxtWidget _fastTxtWidget = FastTxtWidget();
  static final TodoWidget _todoWidget = TodoWidget();

  static Widget getWidget() {
    return contentWidget;
  }

  static void changeWidget(int index) {
    contentWidget.getContent().changeWidget(index);
  }

  static FileWidget getFileWidget(){
    return _fileWidget;
  }

  static void updateFileContent(){
    _fileWidget.updateContent();
  }

  static String getChoiceGroup(){
    return  _fileWidget.getChoiceGroup();
  }
}

class ContentWidget extends StatefulWidget {
  final _content = Content();

  Content getContent() {
    return _content;
  }

  @override
  State<StatefulWidget> createState() => getContent();
}

class Content extends State<ContentWidget> {

  static int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Offstage(
        offstage: _selectedIndex != 1,
        child: getContentWidget._loginWidget,
      ),
      Offstage(
        offstage: _selectedIndex != 2,
        child: getContentWidget._fileWidget,
      ),
      Offstage(
        offstage: _selectedIndex != 3,
        child: getContentWidget._clipboardWidget,
      ),
      Offstage(
        offstage: _selectedIndex != 4,
        child: getContentWidget._fastTxtWidget,
      ),
      Offstage(
        offstage: _selectedIndex != 5,
        child: getContentWidget._todoWidget,
      ),
    ]);
  }

  //提供方法供菜单栏选择页面
  void changeWidget(int index) {
    setState(() {
      _selectedIndex = index;
      //废弃的切换页面方式，坑点：widget一旦脱离树，就会执行销毁
      // switch (index) {
      //   case 1:
      //     content = getContentWidget._loginWidget;
      //     break;
      //   case 2:
      //     print(getContentWidget._fileWidget);
      //     content = getContentWidget._fileWidget;
      //     break;
      //   case 3:
      //     content = getContentWidget._clipboardWidget;
      //     break;
      //   case 4:
      //     content = getContentWidget._fastTxtWidget;
      //     break;
      //   case 5:
      //     content = getContentWidget._todoWidget;
      //     break;
      // }
    });
  }
}
