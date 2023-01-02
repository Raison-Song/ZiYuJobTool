
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zi_yu_job/component/Content.dart';

import '../../Main.dart';
import '../../util/SqliteUtil.dart';
import 'package:flutter/material.dart' hide MenuItem;

import 'GetData.dart';
class Popup{

  //弹出窗-新建文件夹
  Future<void> createFloder(String preFolder) async {
    return showDialog<void>(
      context: getContentWidget.getFileWidget().getContext(),
      barrierDismissible: true, // 点击任意处取消

      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                autofocus: true,
                maxLength: 14,
                decoration: const InputDecoration(labelText: "创建新文件夹"),
                onSubmitted: (value) {
                  addNewFolder(preFolder, value);
                  Navigator.pop(context);
                  GetData().updateFileTree(getContentWidget.getFileWidget().getChoiceGroup());
                },
              );
            },
          ),
        );
      },
    );
  }
  //弹出窗-增加组
  Future<void> creatNewGroup() async {
    return showDialog<void>(
      context: getContentWidget.getFileWidget().getContext(),
      barrierDismissible: true, // 点击任意处取消

      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                autofocus: true,
                maxLength: 14,
                decoration: const InputDecoration(labelText: "创建新组"),
                onSubmitted: (value) {
                  addNewGroup(value);
                  Navigator.pop(context);
                  getContentWidget.getFileWidget().updateGroups();
                },
              );
            },
          ),
        );
      },
    );
  }

  //弹出窗-重命名组
  Future<void> renameGroup(String oldGroupName) async {
    return showDialog<void>(
      context: getContentWidget.getFileWidget().getContext(),
      barrierDismissible: true, // 点击任意处取消

      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                autofocus: true,
                maxLength: 14,
                decoration: InputDecoration(labelText: "重命名组:$oldGroupName"),
                onSubmitted: (value) {
                  rename(value,oldGroupName);
                  Navigator.pop(context);
                  getContentWidget.getFileWidget().updateGroups();
                },
              );
            },
          ),
        );
      },
    );
  }

  //重命名组
  rename(String newGroupName,String oldGroupName) async {
    var db = await DBManager().getDatabase();
    await db.update("groups",
        {
          "group_name":newGroupName
        },
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), oldGroupName]);

    await db.update("folder",
        {
          "group_name":newGroupName
        },
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), oldGroupName]);

    await db.update("folder_file",
        {
          "group_name":newGroupName
        },
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), oldGroupName]);
  }

  Future<void> addNewFolder(String preFolder, String newFolderName) async {
    var db = await DBManager().getDatabase();
    await db.insert("folder", {
      //id规则:时间戳+userid+5位随机数
      "id": "${DateTime.now().millisecondsSinceEpoch}u"
          "${Main.getUser()}r"
          "${Random.secure().nextInt(100000).toString().padLeft(5, '0')}",
      "folder_name": newFolderName,
      "before_folder_name": preFolder,
      "group_name": getContentWidget.getFileWidget().getChoiceGroup(),
      "user_id": Main.getUser()
    });
    //db.close();
  }

  Future<void> addNewGroup(String newGroupName) async {
    var db = await DBManager().getDatabase();

    await db.insert("groups", {
      //id规则:时间戳+userid+5位随机数
      "id": "${DateTime.now().millisecondsSinceEpoch}u"
          "${Main.getUser()}r"
          "${Random.secure().nextInt(100000).toString().padLeft(5, '0')}",
      "user_id": Main.getUser(),
      "group_name": newGroupName
    });
    //db.close();
  }
}