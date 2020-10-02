import 'package:flutter/material.dart';
import 'package:flutter_andblog/andblog/common/shared_preferences_common.dart';
class UserInfo extends ChangeNotifier {
  UserInfo() {
    getUserName();
    getAvatarColor();
  }

  //存储数据
  String _userName = "游客";

  String _avatarColor = "0xFF01579B";
  //提供外部能够访问的数据
  String get userName => _userName;

  String get avatarColor => _avatarColor;

  getUserName(){
    SharedPreferencesCommon.getUserName().then((value) {
      print("getUserName=" + value.toString());
      if(value!=null){
      _userName=value.toString();}
      notifyListeners();
    });
  }

  getAvatarColor(){
    SharedPreferencesCommon.getAvatarColor().then((value) {
      print("getAvatarColor=" + value.toString());
      if(value!=null){
        _avatarColor=value.toString();}
      notifyListeners();
    });
  }

}