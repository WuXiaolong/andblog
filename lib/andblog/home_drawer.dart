import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/collection/collection_page.dart';
import 'package:flutter_andblog/andblog/login/login_page.dart';
import 'package:flutter_andblog/andblog/login/user_info.dart';
import 'package:provider/provider.dart';

import 'common/color_common.dart';
import 'common/shared_preferences_common.dart';

class HomeDrawerBuilder {
  static UserAccountsDrawerHeader userAccountsDrawerHeader;
  BuildContext context;
  bool isLogin;

  HomeDrawerBuilder(this.context);

  Widget homeDrawer(BuildContext context) {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      _drawerHeader(context),
      new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: Icon(Icons.collections)),
          title: new Text('我的收藏'),
          onTap: () {
            Navigator.of(context).pop();
            initLogin(1);
          },
        ),
      ),
//      new ListTile(
//        leading: new CircleAvatar(child: new Text("B")),
//        title: new Text('Drawer item B'),
//        subtitle: new Text("Drawer item B subtitle"),
//        onTap: () => {},
//      ),
      Divider(), // 增加一条线
      new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: Icon(Icons.settings)),
          title: new Text('关于我们'),
          onTap: () {
            _showDialog();
          },
        ),
      ),
      Divider(), // 增加一条线
    ]);
  }

  Future _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(
              title: new Text("菜鸟博客"),
              content: new Text("每天精选一篇博客。"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        }
    );
  }

  initLogin(int type) {
    SharedPreferencesCommon.isLogin().then((value) {
      print("isLogin=" + value.toString());
      if (value != null && value) {
        switch (type) {
          case 1:
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (BuildContext context) {
              return new CollectionPage();
            }));
            break;
          case 2:
            break;
        }
      } else {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (BuildContext context) {
          return new LoginPage();
        }));
      }
    });
  }

  static Widget _drawerHeader(BuildContext context) {
    userAccountsDrawerHeader = new UserAccountsDrawerHeader(
      accountName: new Text("${Provider.of<UserInfo>(context).userName}",
          style: TextStyle(color: Colors.white, fontSize: 22)),
      currentAccountPicture: new CircleAvatar(
          backgroundColor:
              Color(int.parse("${Provider.of<UserInfo>(context).avatarColor}")),
          child: new Text(
              "${Provider.of<UserInfo>(context).userName}".substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 20))),
      // onDetailsPressed: () {},
//      otherAccountsPictures: <Widget>[
//        new CircleAvatar(
//          backgroundImage: new AssetImage("images/ymj_shuijiao.gif"),
//        ),
//      ],
    );
    return userAccountsDrawerHeader;
  }
}
