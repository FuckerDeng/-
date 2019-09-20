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
  /// 关于dart异步的详细内容可以看下：https://blog.csdn.net/yuzhiqiang_1993/article/details/89155870
  static Future<List<Chapter>> getChpterInfo(int fictionId,int chapterId,int needPreAndNext) async {
    String chapterUrl = UrlConfig.fictionUrl["fictionChapter"]+"?fictionid=${fictionId}&chapterid=${chapterId}&needpreandnext=${needPreAndNext}";
    print(chapterUrl);
//    Future<String> future =DioUtils.dataFromNet(chapterUrl);
    String future =await DioUtils.dataFromNet(chapterUrl);
    List<Chapter> chapters = new List();
    Chapter chapter;

    ///只要方法加了async，调用这个方法时就会立即返回一个future，如果想异步执行这个方法，则调用前面不加关键字await，如果不要异步执行，则前面加await
    ///加await表示阻塞当前线程直到await后面的内容执行完成，否则的话，不会等待异步方法返回的结果就继续执行后续的代码
    if(needPreAndNext==1){
        (json.decode(future) as List<dynamic>).forEach((chapterJson){
//          print(chapterJson);
          chapter = new Chapter.fromJson(chapterJson);
          chapters.add(chapter);
        });
      }else{
        List<dynamic> jsonData = json.decode(future);
        if(jsonData.length!=0){
          chapter =  new Chapter.fromJson(jsonData[0]);
          chapters.add(chapter);
        }
      }
    return chapters;
  }

  ///获取小说详情页的数据
  ///fictionId: 小说的id
  static Future<String> getFictionDetailPageData(int fictionId) async {
    String queryUrl = UrlConfig.fictionUrl["detailPage"] +"?howfictionid=${fictionId}";
    String future = await DioUtils.dataFromNet(queryUrl);
    return future;
  }

  ///获取home页的数据
  ///fictionId: 小说的id
  static Future<String> getHomePageData() async {
    String queryUrl = UrlConfig.homeUrl["homeInitData"];
    String future = await DioUtils.dataFromNet(queryUrl);
    return future;
  }

  ///获取小說页的数据
  ///fictionId: 小说的id
  static Future<String> getChapterList(int fictionid) async {
    String queryUrl = UrlConfig.fictionUrl["chapterList"]+"?fictionid=${fictionid}";
    String future = await DioUtils.dataFromNet(queryUrl);
    return future;
  }
}