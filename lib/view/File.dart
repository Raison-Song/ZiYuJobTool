import 'dart:ui';
import 'package:flutter/gestures.dart';

import 'package:sqflite/sqflite.dart';
import 'package:zi_yu_job/component/file/FilesTree.dart';
import 'package:zi_yu_job/component/file/Popup.dart';
import 'package:zi_yu_job/component/file/ShowContext.dart';
import '../Main.dart';
import '../component/file/Content.dart';
import '../component/file/GetData.dart';
import '../config/Style.dart';
import '../config/file/Style.dart';
import '../util/SqliteUtil.dart';
import 'package:flutter/material.dart' hide MenuItem;

class FileWidget extends StatefulWidget {

  final File file = File();

  updateGroups() {
    file.updateGroups();
  }

  updateContent() {
    file.updateContent();
  }

  choiceGroup(String groupName){
    file.choiceGroup(groupName);
  }

  String getChoiceGroup() {
    return file.choicedGroup;
  }

  Map<String, fileTree> getFilesTrees() {
    return file.filesTrees;
  }

  setFilesTrees(Map<String, fileTree> value) {
    file.filesTrees = value;
  }

  Map<String, List<String>> getFilesTreesIsSpread() {
    return file.filesTreesIsSpread;
  }

  setFilesTreesIsSpread(Map<String, List<String>> value) {
    file.filesTreesIsSpread = value;
  }

  Map<String, String> getAllFiles() {
    return file.allFiles;
  }

  setAllFiles(Map<String, String> value) {
    file.allFiles = value;
  }

  BuildContext getContext(){
    return file.context;
  }

  @override
  State<StatefulWidget> createState() => file;
}

class File extends State<FileWidget> {
  //当前选中的文件夹或文件
  String choiceFile = "";
  String choicedGroup = "main";
  //存放文件
  fileTree files = fileTree();
  //存放组名
  List<String> _groups = [];
  //存放显示内容（文件树）
  Widget filesContent = const Text("正在加载");

  //存放文件目录树<组，树>
  Map<String, fileTree> filesTrees = {};

  //记录展开的目录
  Map<String, List<String>> filesTreesIsSpread = {};

  //所有文件
  Map<String, String> allFiles = {};

  //右键上下文是否展开
  bool _openContext = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Style.bgColor,
        child: Column(
          children: [
            //头部组选择
            SizedBox(
                width: MediaQuery.of(context).size.width,
                //滚动条
                child: Scrollbar(
                    //滚动条粗细
                    thickness: 3.0,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(4),
                      //水平
                      scrollDirection: Axis.horizontal,
                      primary: true,
                      child: Row(
                        children: getGroupsBtn() +
                            [
                              TextButton(
                                  onPressed: () {
                                    //打开弹出框
                                    Popup().creatNewGroup();
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xffb1ccef),
                                  ))
                            ],
                      ),
                    ))),
            //不同组内容filesContent
            Expanded(
                child: Listener(
              onPointerDown: (e) {
                _openContext = e.kind == PointerDeviceKind.mouse &&
                    e.buttons == kSecondaryMouseButton;
                setState(() {});
              },
              onPointerUp: (e) {
                if (_openContext) {
                  ShowContext().showContext();
                  _openContext = false;
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: filesContent,
              ),
            ))
          ],
        ));
  }

  List<Widget> getGroupsBtn() {
    List<Widget> groupsBtn = <Widget>[];
    print(_groups);
    for (int i = 0; i < _groups.length; i++) {
      groupsBtn.add(groupBtn(_groups[i]));
    }
    return groupsBtn;
  }

  //获取组按钮
  Widget groupBtn(String groupName) {
      //未选中的
      return Listener(
          onPointerDown: (e) {
            _openContext = e.kind == PointerDeviceKind.mouse &&
                e.buttons == kSecondaryMouseButton;
            setState(() {});
          },
          onPointerUp: (e) {
            if (_openContext) {
              bool disable=["上传时间","文件类型","root","main"].contains(groupName);
              ShowContext().showGroupContext(groupName,disable);
              _openContext = false;
            }
          },
          child: choicedGroup != groupName?
          TextButton(
              onPressed: () {
                choiceGroup(groupName);
              },
              child: Text(
                groupName,
                style: FileStyle().getUnChoiceFont())
          ) :
          TextButton(
              onPressed: () {
                choiceGroup(groupName);
              },
              child: Text(groupName, style: FileStyle().getChoiceFont())
          )
      );
  }

  //切换组
  void choiceGroup(String groupName) {
    //将组名保存至choicedGroup
    //如果是第二次点击，则取消选中状态
    choicedGroup = choicedGroup == groupName ? "main" : groupName;
    //重构组
    updateGroups();
    //构建文件树
    GetData().updateFileTree(groupName);
  }

  //更新组显示
  //并将文件树从数据库取出，存放在内存中
  updateGroups() async {
    Database db = await DBManager().getDatabase();
    var groups = await db
        .query("groups", where: "user_id=?", whereArgs: [Main.getUser()]);
    //db.close();

    List<String> groupsList = [];
    groupsList.add("上传时间");
    groupsList.add("文件类型");
    for (int i = 0; i < groups.length; i++) {
      groupsList.add(groups[i]["group_name"].toString());
    }
    setState(() {
      _groups = groupsList;
    });
  }

  void updateContent() {
    setState(() {
      filesContent = FileContent().getFileContent(groupName: choicedGroup);
    });
  }


}
