import 'dart:math';

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zi_yu_job/component/file/FilesTree.dart';
import '../Main.dart';
import '../component/file/Content.dart';
import '../component/file/GetData.dart';
import '../config/Style.dart';
import '../config/file/Style.dart';
import '../util/SqliteUtil.dart';

class FileWidget extends StatefulWidget {
  final File file = File();

  updateGroups() {
    file.updateGroups();
  }

  updateContent() {
    file.updateContent();
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Style.bgColor,
        child: Column(
          children: [
            //头部组选择
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Scrollbar(
                    thickness: 3.0,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(4),
                      scrollDirection: Axis.horizontal,
                      primary: true,
                      child: Row(
                        children: getGroupsBtn()
                            +[TextButton(onPressed: (){_showMyDialog();}, child:
                            const Icon(Icons.add,color: Color(0xffb1ccef),))],
                      ),
                    )
                )
            ),
            //不同组内容
            Expanded(child: filesContent)
          ],
        )
    );
  }

  void openFile(String filename) {
    var shell = Shell();
    shell.run("C:\\Users\\33041\\Desktop\\毕业设计.docx");
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(autofocus: true,maxLength: 14,
                onSubmitted: (value) {
                  addNewGroup(value);
                  Navigator.pop(context);
                  updateGroups();
              },);
            },
          ),
        );
      },
    );
  }

  Future<void> addNewGroup(String newGroupName) async {
    var db = await DBManager().getDatabase();

    await db.insert("groups",
        {
          //id规则:时间戳+userid+5位随机数
          "id":"${DateTime.now().millisecondsSinceEpoch}u"
              "${Main.getUser()}r"
              "${Random.secure().nextInt(100000)
              .toString().padLeft(5, '0')}",
          "user_id":Main.getUser(),
          "group_name":newGroupName
        });
    db.close();
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
    if (choicedGroup != groupName) {
      //未选中的
      return TextButton(
          onPressed: () {
            choiceGroup(groupName);
          },
          child: Text(
            groupName,
            style: FileStyle().getUnChoiceFont(),
          ));
    }
    return TextButton(
        onPressed: () {
          choiceGroup(groupName);
        },
        child: Text(groupName, style: FileStyle().getChoiceFont()));
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
    db.close();

    List<String> groupsList = [];
    groupsList.add("上传时间");
    groupsList.add("修改时间");
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
