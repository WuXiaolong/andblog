import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/comment/add_comment_page.dart';
import 'package:flutter_andblog/andblog/comment/comment.dart';
import 'package:flutter_andblog/andblog/common/color_common.dart';
import 'package:flutter_andblog/andblog/common/http_common.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
import 'package:flutter_andblog/andblog/detail/blog_detail_page.dart';
import 'package:flutter_andblog/andblog/list/blog.dart';
import 'package:flutter_andblog/andblog/login/login_page.dart';
import 'package:http/http.dart' as http;
import '../home_drawer.dart';

class BlogCommentPage extends StatefulWidget {
  final String blogId;
  final String blogTitle;

  BlogCommentPage(this.blogId,this.blogTitle);
  @override
  BlogListPageState createState() => new BlogListPageState(blogId,blogTitle);
}

class BlogListPageState extends State<BlogCommentPage> {
  String blogId;
  String blogTitle;
  List<Comment> _commentList=[];
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
      new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  ScrollController scrollController = new ScrollController();
  var hasData = true;
  var page = 0;

  BlogListPageState(String blogId,String blogTitle){
    this.blogId=blogId;
    this.blogTitle=blogTitle;
  }
  @override
  void initState() {
    super.initState();
    //一进页面就请求接口
    _getCommentListData();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("addListener hasData=" + hasData.toString());
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
          _getCommentListData();
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
  Future _getCommentListData() async {
    //一页加载8条数据，skip为跳过的数据，比如加载第二页（page=1），skip跳过前8条数据，即显示第9-16条数据
    var skip = page * 8;
    print("blog_list_url=" +
        HttpCommon.comment_list_url +
        skip.toString() +
         '&where={"blogId":"'+blogId+'"}');
    var response = await http.get(
        HttpCommon.comment_list_url + skip.toString()
            + '&where={"blogId":"'+blogId+'"}',
        headers: HttpCommon.headers());
    print('statusCode='+response.statusCode.toString());
    if (response.statusCode == 200) {
      // setState 相当于 runOnUiThread
      setState(() {
        var data = Comment.decodeData(response.body);
        if (data.length < 8) {
          //某页数据小于8，表明没有下一页了
          hasData = false;
        } else {
          hasData = true;
        }
        _commentList.addAll(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    var content;

    if (_commentList.length == 0) {
      if(hasData){
      content = new Center(
        // 可选参数 child:
        child: new CircularProgressIndicator(),
      );}
      else{
        content = new Center(
          // 可选参数 child:
          child: Text('无评论数据'),
        );
      }
    } else {
      content = _contentList();
    }
    print('BuildContext='+hasData.toString());
    return Scaffold(
      backgroundColor: ColorCommon.backgroundColor,
      appBar: AppBar(
        title: Text(blogTitle),
        actions: <Widget>[
          // 非隐藏的菜单
          new IconButton(
              icon: new Icon(Icons.add),
              tooltip: 'Add Comment',
              onPressed: () {


                SharedPreferencesCommon.isLogin().then((value) {
                  print("isLogin=" + value.toString());
                  if (value!=null&&value) {


                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (BuildContext context) {
                      return new AddCommentPage(blogId,blogTitle);
                    })).then((value) {
                      print('评论返回' );
                      page = 0;
                      _commentList.clear();
                      _getCommentListData();

                    });
                  } else {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (BuildContext context) {
                      return new LoginPage();
                    }));
                  }
                });



              }
          ),
          // 隐藏的菜单
//          new PopupMenuButton<String>(
//            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
//              this.SelectView(Icons.android, '我的', 'A'),
//              this.SelectView(Icons.account_circle, '关于', 'B'),
//            ],
//            onSelected: (String action) {
//              // 点击选项的时候
//              switch (action) {
//                case 'A': break;
//                case 'B': break;
//                case 'C': break;
//              }
//            },
//          ),
        ],
      ),
      body: content,

    );
  }

  Widget _contentList() {
    print("_blogList.length=" + _commentList.length.toString());
    return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _commentList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _commentList.length) {
              return _buildProgressMoreIndicator();
            } else {
              return _commentItem(index);
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
        _commentList.clear();
        _getCommentListData();
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

  Widget _commentItem(int index) {

    Comment comment = _commentList[index];
    var avatar = new Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
        child: new CircleAvatar(
          backgroundColor: Color(int.parse(comment.commentUser.avatarColor)),
            // backgroundColor: Color(0xFFE65100),
            child: new Text(comment.commentUser.userName.substring(0, 1),style: TextStyle(color: Colors.white, fontSize: 20))));

    var username = new Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: new Text(
          comment.commentUser.userName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
          textAlign: TextAlign.start,
          style: TextStyle(color: ColorCommon.summaryColor, fontSize: 16),
        ));

    var content = new Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: new Text(comment.commentContent,
          textAlign: TextAlign.start,
          style: TextStyle(color: ColorCommon.contentColor, fontSize: 20)),
    );

    var usernameContent =

    new Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(bottom: 10.0),
      child: new Column(
        children: <Widget>[username, content],
      ));


    var commentItem = new Container(
        color: Colors.white,
        padding: const EdgeInsets.all(
          5.0,
        ),
        alignment: Alignment.topLeft,
        child: Column(children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[avatar, Expanded(child: usernameContent)],
          ),
          new Divider()
        ]));

    return commentItem;
  }


}
