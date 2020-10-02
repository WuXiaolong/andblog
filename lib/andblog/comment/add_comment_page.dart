import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/comment/add_comment_user.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
import 'package:flutter_andblog/andblog/common/toast_common.dart';
import 'package:flutter_andblog/andblog/login/register_page.dart';
import 'package:flutter_andblog/andblog/login/user_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddCommentPage extends StatefulWidget {
  final String blogId;
  final String blogTitle;

  AddCommentPage(this.blogId, this.blogTitle);

  @override
  AddCommentPageState createState() =>
      new AddCommentPageState(blogId, blogTitle);
}

class AddCommentPageState extends State<AddCommentPage> {
  String blogId;
  String blogTitle;

  AddCommentPageState(String blogId, String blogTitle) {
    this.blogId = blogId;
    this.blogTitle = blogTitle;
  }
  //定义一个controller
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(blogTitle),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              autofocus: true,
              maxLines: 4,
              controller: _commentController, //设置controller
              decoration: InputDecoration(
                // labelText: "评论",
                hintText: "说说您的感受",
                // prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          FlatButton(
            color: Colors.blue,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text("发送"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              print(_commentController.text);
              if (_commentController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: "请输入评论",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              } else {
                addComment();
              }
            },
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Map<String, Object> addComment() {
    SharedPreferencesCommon.getUserId().then((value) {
      String userId=value.toString();

      //设置header
      Map<String, Object> registerBody = new Map();
      registerBody["commentContent"] = _commentController.text.trim();
      registerBody["blogId"] = blogId;
      registerBody["commentUser"] =
          new AddCommentUser("Pointer", "_User", userId).toJson();

      toAddComment(registerBody);


      return registerBody;
    });




  }

  //网络请求
  toAddComment(Map<String, Object> registerBody) async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(HttpCommon.add_comment_url,
        headers: HttpCommon.headers(), body: json.encode(registerBody));
    print('statusCode=' + response.statusCode.toString());
    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: "评论成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      // _showDialog();
    } else {
      Fluttertoast.showToast(
          msg: "注册失败，请检查",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
    Navigator.of(context).pop();
  }
}
