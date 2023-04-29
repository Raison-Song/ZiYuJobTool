import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zi_yu_job/util/CopyUtil.dart';

import '../../Main.dart';
import '../../MyWidget.dart';
import '../../WidgetManage.dart';
import '../../util/SqliteUtil.dart';
import '../ClipboardModule.dart';
// import 'package:screen_text_extractor/screen_text_extractor.dart';

class ClipboardContent {
  static Future<List<Widget>> getCopyCollect() async {
    var list = <Widget>[];

    Database db = await DBManager().getDatabase();
    var dataList = await db.query("clipboard_txt",
        where: "is_collect=?", whereArgs: [1], orderBy: "id desc", limit: 500);

    for (var data in dataList) {
      list.add(GestureDetector(
          onSecondaryTapDown: (_) => delCollect(data["txt"].toString()),
          child: TextButton(
          onPressed: () => CopyUtil.copy(data["txt"].toString()),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft, // 设置按钮中的文字靠左对齐
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Text(
                data["txt"].toString(),
                style: const TextStyle(
                    color: Color(0xff000000), fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
              )
            ],
          ))));
    }

    return list;
  }

  static Widget getGroupContent() {
    return ListView();
  }

  //获取剪切板历史记录
  static Future<List<Widget>> getContent() async {
    var list = <Widget>[];

    Database db = await DBManager().getDatabase();
    var dataList = await db.query("clipboard_txt",
        where: "user_id=?",
        whereArgs: [Main.getUser()],
        orderBy: "id desc",
        limit: 500);

    for (var data in dataList) {
      list.add(GestureDetector(
          onSecondaryTapDown: (_) => addCollect(data["txt"].toString()),
          child: TextButton(
        onPressed: () => CopyUtil.copy(data["txt"].toString()),
        child: Text(
          data["txt"].toString(),
          style: const TextStyle(
              color: Color(0xff000000), fontWeight: FontWeight.normal),
          textAlign: TextAlign.left,
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft, // 设置按钮中的文字靠左对齐
        ),
      )));
    }

    return list;
  }

  static Future<void> addCollect(String data) async {
    Database db = await DBManager().getDatabase();
    await db.update("clipboard_txt",{"is_collect" : 1},where: "txt = ? and user_id=?",whereArgs: [data,Main.getUser()]);

    ClipboardModule clipboardModule= (WidgetManage.widgets.putIfAbsent("粘贴板",
            () => MyWidget(ClipboardModule())).abstractModule as ClipboardModule);
    clipboardModule.getCopyListAsync();
  }

  static Future<void> delCollect(String data) async {
    Database db = await DBManager().getDatabase();
    await db.update("clipboard_txt",{"is_collect" : 0},where: "txt = ? and user_id=?",whereArgs: [data,Main.getUser()]);

    ClipboardModule clipboardModule= (WidgetManage.widgets.putIfAbsent("粘贴板",
            () => MyWidget(ClipboardModule())).abstractModule as ClipboardModule);
    clipboardModule.getCopyListAsync();
  }

  static Future<bool> setContent(String data) async {
    Database db = await DBManager().getDatabase();
    var dataList = await db.query("clipboard_txt",
        where: "user_id=?",
        whereArgs: [Main.getUser()],
        orderBy: "id desc",
        limit: 500);
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]["txt"].toString() == data) {
        return false;
      }
    }

    await db.insert("clipboard_txt", {
      "id": "${DateTime.now().millisecondsSinceEpoch}u"
          "${Main.getUser()}r"
          "${Random.secure().nextInt(100000).toString().padLeft(5, '0')}",
      "user_id":Main.getUser(),
      "txt":data
    });

    return true;
  }
}
