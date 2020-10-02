class AddCommentUser{

  String __type;
  String className;
  String objectId;
  //构造函数
  AddCommentUser(String __type, String className, String objectId){
    this.__type=__type;
    this.className=className;
    this.objectId=objectId;
  }
  Map toJson() {
    Map map = new Map();
    map["__type"] = this.__type;
    map["className"] = this.className;
    map["objectId"] = this.objectId;
    return map;
  }
}