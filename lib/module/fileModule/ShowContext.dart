import 'package:contextual_menu/contextual_menu.dart';
import 'package:zi_yu_job/MyWidget.dart';
import 'package:zi_yu_job/WidgetManage.dart';
import 'package:zi_yu_job/module/FileModule.dart';

import '../../Main.dart';
import '../../util/SqliteUtil.dart';

import 'Popup.dart';

class ShowContext{

  //显示上下文菜单
  showContext() {
    Menu _menu = Menu(
      items: [
        MenuItem(
          label: '新加文件',
          onClick: (_) {},
        ),
        MenuItem.separator(),
        MenuItem(
            label: '新建文件夹',
            onClick: (_) {
              Popup().createFloder("root");
            }),
      ],
    );
    popUpContextualMenu(_menu);
  }

  //显示上下文菜单-编辑文件夹
  editFolder(String folderName) {
    ///获取file
    FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
            () => MyWidget(FileModule())).abstractModule as FileModule);

    Menu _menu = Menu(
      items: [
        MenuItem(
          label: '文件夹:$folderName',
          disabled: true,
        ),
        MenuItem(
          label: '新加文件',
          onClick: (_) {

          },
        ),
        MenuItem(
          label: '新建文件夹',
          onClick: (_) {
            Popup().createFloder(folderName);
          },
        ),
        MenuItem.separator(),
        MenuItem(
            label: '删除文件夹',
            onClick: (_) {
              delFolder(folderName);
              fileModule
                  .choiceGroup(
                  fileModule
                      .chosenGroup);
            }),
      ],
    );
    popUpContextualMenu(_menu);
  }

  //显示上下文菜单-组操作
  showGroupContext(String groupName, bool disabled) {
    ///获取file
    FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
            () => MyWidget(FileModule())).abstractModule as FileModule);

    Menu _menu = Menu(
      items: [
        MenuItem(
          label: '重命名组',
          disabled: disabled,
          onClick: (_) {
            Popup().renameGroup(groupName);

            if(groupName==fileModule.chosenGroup){
              fileModule.choiceGroup("main");
            }else{
              fileModule
                  .choiceGroup(fileModule.chosenGroup);
            }
          },
        ),
        MenuItem.separator(),
        MenuItem(
            label: '删除组',
            disabled: disabled,
            onClick: (_) {
              deleteGroup(groupName);
              if(groupName==fileModule.chosenGroup){
                fileModule
                    .choiceGroup("main");
              }else{
                fileModule
                    .choiceGroup(fileModule.chosenGroup);
              }
            }),
      ],
    );
    popUpContextualMenu(_menu);
  }

  //删除组
  deleteGroup(String delGroupName) async {
    var db = await DBManager().getDatabase();
    await db.delete("groups",
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), delGroupName]);

    await db.delete("folder",
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), delGroupName]);

    await db.delete("folder_file",
        where: "user_id=? and group_name=?",
        whereArgs: [Main.getUser(), delGroupName]);
    // db.close();
  }

  //删除文件夹
  delFolder(String folderName,{String? choicedGroup}) async {
    ///获取file
    FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
            () => MyWidget(FileModule())).abstractModule as FileModule);
    choicedGroup??=fileModule.chosenGroup;
    //查询子文件夹
    var db = await DBManager().getDatabase();
    List<Map<String,Object?>> id= await db.query("folder",
        where: "user_id=? and before_folder_name=? and group_name=?",
        whereArgs: [Main.getUser(), folderName,choicedGroup]);
    //删除当前文件夹
    await db.delete("folder",
        where: "user_id=? and folder_name=? and group_name=?",
        whereArgs: [Main.getUser(), folderName,choicedGroup]);
    //删除当前文件夹中文件
    await db.delete("folder_file",
        where: "user_id=? and folder_name=? and group_name=?",
        whereArgs: [Main.getUser(), folderName,choicedGroup]);

    for(int i=0;i<id.length;i++){
      delFolder(id[i]["folder_name"].toString(),choicedGroup: choicedGroup);
    }
  }


}