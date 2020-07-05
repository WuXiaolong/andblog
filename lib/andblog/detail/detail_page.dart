import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detail.dart';
//import 'dart:convert' as convert;


class DetailPage extends StatefulWidget {
  @override
  DetailPageState createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  Detail detail;

  @override
  void initState() {
    super.initState();
    //一进页面就请求接口，一开始不知道这个 initState 方法 ，折腾了很久
    getDetailData();
  }

  //网络请求
  getDetailData() async {
    var url = 'https://api2.bmob.cn/1/classes/ArticleTable/ct7BGGGV';

    //设置header
    Map<String, String> headers = new Map();
    headers["X-Bmob-Application-Id"] = "b2190c8fae9e79f86c2ebf19869a66c6";
    headers["X-Bmob-REST-API-Key"] = "c6b8dfb1bd1a7a19ce0d8b5c3cfc1d08";
    headers["Content-Type"] = "application/json";
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
//      var jsonResponse = convert.jsonDecode(response.body);
//      var jsonData = await response.transform(utf8.decoder).join();
      // setState 相当于 runOnUiThread
      setState(() {
        var data = json.decode(response.body);
        detail = Detail.fromJson(data);
        print('title='+detail.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('qq'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}