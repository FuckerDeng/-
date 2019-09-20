import '../models/fiction_detail_page_model_entity.dart';
import '../net/server.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
class HomePageProvider with ChangeNotifier{
  List<FictionDetailPageModelFiciton> homeFictions = new List();
  List<FictionDetailPageModelFiciton> hotTui =new List();
List<FictionDetailPageModelFiciton> otherTui =new List();
  getData(){
    Future strData = Server.getHomePageData();
    strData.then((data){
      if(data!=null){
        for(var d in json.decode(data.toString()) as List){
          homeFictions.add(FictionDetailPageModelFiciton.fromJson(d));
        }
        hotTui = homeFictions.getRange(0, 5).toList();
        otherTui = homeFictions.getRange(5,homeFictions.length).toList();
        notifyListeners();
      }
    });
  }
}