import 'dart:convert';

import 'package:flutter_andblog/andblog/collection/collection_article.dart';


class Collection{
  final String collectionUserId;
  final CollectionArticle collectionArticle;

  //构造函数
  Collection  ({
    this.collectionUserId,
    this.collectionArticle,
  });

  static List<Collection> decodeData(String jsonData) {
    List<Collection> commentList = new List<Collection>();
    var data = json.decode(jsonData);
    var results = data['results'];
    for (int i = 0; i < results.length; i++) {
      commentList.add(fromMap(results[i]));
    }
    return commentList;
  }

  static Collection fromMap(Map<String, dynamic> map) {
    final CollectionArticle collectionArticle=new CollectionArticle(
        map['collectionArticle']['objectId'].toString(),
        map['collectionArticle']['date'].toString(),
        map['collectionArticle']['cover'].toString(),
      map['collectionArticle']['title'].toString(),
      map['collectionArticle']['summary'].toString(),

    );

    return new Collection(
      collectionUserId: map['collectionUserId'],
      collectionArticle:collectionArticle ,

    );
  }
}