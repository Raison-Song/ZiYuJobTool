
import 'package:flutter/material.dart';
import '../AbstractModule.dart';

class FastTxtModule extends AbstractModule{
  @override
  IconData icon=Icons.file_open_sharp;

  @override
  String moduleCreator="syhsuiyue@gmail.com";

  @override
  String moduleDescription="快速编辑txt文件";

  @override
  String moduleName="快速txt";

  @override
  Widget build(BuildContext context) {
    return const Text("快速txt");
  }

}