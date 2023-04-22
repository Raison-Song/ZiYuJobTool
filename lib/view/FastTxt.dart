import 'package:flutter/material.dart';

import '../config/Style.dart';

class FastTxtWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FastTxt();

}

class FastTxt extends State<FastTxtWidget> {
  final textController = TextEditingController();

  void _submitText() {
    String text = textController.text;
    // 在这里添加处理文本的逻辑
    print(text);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                controller: textController,
                decoration: const InputDecoration(
                  hintText: '输入文本',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitText,
              child: const Text('提交'),
            ),
          ],
        ),
      ),
    );
  }
}

