
class UrlConfig{
  static String baseUrl = "http://47.93.0.72:8080/study/";

  static String fictionModelUrl = "fiction/";
  static Map<String,String> fictionUrl = {
    "fictionItems":baseUrl+fictionModelUrl+"fictions",
    "fictionChapter":baseUrl +fictionModelUrl+"chapter",//小说章节内容url：chapter?fictionid=1&chapterid=1&needpreandnext=1    needpreandnext:是否查询前后章节，1是0否
    "detailPage":baseUrl +fictionModelUrl+"detailpage",//小说详情页面url：detailpage?howfictionid=1
    "chapterList":baseUrl+fictionModelUrl+"chapterlist"//小说章节列表url：chapterlist?fictionid=1
  };

  static String homeModelUrl = "home/";
  static Map<String,String> homeUrl = {
    "homeInitData":baseUrl+homeModelUrl+"initdata"//home页面初始化数据url
  };
}