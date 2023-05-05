import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FolderPickerUtil {
  static Future<String?> getFolderPath() async {
    try {
      // 获取平台通道
      const MethodChannel platform = MethodChannel('flutter_folder_picker');

      // 调用原生方法选择文件夹
      final String? folderPath =
      await platform.invokeMethod('getFolderPath');

      if (folderPath != null) {
        return folderPath;
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get folder path: '${e.message}'.");
    }

    return null;
  }

  static Future<String?> getAppDocumentsFolder() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}