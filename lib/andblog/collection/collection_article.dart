class CollectionArticle{
  String articleId;
  String cover;
  String date;
  String summary;
  String title;
  //构造函数
  CollectionArticle (String articleId,String date, String cover,String title,String summary){
    this.articleId=articleId;
    this.cover=cover;
    this.date=date;
    this.title=title;
    this.summary=summary;
  }
}