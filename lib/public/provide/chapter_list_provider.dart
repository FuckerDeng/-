import '../models/fiction_detail_page_model_entity.dart';
import '../net/server.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import '../models/chapter_list_model.dart';

class ChapterListProvider with ChangeNotifier {
  ChapterListModel chapterListModel = null;
  List<BigChapter> bigChapters = new List();

  getData(int fictionId) async {
    bigChapters.clear();
    chapterListModel = null;

    String strData = await Server.getChapterList(fictionId);
    if (strData != null) {
      print("小说章节列表内容：${strData}");
      chapterListModel =ChapterListModel.fromJson(json.decode(strData.toString()));
      Iterator<ChapterInfo> iterator = chapterListModel.chapterInfos.iterator;
      int start = 1;
      BigChapter big = new BigChapter();
      bigChapters.add(big);
      while (iterator.moveNext()) {
        ChapterInfo f = iterator.current;
        if (big.chapterInfos.length < 20) {
          big.chapterInfos.add(f);
        } else {
          big = new BigChapter();
          bigChapters.add(big);
          big.chapterInfos.add(f);
          start = start + 20;
        }
        if (big.bigChapterName == "") {
          big.bigChapterName = "第${start}章-第${start + 20-1}章";
        }
      }
      notifyListeners();
      return strData;
    }

  }
}

class BigChapter {
  String bigChapterName = "";
  List<ChapterInfo> chapterInfos = new List();
  bool open = false;
}
