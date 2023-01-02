import 'package:contextual_menu/contextual_menu.dart';

import '../../Main.dart';
import '../../util/SqliteUtil.dart';
import '../Content.dart';
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

  //显示上下文菜单-组操作
  showGroupContext(String groupName, bool disabled) {
    Menu _menu = Menu(
      items: [
        MenuItem(
          label: '重命名组',
          disabled: disabled,
          onClick: (_) {
            Popup().renameGroup(groupName);

            if(groupName==getContentWidget.getFileWidget().getChoiceGroup()){
              getContentWidget.getFileWidget()
                  .choiceGroup("main");
            }else{
              getContentWidget.getFileWidget()
                  .choiceGroup(getContentWidget.getFileWidget().getChoiceGroup());
            }
          },
        ),
        MenuItem.separator(),
        MenuItem(
            label: '删除组',
            disabled: disabled,
            onClick: (_) {
              deleteGroup(groupName);
              if(groupName==getContentWidget.getFileWidget().getChoiceGroup()){
                getContentWidget.getFileWidget()
                    .choiceGroup("main");
              }else{
                getContentWidget.getFileWidget()
                    .choiceGroup(getContentWidget.getFileWidget().getChoiceGroup());
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



}