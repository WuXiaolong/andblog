import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  BlogDetailPageState createState() => new BlogDetailPageState();
}

class BlogDetailPageState extends State<BlogDetailPage> {
  Detail detail;

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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  setContent() {
    var content = new Markdown(
      controller: ScrollController(),
      selectable: true,
      data: detail.content,
      imageDirectory: 'https://raw.githubusercontent.com',
      styleSheet: new MyMarkdownStyle(
          h2: new TextStyle(fontSize: 34)
      ),

    );

    return content;
  }
}
