import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/common/color_common.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/detail/blog_detail_page.dart';
import 'package:http/http.dart' as http;
import 'blog.dart';

class BlogListPage extends StatefulWidget {
  @override
  BlogListPageState createState() => new BlogListPageState();
}

class BlogListPageState extends State<BlogListPage> {
  List<Blog> _blogList = [];
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
      new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
  ScrollController scrollController = new ScrollController();
  var hasData = true;
  var page = 0;

  @override
  void initState() {
    super.initState();
    //一进页面就请求接口
    _getBlogListData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasData) {
          setState(() {
            loadMoreText = "正在加载中...";
            loadMoreTextStyle =
                new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
          });
          page++;
          print("page=" + page.toString());
          _getBlogListData();
        } else {
          setState(() {
            loadMoreText = "没有更多数据";
            loadMoreTextStyle =
                new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //网络请求
  Future _getBlogListData() async {
    var skip = page * 8;
    print("blog_list_url=" + HttpCommon.blog_list_url + skip.toString());
    var response = await http.get(HttpCommon.blog_list_url + skip.toString(),
        headers: HttpCommon.headers());
    if (response.statusCode == 200) {
      // setState 相当于 runOnUiThread
      setState(() {
        var data = Blog.decodeData(response.body);
        if (data.length < 8) {
          hasData = false;
        } else {
          hasData = true;
        }
        _blogList.addAll(data);
        print("_blogList.length0=" + _blogList.length.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var content;

    if (_blogList.length == 0) {
      content = new Center(
        // 可选参数 child:
        child: new CircularProgressIndicator(),
      );
    } else {
      content = _contentList();
    }

    return Scaffold(
      backgroundColor: ColorCommon.backgroundColor,
      appBar: AppBar(
        title: Text('AndBlog'),
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _contentList() {
    print("_blogList.length=" + _blogList.length.toString());
    return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _blogList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _blogList.length) {
              return _buildProgressMoreIndicator();
            } else {
              return _blogItem(index);
            }
          },
          controller: scrollController,
        ));
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        page = 0;
        _blogList.clear();
        _getBlogListData();
      });
    });
  }

  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText, style: loadMoreTextStyle),
      ),
    );
  }

  Widget _blogItem(int index) {
    Blog blog = _blogList[index];
    var date = new Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 10.0,
          right: 10.0,
        ),
        child: new Text(
          blog.date,
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
      blog.title,
      style: TextStyle(color: ColorCommon.titleColor, fontSize: 22),
    );

    var summary = new Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: new Text(blog.summary,
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

    var blogItem = new GestureDetector(
      //点击事件
      onTap: () => navigateToMovieDetailPage(blog.objectId, index),

      child: new Column(
        children: <Widget>[
          date,
          cover,
          titleSummary,
        ],
      ),
    );

    return blogItem;
  }

  // 跳转页面
  navigateToMovieDetailPage(String blogId, Object imageTag) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new BlogDetailPage(blogId, imageTag: imageTag);
    }));
  }
}
