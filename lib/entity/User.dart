

import 'dart:convert';

User UserFromJson(String str) => User.fromJson(json.decode(str));

String UserToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.token,
    this.is_user
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    token = json['token'];
    is_user = json['is_user'];
  }

  String? id;
  String? token;
  String? is_user;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = token;
    map['age'] = is_user;
    return map;
  }
}
