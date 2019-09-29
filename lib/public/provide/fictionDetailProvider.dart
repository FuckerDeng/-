import '../models/fiction_detail_page_model_entity.dart';
import '../net/server.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';

class FictionDetailProvider with ChangeNotifier {
  FictionDetailPageModelEntity fictionDetailPageModelEntity = null;
  FictionDetailPageModelFiction showFiction;
  getData(int showFictionId) async {
    String data = await Server.getFictionDetailPageData(showFictionId);
    if (data != null) {
      print("FictionDetailProvider--get data from：${data.toString()}");
      fictionDetailPageModelEntity =
          FictionDetailPageModelEntity.fromJson(json.decode(data.toString()));
      fictionDetailPageModelEntity.fictions.removeWhere((f) {
        if (f.id == showFictionId) {
          showFiction = f;
          return true;
        }
      });

      notifyListeners();
    }
    return data;
  }
}
