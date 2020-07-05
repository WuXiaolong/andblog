import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/http/http_common.dart';
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
    var response = await http.get(HttpCommon.blog_list_url, headers: HttpCommon.headers());
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
      appBar: AppBar(
        title: Text('AndBlog'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}