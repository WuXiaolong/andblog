import 'dart:convert';

class Register{
  final int code;


  //构造函数
  Register({
    this.code,
  });

  static Register fromMap(Map<String, dynamic> map) {

    return new Register(
      code: map['code'],
    );
  }
}