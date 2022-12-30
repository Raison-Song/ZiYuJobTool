import 'package:flutter/material.dart';
import 'package:zi_yu_job/component/file/GetData.dart';

import '../Main.dart';
import '../component/Content.dart';
import '../config/Style.dart';
import '../util/SqliteUtil.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Login();
}

class Login extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
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
                data:
                    ThemeData(primaryColor: Colors.red, hintColor: Colors.grey),
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
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
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
      Main.setUser(user[0]["id"].toString());
    } else {
      //创建新的游客账户
      String userId = "${DateTime.now().millisecondsSinceEpoch}visit";

      db.insert("users", {"id": userId, "token": "-1", "is_use": "1"});

      Main.setUser(userId);
    }
    db.close();
    //跳转到文件管理页面
    Main.getMenu().choice(2);
    getContentWidget.changeWidget(2);
    Main.getMenu().changeLoginState(true);
    //文件页面初始化
    GetData().updateFileTree("main");
  }
}
