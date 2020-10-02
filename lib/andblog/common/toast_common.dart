import 'package:fluttertoast/fluttertoast.dart';

class ToastCommon{


  static showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }


}