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
    Future strData = Server.getChapterList(fictionId);
    strData.then((data) {
      if (data != null) {
        chapterListModel =
            ChapterListModel.fromJson(json.decode(data.toString()));
        Iterator<ChapterInfo> iterator = chapterListModel.chapterInfos.iterator;
        int start = 1;
        int i = 1;
        int all = 1;
        BigChapter big = new BigChapter();
        while (iterator.moveNext()) {
          ChapterInfo f = iterator.current;
          if (big.chapterInfos.length < 20) {
            big.chapterInfos.add(f);
          } else {
            big = new BigChapter();
            big.chapterInfos.add(f);
            start = start + 20;
            i = 1;
          }
          if (big.bigChapterName == "") {
            big.bigChapterName = "第${start}章-第${start + 20}章";
          }
          i++;
        }

        notifyListeners();
      }
    });
  }


}

class BigChapter {
  String bigChapterName = "";
  List<ChapterInfo> chapterInfos = new List();
  bool open = false;
}
