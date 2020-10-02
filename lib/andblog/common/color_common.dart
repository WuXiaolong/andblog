import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';


//在flutter中，color使用的是ARGB，0x后面的就是ARGB，A就是FF表示透明度，RGB就是三原色了，
//
//比如，RGB的红色是#ff0000
//
//所以，ARGB红色我们就可以这样表示
//
//0xffff0000

class ColorCommon{
  static const Color backgroundColor = Color(0xffededed);
  static const Color dateColor = Color(0xffa6a6a6);
  static const Color titleColor = Color(0xff1b1b1b);
  static const Color summaryColor = Color(0xff808080);
  static const Color contentColor = Color(0xff1b1b1b);


  static Color slRandomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
    if (r == 0 || g == 0 || b == 0) return Colors.black;
    if (a == 0) return Colors.black;
    return Color.fromARGB(
      a,
      r != 255 ? r : Random.secure().nextInt(r),
      g != 255 ? g : Random.secure().nextInt(g),
      b != 255 ? b : Random.secure().nextInt(b),
    );
  }


  static String randomColor () {
    var letters = '0123456789ABCDEF';
    var ret = '0x';

    for (var i = 0; i < 8; i++) {
      ret += letters[Random().nextInt(letters.length)];
    }




    return ret;

  }


}