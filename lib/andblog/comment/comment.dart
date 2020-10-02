import 'dart:convert';

import 'comment_user.dart';

class Comment{
  final String commentContent;
  final String date;
  final CommentUser commentUser;

  //构造函数
  Comment({
    this.commentContent,
    this.date,
    this.commentUser,
  });

  static List<Comment> decodeData(String jsonData) {
    List<Comment> commentList = new List<Comment>();
    var data = json.decode(jsonData);
    var results = data['results'];
    for (int i = 0; i < results.length; i++) {
      print("commentUser data=" + results[i]['commentUser']['username'].toString());
      commentList.add(fromMap(results[i]));
    }
    return commentList;
  }

  static Comment fromMap(Map<String, dynamic> map) {
    final CommentUser commentUser=new CommentUser(
        map['commentUser']['username'].toString(),
        map['commentUser']['username'].toString(),
        map['commentUser']['avatarColor'].toString());

    return new Comment(
      commentContent: map['commentContent'],
      date: map['createdAt'],
      commentUser:commentUser ,

    );
  }
}