import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zi_yu_job/util/CopyUtil.dart';

import '../../util/SqliteUtil.dart';
// import 'package:screen_text_extractor/screen_text_extractor.dart';

class ClipboardContent {
  static Widget getDetail() {
    return ListView(

    );
  }

  static Widget getGroupContent() {
    return ListView(

    );
  }

  //获取剪切板历史记录
  static Future<List<Widget>> getContent() async {
    var list = <Widget>[];

    Database db = await DBManager().getDatabase();
    var dataList = await db
        .query("clipboard_txt", orderBy: "id desc", limit: 500);

    for (var data in dataList) {
      list.add(
        TextButton(onPressed: () => CopyUtil.copy(data["txt"].toString()),
          child: Text(data["txt"].toString()
            , style: TextStyle(color: Color(0xff000000),
                fontWeight: FontWeight.normal), textAlign: TextAlign.left,),style
              : TextButton.styleFrom(
          alignment: Alignment.centerLeft, // 设置按钮中的文字靠左对齐
        ),));
  }

    return
    list;
  }

}
