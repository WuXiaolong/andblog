import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/common/color_common.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:http/http.dart' as http;
import 'blog.dart';

class BlogListPage extends StatefulWidget {
  @override
  BlogListPageState createState() => new BlogListPageState();
}

class BlogListPageState extends State<BlogListPage> {
  List<Blog> blogList = [];

  @override
  void initState() {
    super.initState();
    //一进页面就请求接口
    getBlogListData();
  }

  //网络请求
  getBlogListData() async {
    var response =
        await http.get(HttpCommon.blog_list_url, headers: HttpCommon.headers());
    if (response.statusCode == 200) {
      // setState 相当于 runOnUiThread
      setState(() {
        blogList = Blog.decodeData(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCommon.backgroundColor,
      appBar: AppBar(
        title: Text('AndBlog'),
      ),
      body: blogItems(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  blogItems() {
    var date = new Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 10.0,
          right: 10.0,
        ),
        child: new Text(
          '2020年6月28日 22:49',
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorCommon.dateColor, fontSize: 18),
        ));

    var cover = new Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        child: new ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            child: new Image.network(
              'http://pic1.win4000.com/wallpaper/2020-04-21/5e9e676001e20.jpg',
            )));

    var title = new Text(
      'APP 开发从 0 到 1（一）需求与准备',
      style: TextStyle(color: ColorCommon.titleColor, fontSize: 22),
    );

    var summary = new Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: new Text('一个人做一个项目，你也可以。',
            textAlign: TextAlign.left,
            style: TextStyle(color: ColorCommon.summaryColor, fontSize: 18)));

    var titleSummary = new Container(
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        shape: BoxShape.rectangle,
      ),
      margin: const EdgeInsets.only(left: 10, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[title, summary],
      ),
    );

    var blogItem = new Column(
      children: <Widget>[date, cover, titleSummary, date, cover, titleSummary],
    );

    return blogItem;
  }
}
