// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Detail _$DetailFromJson(Map<String, dynamic> json) {
  return Detail(
    content: json['content'] as String,
    cover: json['cover'] as String,
    date: json['date'] as String,
    objectId: json['objectId'] as String,
    summary: json['summary'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'content': instance.content,
      'cover': instance.cover,
      'date': instance.date,
      'objectId': instance.objectId,
      'summary': instance.summary,
      'title': instance.title,
    };
