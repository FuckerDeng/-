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
  /// 关于dart异步的详细内容可以看下：https://blog.csdn.net/devnn/article/details/90738365
  static Future<List<Chapter>> getChpterInfo(int fictionId,int chapterId,int needPreAndNext) async {
    String chapterUrl = UrlConfig.fictionUrl["fictionChapter"]+"?fictionid=${fictionId}&chapterid=${chapterId}&needpreandnext=${needPreAndNext}";
    print(chapterUrl);
    Future<String> future =DioUtils.dataFromNet(chapterUrl);
    List<Chapter> chapters = new List();
    Chapter chapter;

    ///加await表示阻塞当前线程知道await后面的内容执行完成，否则的话，这个异步方法会直接返回一个future，需要给这个future添加监听事件，处理异步完成后的结果
    await future.then((data){
      if(needPreAndNext==1){
        (json.decode(data.toString()) as List<dynamic>).forEach((chapterJson){
          print(chapterJson);
          chapter = new Chapter.fromJson(chapterJson);
          chapters.add(chapter);
        });
      }else{
        List<dynamic> jsonData = json.decode(data.toString());
        if(jsonData.length==0) return;
        chapter =  new Chapter.fromJson(jsonData[0]);
        chapters.add(chapter);
      }
    });
    return chapters;
  }
}