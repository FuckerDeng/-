import '../models/fiction_detail_page_model_entity.dart';
import '../net/server.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';

class HomePageProvider with ChangeNotifier {
  List<FictionDetailPageModelFiction> homeFictions = new List();
  List<FictionDetailPageModelFiction> hotTui = new List();
  List<FictionDetailPageModelFiction> otherTui = new List();
  getData() async {
    String strData = await Server.getHomePageData();
    if (strData != null) {
      if (strData != null) {
        print("home页面数据获取完成：${strData.toString()}");
        for (var d in json.decode(strData.toString()) as List) {
          homeFictions.add(FictionDetailPageModelFiction.fromJson(d));
        }
        hotTui = homeFictions.getRange(0, 5).toList();
        otherTui = homeFictions.getRange(5, homeFictions.length).toList();
        notifyListeners();
      }
    }
    return strData;
  }
}
