
import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/login/user_info.dart';
import 'package:provider/provider.dart';

import 'andblog/list/blog_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_)=>UserInfo())
    ],
    child:MaterialApp(
      title: 'AndBlog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new BlogListPage(),
    ));
  }
}
