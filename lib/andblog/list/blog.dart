import 'dart:convert';

class Blog{
  final String content;
  final String cover;
  final String date;
  final String objectId;
  final String summary;
  final String title;

  //构造函数
  Blog({
    this.content,
    this.cover,
    this.date,
    this.objectId,
    this.summary,
    this.title,
  });

  static List<Blog> decodeData(String jsonData) {
    List<Blog> blogList = new List<Blog>();
    var data = json.decode(jsonData);
    var results = data['results'];
    print('results='+results[0]['content']);
    for (int i = 0; i < results.length; i++) {
      blogList.add(fromMap(results[i]));
    }
    return blogList;
  }

  static Blog fromMap(Map<String, dynamic> map) {

    return new Blog(
      content: map['content'],
      cover: map['cover'],
      date: map['date'],
      objectId: map['objectId'],
      summary: map['summary'],
      title: map['title'],
    );
  }
}