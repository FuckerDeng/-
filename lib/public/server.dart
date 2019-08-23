import 'DioUtils.dart';
import 'dart:convert';
import 'models/chapter.dart';
import 'UrlConfig.dart';
class Server{

  static Future<Chapter> getChpterInfo(int fictionId,int chapterId)async{
    String chapterUrl = UrlConfig.fictionUrl["fictionChapter"]+"?fictionid=${fictionId}&chapterid=${chapterId}";
    Future future = DioUtils.dataFromNet(chapterUrl);
    Chapter chapter;
    if(future == null){
      print("未正常获取章节信息");
      chapter = null;
    }
    future.then((data){
      chapter = new Chapter.fromJson(json.decode(data));
    });
    return chapter;
  }
}