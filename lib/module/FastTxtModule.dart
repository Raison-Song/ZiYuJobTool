
import 'package:flutter/material.dart';
import '../AbstractModule.dart';
import '../util/CreateFileUtil.dart';

class FastTxtModule extends AbstractModule{
  @override
  IconData icon=Icons.file_open_sharp;

  @override
  String moduleCreator="syhsuiyue@gmail.com";

  @override
  String moduleDescription="快速编辑txt文件";

  @override
  String moduleName="快速txt";

  final textController = TextEditingController();

  void _submitText() {
    String text = textController.text;
    // 在这里添加处理文本的逻辑
    CreateFileUtil.writeStringToFile(text);
    textController.text="";
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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