import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/collection/collection.dart';
import 'package:flutter_andblog/andblog/common/color_common.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
import 'package:flutter_andblog/andblog/detail/blog_detail_page.dart';
import 'package:http/http.dart' as http;

class CollectionPage extends StatefulWidget {
  @override
  CollectionPageState createState() => new CollectionPageState();
}

class CollectionPageState extends State<CollectionPage> {
  List<Collection> _collectionList = [];
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
  new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  ScrollController scrollController = new ScrollController();
  var hasData = true;
  var page = 0;

  @override
  void initState() {
    super.initState();
    //一进页面就请求接口
    _getCollectionListData();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        //已经滑到底了
        if (hasData) {
          //还有数据，加载下一页
          setState(() {
            loadMoreText = "正在加载中...";
            loadMoreTextStyle =
            new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
          });
          page++;
          print("page=" + page.toString());
          _getCollectionListData();
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
   _getCollectionListData()  {

    SharedPreferencesCommon.getUserId().then((value) {
      String userId=value.toString();
      _getCollectionList(userId);
    });


  }
  Future _getCollectionList(String userId) async {

    //一页加载8条数据，skip为跳过的数据，比如加载第二页（page=1），skip跳过前8条数据，即显示第9-16条数据
    var skip = page * 8;
    print("blog_list_url=" +
        HttpCommon.collection_list_url +
        skip.toString() +
        '&where={"collectionUserId":"'+userId+'"}');
    var response = await http.get(
        HttpCommon.collection_list_url + skip.toString()
            + '&where={"collectionUserId":"'+userId+'"}',
        headers: HttpCommon.headers());

    if (response.statusCode == 200) {
      // setState 相当于 runOnUiThread
      setState(() {
        var data = Collection.decodeData(response.body);
        if (data.length < 8) {
          //某页数据小于8，表明没有下一页了
          hasData = false;
        } else {
          hasData = true;
        }
        _collectionList.addAll(data);
        print("_blogList.length0=" + _collectionList.length.toString());
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    var content;

    if (_collectionList.length == 0) {
      if(hasData){
        content = new Center(
          // 可选参数 child:
          child: new CircularProgressIndicator(),
        );}
      else{
        content = new Center(
          // 可选参数 child:
          child: Text('无收藏数据'),
        );
    } }else {
      content = _contentList();
    }

    return Scaffold(
      backgroundColor: ColorCommon.backgroundColor,
      appBar: AppBar(
        title: Text("我的收藏"),
      ),
      body: content,

    );
  }

  Widget _contentList() {
    print("_blogList.length=" + _collectionList.length.toString());
    return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _collectionList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _collectionList.length) {
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
        _collectionList.clear();
        _getCollectionListData();
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
    Collection blog = _collectionList[index];
    var date = new Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 10.0,
          right: 10.0,
        ),
        child: new Text(
          blog.collectionArticle.date,
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorCommon.dateColor, fontSize: 16),
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
              blog.collectionArticle.cover,
              fit: BoxFit.cover,
              width: double.infinity,
            )));

    var title = new Text(
      blog.collectionArticle.title,
      style: TextStyle(color: ColorCommon.titleColor, fontSize: 18),
    );

    var summary = new Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: new Text(blog.collectionArticle.summary,
            textAlign: TextAlign.left,
            style: TextStyle(color: ColorCommon.summaryColor, fontSize: 16)));

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
      onTap: () => navigateToMovieDetailPage(blog.collectionArticle.articleId, index),

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
