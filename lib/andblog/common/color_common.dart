import 'dart:ui';


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
}