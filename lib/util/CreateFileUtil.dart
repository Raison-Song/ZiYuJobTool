import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../MyWidget.dart';
import '../WidgetManage.dart';
import '../module/FileModule.dart';
import '../module/fileModule/FileOperate.dart';

class CreateFileUtil {
  static Future<void> writeStringToFile(String str) async {

    final parentDir = await getApplicationSupportDirectory();
    ///应用目录下创建文件
    String appFilePath = "${parentDir.path}${Platform.pathSeparator}";

    final now = DateTime.now();
    final dateString = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeString = '${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}';
    String fileName = "$dateString" + "-" + "$timeString" + "-" + "${_getSafeString(str)}.txt";

    final file = File('${appFilePath}/$fileName');
    file.writeAsString(str);
    FileOperate.setFileChangeBd("root","main",fileName);

    //文件页面初始化
    FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
            () => MyWidget(FileModule())).abstractModule as FileModule);
    fileModule.updateContent();
  }

  static String _getSafeString(String str) {
    int i = 0;
    while (i < 10 && i < str.length) {
      if (str[i].contains(new RegExp(r'[^\w\s]+')) || str[i] == '\n') {
        break;
      }
      i++;
    }
    return str.substring(0, i).trim();
  }
}