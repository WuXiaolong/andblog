import 'dart:convert';

import 'package:flutter_andblog/andblog/collection/collection_article.dart';


class AddCollection{
  final String collectionUserId;
  final CollectionArticle collectionArticle;

  //构造函数
  AddCollection({
    this.collectionUserId,
    this.collectionArticle,
  });

}