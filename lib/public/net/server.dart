import 'package:bangwu_app/public/net/DioUtils.dart';
import 'dart:convert';
import '../models/chapter.dart';
import 'UrlConfig.dart';
class Server{

  ///获取章节的文本内容
  ///
  /// fictionId : 小说的id
  /// chapterId : 章节的id
  /// needPreAndNext : 是否需要前后的章节内容 0不需要 1需要
  static Future<List<Chapter>> getChpterInfo(int fictionId,int chapterId,int needPreAndNext) async {
    String chapterUrl = UrlConfig.fictionUrl["fictionChapter"]+"?fictionid=${fictionId}&chapterid=${chapterId}&needpreandnext=${needPreAndNext}";
    String future =await DioUtils.dataFromNet(chapterUrl);
    Chapter chapter;
    if(future == null){
      print("未正常获取章节信息");
      chapter = null;
    }
    List<Chapter> chapters = new List();
    if(needPreAndNext==1){
//      json.decode(future.toString()).map((chpterjson){
//        chapters.add(new Chapter.fromJson(chpterjson));
//      });
      (json.decode(future.toString()) as List<dynamic>).forEach((dynamic){
        chapters.add(new Chapter.fromJson(dynamic));
      });

    }else{
      chapter =  new Chapter.fromJson(json.decode(future.toString()));
      chapters.add(chapter);
    }


    return chapters;
  }
}