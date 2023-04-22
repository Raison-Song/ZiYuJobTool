import 'package:flutter/material.dart';
import 'package:zi_yu_job/config/clipboard/Style.dart';

import '../component/clipboard/Content.dart';
import '../config/Style.dart';
import 'package:flutter/services.dart';

class ClipboardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Clipboards();
}

/// 粘贴板
class Clipboards extends State<ClipboardWidget> {
  String _clipboardText = '';

  List<Widget> copyDataList =<Widget>[];

  void _loadClipboardContent() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      setState(() {
        _clipboardText = data.text ?? '';
      });
    }
  }

  Future<void> getCopyListAsync() async {
    var copyDataListTemp =await ClipboardContent.getContent();
    setState(() {
      copyDataList=copyDataListTemp;
    });
  }

  @override
  void initState(){
    super.initState();
    // _loadClipboardContent();
    getCopyListAsync();
    //todo 将数据库数据保存至内存，读取剪切板时同时保存内存与数据库
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Style.bgColor,
      child: Column(
        children: [
          //搜索栏
          Row(
            children: const [
              SizedBox(width: 20),
              // Icon(Icons.search),
              Expanded(
                  child: TextField(
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        hintText: "搜索粘贴板",
                      ))),
              SizedBox(width: 20)
            ],
          ),
          //复制内容,
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 20),
                        color: ClipboardStyle.white,
                        child: ListView(
                          children: copyDataList,
                        ))),
                Expanded(
                    child: Container(
                        color: ClipboardStyle.white,
                        margin: const EdgeInsets.only(
                            left: 0, top: 10, right: 20, bottom: 20),
                        child: ClipboardContent.getGroupContent()))
              ],
            ),
          ),
          //属性
          Container(
            color: Colors.lightBlue,
            width: MediaQuery.of(context).size.width * 1,
            height: 200,
            margin: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
            child: ColoredBox(
              color: ClipboardStyle.white,
              child: ClipboardContent.getDetail(),
            ),
          )
        ],
      ),
    );
  }
}
