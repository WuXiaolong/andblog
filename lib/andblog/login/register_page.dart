import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/common/color_common.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
import 'package:flutter_andblog/andblog/common/toast_common.dart';
import 'package:flutter_andblog/andblog/login/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  //定义一个controller
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _avatarColor = "0xFF000000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('注册'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: _userNameController, //设置controller
            decoration: InputDecoration(
              labelText: "用户名",
              hintText: "输入用户名",
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextField(
            controller: _pwdController,
            decoration: InputDecoration(
                labelText: "密码",
                hintText: "您的登录密码",
                prefixIcon: Icon(Icons.lock)),
            obscureText: true,
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
                labelText: "邮箱",
                hintText: "您的邮箱",
                prefixIcon: Icon(Icons.email)),
          ),
          FlatButton(
            color: Colors.blue,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text("注册"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              print(_userNameController.text);
              print(_pwdController.text);
              if (_userNameController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: "请输入用户名",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              } else if (_pwdController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "请输入密码",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER);
              } else if (_emailController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "请输入邮箱",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER);
              } else {
                toRegister();
              }
            },
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Map<String, String> registerBody() {
    _avatarColor=ColorCommon.randomColor();
    //设置header
    Map<String, String> registerBody = new Map();
    registerBody["username"] = _userNameController.text.trim();
    registerBody["password"] = _pwdController.text.trim();
    registerBody["email"] = _emailController.text.trim();
    registerBody["avatarColor"] = _avatarColor;

    return registerBody;
  }

  //网络请求
  toRegister() async {
    print('body=' + json.encode(registerBody()));
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(HttpCommon.register_url,
        headers: HttpCommon.headers(), body: json.encode(registerBody()));
    print('response=' + response.body + "," + response.reasonPhrase);
    print('statusCode=' + response.statusCode.toString());
    if (response.statusCode == 201) {
      SharedPreferencesCommon.saveUserName(_userNameController.text.trim());
      _showDialog();
    } else if (response.statusCode == 400) {
      Register register = Register.fromMap(json.decode(response.body));
      int code = register.code;
      print('code=' + code.toString());
      if (code == 202) {
        ToastCommon.showToast("用户名已经存在");
      } else if (code == 203) {
        ToastCommon.showToast("邮箱已经存在");
      } else {
        Fluttertoast.showToast(
            msg: "注册失败，请检查",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "注册失败，请检查",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  Future _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("注册成功"),
              content: new Text("感谢您注册帐号，我们自动为您发送邮件，请一周内完成校验，后续可用于密码修改。"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop("register_page");
                  },
                )
              ]);
        }
    );
  }
}