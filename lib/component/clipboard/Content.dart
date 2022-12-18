import 'package:flutter/material.dart';
// import 'package:screen_text_extractor/screen_text_extractor.dart';

class ClipboardContent{
  static Widget getDetail(){
    return ListView(

    );
  }

  static Widget getContent(){
    return ListView(

    );
  }

  static Widget getGroupContent(){
    return ListView(

    );
  }

  // final screenTextExtractor = ScreenTextExtractor.instance;
  // String? _text;
  //
  // Container getContent(){
  //   return Container(
  //
  //   );
  // }

  // void _getClipboardText() async {
  //   ExtractedData? data = await screenTextExtractor.extract(mode: ExtractMode.clipboard);
  //   _setText(data);
  // }
  // void _setText(ExtractedData? data) {
  //   if (data == null) {
  //     BotToast.showText(text: '剪切板什么都没有🤨');
  //   } else {
  //     if (_text == data.text) {
  //       BotToast.showText(text: '换个内容再粘贴吧🥱');
  //     } else {
  //       _text = data.text;
  //       _type = ClipboardType.text;
  //       setState(() {});
  //     }
  //   }
  // }

}
