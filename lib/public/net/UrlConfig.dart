
class UrlConfig{
  static String baseUrl = "http://47.93.0.72:8080/study/";

  static String fictionModelUrl = "fiction/";
  static Map<String,String> fictionUrl = {
    "fictionItems":baseUrl+fictionModelUrl+"fictions",
    "fictionChapter":baseUrl +fictionModelUrl+"chapter"
  };
}