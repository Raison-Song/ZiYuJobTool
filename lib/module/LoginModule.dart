import 'package:flutter/material.dart';
import 'package:zi_yu_job/AbstractModule.dart';

import '../Main.dart';

import '../MyWidget.dart';
import '../WidgetManage.dart';
import '../config/Style.dart';
import '../util/SqliteUtil.dart';
import 'FileModule.dart';
import 'fileModule/GetData.dart';

class LoginModule extends AbstractModule {
  @override
  IconData icon = Icons.cabin;

  @override
  String moduleCreator = "syhsuiyue@gmail.com";

  @override
  String moduleDescription = "用户信息页面";

  @override
  String moduleName = "用户信息";

  bool _isEditingUsername = false;

  TextEditingController _usernameController = TextEditingController(text: "");

  void update(){
    setState(() {
      _usernameController = TextEditingController(text: Main.getUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Main.isLogin()) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isEditingUsername
                      ? Expanded(
                    child: TextFormField(
                      controller: _usernameController,
                    ),
                  )
                      : Text(
                    _usernameController.text,
                    style: TextStyle(fontSize: 24.0),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _isEditingUsername = !_isEditingUsername;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                "Settings",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text("Cache Directory"),
                subtitle: Text("/path/to/cache"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: 处理点击设置项的逻辑
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(Icons.logout),
          onPressed: () {
            logout();
          },
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
        //     0, MediaQuery.of(context).size.width * 0.1, 0),
        color: Style.bgColor,
        child: Column(
          children: [
            const SizedBox(height: 150),
            //邮箱
            SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Theme(
                  data: ThemeData(hintColor: Colors.grey),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "邮箱",
                        contentPadding: const EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            //密码
            SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Theme(
                  data: ThemeData(
                      primaryColor: Colors.red, hintColor: Colors.grey),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "密码",
                        contentPadding: const EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                  ),
                )),
            const SizedBox(height: 20),
            //登陆按钮
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(children: [
                //邮箱密码登陆
                Expanded(
                    child: SizedBox(
                  height: 45,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(15),
                          )),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: const Text(
                      "登陆",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
                //游客登陆
                SizedBox(
                    height: 45,
                    width: 45,
                    child: TextButton(
                      onPressed: () {
                        visitLogin();
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(15),
                            )),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                      child: const Text(
                        "游客登陆",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ))
              ]),
            )
          ],
        ),
      );
    }
  }

  //游客登陆
  visitLogin() async {
    //查询数据库是否有游客账户
    var db = await DBManager().getDatabase();

    var user = await db.query("users", where: "id like '%visit%'");

    // db.close();
    // var db2 = await DBManager().getDatabase();
    //如果存在游客账户
    if (user.isNotEmpty) {
      //将游客账户设为使用
      db.update("users", {"is_use": "1"},
          where: "id=?", whereArgs: [user[0]["id"]]);
      await Main.setUser(user[0]["id"].toString());
    } else {
      //创建新的游客账户
      String userId = "${DateTime.now().millisecondsSinceEpoch}visit";

      db.insert("users", {"id": userId, "token": "-1", "is_use": "1"});

      await Main.setUser(userId);
    }
    db.close();
    //刷新登录页面
    update();

    //跳转到文件管理页面
    Main.getMenu().menu.choice("文件管理");
    Main.getMenu().menu.uploadLoginState();
    WidgetManage.contentWidgets.content.changeWidget("文件管理");

    //文件页面初始化
    FileModule fileModule= (WidgetManage.widgets.putIfAbsent("文件管理",
            () => MyWidget(FileModule())).abstractModule as FileModule);
    fileModule.choiceGroup("main");

  }

  //注销账户
  Future<void> logout() async {
    //将数据库所以账户离线
    var db = await DBManager().getDatabase();
    db.update("users", {'is_use': '0'});
    db.close();

    update();

    //将main保存的用户清除
    Main.logoutUser();
    Main.initMain();
  }
}
