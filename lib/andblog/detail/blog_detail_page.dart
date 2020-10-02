import 'dart:convert';
import 'dart:io';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/comment/blog_comment_page.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

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
    var head = new Markdown(
      controller: ScrollController(),
      selectable: true,
      data: detail.content,
      imageDirectory: 'https://raw.githubusercontent.com',
      styleSheet: new MyMarkdownStyle(
          h2: new TextStyle(fontSize: 34)
      ),

    );

    var content= ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
          // return the header
          return ListTile(title: new Column(children: <Widget>[head,Text("$index")],));

      },
    );


    return head;
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
        onPressed: null,
        heroTag: "btn2",
        tooltip: 'Second button',
        child: Icon(Icons.collections),
        elevation: 0.5,
      ),
    );
  }
//    Widget float3() {
//      return Container(
//        child: FloatingActionButton(
//          onPressed: null,
//          heroTag: "btn2",
//          tooltip: 'Second button',
//          child: Icon(Icons.add),
//          elevation: 1,
//        ),
//      );
  }

