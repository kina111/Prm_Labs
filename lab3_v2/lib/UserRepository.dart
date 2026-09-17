import 'dart:convert';

import 'User.dart';

class UserRepository {
  String stringResult = '''
  [
    {
      "name": "Nguyễn Văn A",
      "email": "a.nguyen@example.com"
    },
    {
      "name": "Trần Thị B",
      "email": null
    },
    {
      "name": "Lê Văn C"
    }
  ]
  ''';


  Future<List<User>> getUsers() async {
    await Future.delayed(Duration(seconds: 2));
    List<dynamic> jsonList = jsonDecode(stringResult);
    List<User> users = jsonList.map((jsonUser) => User.fromJson(jsonUser)).toList();
    return users;
  }
}