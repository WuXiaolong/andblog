import 'dart:convert';
import 'dart:io';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/collection/add_collection_article.dart';
import 'package:flutter_andblog/andblog/comment/blog_comment_page.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
import 'package:flutter_andblog/andblog/login/login_page.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:syntax_highlighter/syntax_highlighter.dart';

import 'blog_detail.dart';
import 'my_markdown_style.dart';
//import 'dart:convert' as convert;

class BlogDetailPage extends StatefulWidget {
  final String blogId;
  final Object imageTag;

  BlogDetailPage(
    this.blogId, {
    @required this.imageTag,
  });

  @override
  BlogDetailPageState createState() => new BlogDetailPageState(blogId);
}

class BlogDetailPageState extends State<BlogDetailPage> {

  Detail detail;
  final String blogId;

  BlogDetailPageState(
      this.blogId);

  @override
  void initState() {
    super.initState();
    //一进页面就请求接口，一开始不知道这个 initState 方法 ，折腾了很久
    getDetailData();
  }

  //网络请求
  getDetailData() async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(HttpCommon.blog_detail_url + widget.blogId,
        headers: HttpCommon.headers());
    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(response.body);
        detail = Detail.fromJson(data);
        print('title=' + detail.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var content;
    var title = 'Title';
    if (detail == null) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      title = detail.title;
      content = setContent();
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: content,
      floatingActionButton: AnimatedFloatingActionButton(

        //Fab list
          fabButtons: <Widget>[
            float1(), float2(),
          ],
          colorStartAnimation: Colors.blue,
          colorEndAnimation: Colors.red,
          animatedIconData: AnimatedIcons.add_event //To principal button
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  setContent() {
    var content = new Markdown(
      controller: ScrollController(),
      selectable: true,
      data: detail.content,
      // fitContent:true,
      syntaxHighlighter: new HighLight(),
      // imageDirectory: 'https://raw.githubusercontent.com',
      styleSheet: new MarkdownStyleSheet(
          p: new TextStyle(fontSize: 16),
          h2: new TextStyle(color: Colors.blue,fontSize: 24),
          // img:new TextStyle(width:double.infinity),
      ),
      onTapLink: (url){
        // 获取点击链接，可以使用webview展示
        print(url);
      },
    );

    return content;
  }

  // 跳转页面
  navigateToBlogCommentPage(String blogId) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new BlogCommentPage(blogId,detail.title);
    }));
  }

//评论
  Widget float1() {
    return Container(
      child: FloatingActionButton(
        onPressed: (){
          navigateToBlogCommentPage(blogId);
        },
        heroTag: "btn1",
        tooltip: 'First button',
        child: Icon(Icons.comment),
        elevation: 0.5,
      ),
    );
  }
  Widget float2() {
    return Container(
      child: FloatingActionButton(
        onPressed: (){

          SharedPreferencesCommon.isLogin().then((value) {
            print("isLogin=" + value.toString());
            if (value!=null&&value) {

              isCollection();
            } else {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                return new LoginPage();
              }));
            }
          });


        },
        heroTag: "btn2",
        tooltip: 'Second button',
        child: Icon(Icons.collections),
        elevation: 0.5,
      ),
    );
  }

   addCollection() {
    SharedPreferencesCommon.getUserId().then((value) {
      String userId=value.toString();

      //设置header
      Map<String, Object> registerBody = new Map();
      registerBody["collectionUserId"] = userId;
      registerBody["collectionArticleId"] = blogId;
      registerBody["collectionArticle"] =
          new AddCollectionArticle("Pointer", "ArticleTable", blogId).toJson();

      addCollectionData(registerBody);


    });




  }

  //网络请求
  addCollectionData(Map<String, Object> registerBody) async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(HttpCommon.add_collection_url,
        headers: HttpCommon.headers(), body: json.encode(registerBody));
    print('statusCode=' + response.statusCode.toString());
    if (response.statusCode == 201) {
      Fluttertoast.showToast(
          msg: "收藏成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      // _showDialog();
    } else {
      Fluttertoast.showToast(
          msg: "收藏失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  isCollection() {
    SharedPreferencesCommon.getUserId().then((value) {
      String userId=value.toString();

      isCollectionData( userId);


    });




  }

  //网络请求
  isCollectionData(String userId) async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(HttpCommon.iscollection_url+blogId+'","collectionUserId":"'+userId+'"}',
        headers: HttpCommon.headers());
    print('url=' + HttpCommon.iscollection_url+blogId+'","collectionUserId":"'+userId+'"}');
    print('statusCode=' + response.statusCode.toString());
    print('body=' + response.body.toString());
    if (response.statusCode == 200) {

      int count=json.decode(response.body)["count"];
      if(count==1){
        Fluttertoast.showToast(
            msg: "已经收藏",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }else{
        addCollection();
      }

      // _showDialog();
    } else {
      Fluttertoast.showToast(
          msg: "收藏失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }


  }

