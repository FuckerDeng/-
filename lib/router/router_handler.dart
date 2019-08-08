import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/search/search_page.dart';
import '../pages/fiction/fiction_detail_page.dart';

class RouterHandler{
  static Handler searchPageHandler = new Handler(//handler类的handlerFunc生成页面组件
      handlerFunc: (context,paramis){
        return new SearchPage();
      }
  );

  static Handler fictionDetailHandler =  new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> paramis){
        var msg = paramis["msg"]?.first;//获取路由路径中的参数：page2?msg=xxx&msg2=xxx
        return new FictionDetailPage();
      }
  );
}