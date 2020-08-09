import 'package:json_annotation/json_annotation.dart';

import 'dart:convert';
//为了使实体类文件找到生成文件，需要 part 'blog_detail.g.dart'
part 'blog_detail.g.dart';

@JsonSerializable()
class Detail{
  final String content;
  final String cover;
  final String date;
  final String objectId;
  final String summary;
  final String title;

  //构造函数
  Detail({
    this.content,
    this.cover,
    this.date,
    this.objectId,
    this.summary,
    this.title,
  });

  //以下两个方法待解析完成添加
  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

  Map<String, dynamic> toJson() => _$DetailToJson(this);

}