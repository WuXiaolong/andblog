import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCommon {

  static Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin');
  }

  static Future<void> saveLogin(bool isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", isLogin).then((bool success) {
      print("saveLogin success");
    });
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<void> saveUserName(String userName ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userName", userName).then((bool success) {
      print("saveLogin success");
    });
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> saveUserId(String userName ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userName).then((bool success) {
      print("saveLogin success");
    });
  }

  static Future<String> getAvatarColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('avatarColor');
  }

  static Future<void> saveAvatarColor(String avatarColor ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("avatarColor", avatarColor).then((bool success) {
      print("saveLogin success");
    });
  }

}
