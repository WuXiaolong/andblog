import 'package:flutter/material.dart';

import 'andblog/detail/detail_page.dart';
import 'andblog/list/blog_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AndBlog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new BlogListPage(),
    );
  }
}
