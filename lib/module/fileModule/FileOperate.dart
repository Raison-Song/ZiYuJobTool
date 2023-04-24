import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../Main.dart';
import '../../MyWidget.dart';
import '../../WidgetManage.dart';
import '../../util/SqliteUtil.dart';
import '../FileModule.dart';
import 'package:process_run/shell.dart';

class FileOperate{
  //打开文件
  static Future<void> openMyFile(String fileName) async {
    ///应用管理目录
    final parentDir = await getApplicationSupportDirectory();
    final path = "${parentDir.path}${Platform.pathSeparator}$fileName";
    final file = File(path);

    if (await file.exists()) {
      final shell = Shell();
      shell.run(path);
    } else {
      print('File not found.');
    }
  }

  static Future<File> moveFile(File originalFile, String targetPath) async {
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
  ///上传本地文件
  ///@param fileType 文件类型
  static Future<void> importLocalFile(String folderName,String groupName,{List<String>? fileType}) async {
    fileType??=[];
    final xType = XTypeGroup(label: '所有', extensions: fileType);
    final XFile? file = await openFile(acceptedTypeGroups: [xType]);
    if(file!=null){
      saveFile(file.path,file.name);
      setFileChangeBd(folderName,groupName,file.name);
    }
  }

  ///保存文件至应用目录
  static saveFile(String filePath,String fileName) async {
    print("开始保存");
    ///应用管理目录
    final parentDir = await getApplicationSupportDirectory();
    ///应用目录下创建文件
    String appFilePath = "${parentDir.path}${Platform.pathSeparator}$fileName";
    File file=File(appFilePath);
    ///本地文件
    File localFile=File(filePath);
    print(localFile);
    bool exist = file.existsSync();
    if (exist) {
      print("文件已存在");
    } else {
      localFile.copy(appFilePath);
      print(file);
    }

    FileModule fileModule=(WidgetManage.widgets.putIfAbsent("文件管理",
            () => MyWidget(FileModule())).abstractModule as FileModule);

    fileModule.choiceGroup(
        fileModule
            .chosenGroup);
  }

  ///写入本地数据库
  static Future<void> setFileChangeBd(String folderName,String groupName,String fileName) async {
    var db = await DBManager().getDatabase();
    await db.insert("folder_file",{
      "id":"${DateTime.now().millisecondsSinceEpoch}u"
          "${Main.getUser()}r"
          "${Random.secure().nextInt(100000).toString().padLeft(5, '0')}",
      "user_id":Main.getUser(),
      "group_name":groupName,
      "folder_name": folderName,
      "file_name": fileName,
      "upload_time":DateTime.now().millisecondsSinceEpoch
    });
  }

  /// 获取应用程序目录
  static String _getLocalSupport()  {
    Directory tempDir= getApplicationSupportDirectory() as Directory;
    return tempDir.path;
  }
}
