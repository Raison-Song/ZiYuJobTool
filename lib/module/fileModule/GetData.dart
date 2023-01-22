import 'package:zi_yu_job/Main.dart';

import '../../MyWidget.dart';
import '../../WidgetManage.dart';
import '../../util/SqliteUtil.dart';
import '../FileModule.dart';
import 'FilesTree.dart';

///获取文件目录树 数据
class GetData {

  FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
          () => MyWidget(FileModule())).abstractModule as FileModule);

  setAllFiles() async {


    Map<String, String> allFilesTEMP = {};
    var db = await DBManager().getDatabase();
    var files = await db.query("folder_file",
        where: "user_id=? and group_id=?",
        whereArgs: [Main.getUser(), fileModule.chosenGroup]);

    for (int i = 0; i < files.length; i++) {
      allFilesTEMP.putIfAbsent(files[i]["file_name"].toString(),
          () => files[i]["upload_time"].toString());
    }
    fileModule.allFiles=allFilesTEMP;
    //db.close();

    //重新渲染
    fileModule.updateContent();
  }

  //更新文件树，在更新完毕时重新渲染页面
  updateFileTree(String groupName) async {

    var filesTree = fileTree();
    var db = await DBManager().getDatabase();
    var allFiles = await db.query("folder_file",
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), groupName]);
    //db.close();

    var db2 = await DBManager().getDatabase();
    var allFolders = await db2.query("folder",
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), groupName]
    );

    db2.close();
    // filesTrees.putIfAbsent(groupName, () => _fileTree(allFiles, allFolders, filesTree, "root"));
    fileModule.filesTrees.update(
        groupName,
        (value) =>
            _fileTree(allFiles, allFolders, filesTree, "root", groupName),
        ifAbsent: () =>
            _fileTree(allFiles, allFolders, filesTree, "root", groupName));

    //重新渲染
    fileModule.updateContent();
  }

  fileTree _fileTree(
      List<Map<String, Object?>> allFiles,
      List<Map<String, Object?>> allFolders,
      fileTree filesTree,
      String folderName,
      String groupName) {
    for (int i = 0; i < allFiles.length; i++) {
      //如果文件属于此目录
      if (allFiles[i]["folder_name"].toString() == folderName) {
        filesTree.getFolder(folderName).setFile(
            allFiles[i]["file_name"].toString(),
            preFolder: folderName);
      }
    }
    for (int i = 0; i < allFolders.length; i++) {
      //如果目录属于此目录
      if (allFolders[i]["before_folder_name"].toString() == folderName) {
        filesTree.getFolder(folderName).setFolder(
            allFolders[i]["folder_name"].toString(),
            preFolder: folderName);
        bool? isS = fileModule
            .filesTreesIsSpread[groupName]
            ?.contains(allFolders[i]["folder_name"].toString());
        isS ??= false;

        if (isS) {
          filesTree
              .getFolder(allFolders[i]["folder_name"].toString())
              .isSpread = true;
        }
        _fileTree(
            allFiles,
            allFolders,
            filesTree,
            filesTree
                .getFolder(allFolders[i]["folder_name"].toString())
                .folderName,
            groupName);
      }
    }

    return filesTree;
  }
}
