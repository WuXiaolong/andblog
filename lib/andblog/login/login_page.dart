import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
import 'package:flutter_andblog/andblog/common/toast_common.dart';
import 'package:flutter_andblog/andblog/login/register_page.dart';
import 'package:flutter_andblog/andblog/login/user_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //定义一个controller
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('登录'),
        actions: <Widget>[
          // 非隐藏的菜单
          new IconButton(
              icon: new Icon(Icons.add),
              tooltip: 'Add Alarm',
              onPressed: () {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (BuildContext context) {
                  return new RegisterPage();
                })).then((value) {
                  print('注册返回' );
                  SharedPreferencesCommon.getUserName()
                      .then((value){
                    print("getUserName=" + value.toString());
                    _userNameController.text=value.toString();
                  });

                });
              }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            autofocus: false,
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
            // obscureText: true,
          ),
          FlatButton(
            color: Colors.blue,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text("登录"),
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
              } else {
                toLogin();

              }
            },
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //网络请求
  toLogin() async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(
        HttpCommon.login_url +
            _userNameController.text +
            "&password=" +
            _pwdController.text,
        headers: HttpCommon.headers());
    if (response.statusCode == 200) {
      print('avatarColor========'+json.decode(response.body)['objectId']);
        ToastCommon.showToast("登录成功");
        //保存登录状态
        SharedPreferencesCommon.saveLogin(true);
        SharedPreferencesCommon.saveUserId(json.decode(response.body)['objectId']);
        //保存用户名
        SharedPreferencesCommon.saveUserName(_userNameController.text.trim()).then((value){
          Provider.of<UserInfo>(context,listen: false).getUserName();
        });
        SharedPreferencesCommon.saveAvatarColor(json.decode(response.body)['avatarColor']).then((value){
          Provider.of<UserInfo>(context,listen: false).getAvatarColor();
        });

        Navigator.of(context).pop();

    } else {
      Fluttertoast.showToast(
          msg: "登录失败，请检查",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }
}
