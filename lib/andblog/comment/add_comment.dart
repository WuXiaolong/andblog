import 'dart:convert';

import 'comment_user.dart';

class AddComment{
  final String commentContent;
  final CommentUser commentUser;

  //构造函数
  AddComment({
    this.commentContent,
    this.commentUser,
  });

  // static List<Blog> decodeData(String jsonData) {
  //   List<Blog> blogList = new List<Blog>();
  //   var data = json.decode(jsonData);
  //   var results = data['results'];
  //   for (int i = 0; i < results.length; i++) {
  //     blogList.add(fromMap(results[i]));
  //   }
  //   return blogList;
  // }
  //
  // static Blog fromMap(Map<String, dynamic> map) {
  //
  //   return new Blog(
  //     content: map['content'],
  //     cover: map['cover'],
  //     date: map['date'],
  //     objectId: map['objectId'],
  //     summary: map['summary'],
  //     title: map['title'],
  //   );
  // }
}