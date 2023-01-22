import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
class FileOperate{
  Future<File> moveFile(File originalFile, String targetPath) async {
    try {
      // This will try first to just rename the file if they are on the same directory,
      return await originalFile.rename(targetPath);
    } on FileSystemException catch (e) {
      // if the rename method fails, it will copy the original file to the new directory and then delete the original file
      final newFileInTargetPath = await originalFile.copy(targetPath);
      // await originalFile.delete();
      return newFileInTargetPath;
    }
  }

  Future<void> main() async {
    final file = File("C:/images/photo.png");
    final path = "C:/photos/";
    await moveFile(file, _getLocalSupport());
  }

  /// 获取应用程序目录
  String _getLocalSupport()  {
    Directory tempDir= getApplicationSupportDirectory() as Directory;
    return tempDir.path;
  }
}
