class HttpCommon{

  static var blog_list_url = 'https://api2.bmob.cn/1/classes/ArticleTable/';

  static Map<String, String> headers(){
    //设置header
    Map<String, String> headers = new Map();
    headers["X-Bmob-Application-Id"] = "b2190c8fae9e79f86c2ebf19869a66c6";
    headers["X-Bmob-REST-API-Key"] = "c6b8dfb1bd1a7a19ce0d8b5c3cfc1d08";
    headers["Content-Type"] = "application/json";
    return headers;
  }

}