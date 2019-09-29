import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/search/search_page.dart';
import '../pages/fiction/fiction_detail_page.dart';
import '../pages/fiction/chapter_list_page.dart';
import '../pages/fiction/read_page.dart';

class RouterHandler{
  ///搜索页面
  static Handler searchPageHandler = new Handler(//handler类的handlerFunc生成页面组件
      handlerFunc: (context,paramis){
        return new SearchPage();
      }
  );

  ///小说详情页面
  static Handler fictionDetailHandler =  new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> paramis){
        var fictionid = paramis["fictionid"]?.first;//获取路由路径中的参数：page2?msg=xxx&msg2=xxx
        return new FictionDetailPage(fictionid);
      }
  );

  ///小说章节页面
  static Handler fictionChapterListHandler = new Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> paramis){
      var fictionId = paramis["fictionid"]?.first;//获取路由路径中的参数：page2?msg=xxx&msg2=xxx
      var fictionName = paramis["fictionname"]?.first;//获取路由路径中的参数：page2?msg=xxx&msg2=xxx
//      print("收到参数  ${fictionName}");
//      fictionName = Uri.decodeComponent(fictionName);
      print("收到参数 ${fictionId}+${fictionName}");
      return new ChapterListPage(fictionId,fictionName);
    }
  );

  ///小说阅读页面
  static Handler fictionReaderHandler = new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> paramis){
        var fictionId = paramis["fictionid"]?.first;//获取路由路径中的参数：page2?msg=xxx&msg2=xxx
        var chapterId = paramis["chapterid"]?.first;//获取路由路径中的参数：page2?msg=xxx&msg2=xxx
        if(chapterId==null){
          chapterId=="1";
        }
        return new ReadPage(fictionId,chapterId);
      }
  );
}