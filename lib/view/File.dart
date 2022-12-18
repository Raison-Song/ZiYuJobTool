import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zi_yu_job/component/file/FilesTree.dart';
import '../Main.dart';
import '../component/file/Content.dart';
import '../config/Style.dart';
import '../config/file/Style.dart';
import '../util/SqliteUtil.dart';

class FileWidget extends StatefulWidget {
  final File file = File();

  updateGroups() {
    file.updateGroups();
  }

  updateContent(){
    file.updateContent();
  }

  String getChoiceGroup(){
    return file.choicedGroup;
  }

  @override
  State<StatefulWidget> createState() => file;
}

class File extends State<FileWidget> {
  final String _noChoiceFile = "";

  //当前选中的文件夹或文件
  String choiceFile = "";
  String choicedGroup="";
  //存放文件
  fileTree files=fileTree();
  //存放组名
  List<String> _groups = [];
//存放内容
  Widget filesContent=FileContent().getFileContent();
  // void initState() {
  //   super.initState();
  //   //注册一个回调函数yourCallback
  //   WidgetsBinding.instance.addPostFrameCallback((_) => updateGroups());
  // }



  @override
  Widget build(BuildContext context) {
    return Container(
        color: Style.bgColor,
        child: Column(
          children: [
            //头部组选择
            Row(
              children: getGroupsBtn(),
            ),
            //不同组内容
            Expanded(child: filesContent)
          ],
        ));
  }

  void openFile(String filename) {
    var shell = Shell();
    shell.run("C:\\Users\\33041\\Desktop\\毕业设计.docx");
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
    if(choicedGroup!=groupName){
      //未选中的
      return TextButton(onPressed: () {choiceGroup(groupName);}, child: Text(
        groupName,style: FileStyle().getUnChoiceFont(),));
    }
    return TextButton(onPressed: () {}, child: Text(
        groupName,style: FileStyle().getChoiceFont()));
  }

  //切换组
  void choiceGroup(String groupName){
    //将组名保存至choicedGroup
    choicedGroup=groupName;
    //重构组
    updateGroups();
  }



  //更新组显示
  updateGroups() async {
    print("更新组显示");

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
      filesContent=FileContent().getFileContent(groupName: choicedGroup);
    });
  }
}
