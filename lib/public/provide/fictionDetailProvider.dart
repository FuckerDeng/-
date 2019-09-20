import '../models/fiction_detail_page_model_entity.dart';
import '../net/server.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';

class FictionDetailProvider with ChangeNotifier{

  FictionDetailPageModelEntity fictionDetailPageModelEntity = null;
  FictionDetailPageModelFiciton showFiction;
  getData(int showFictionId)async{
    Future strData = Server.getFictionDetailPageData(showFictionId);
    strData.then((data){
      if(data!=null){
        fictionDetailPageModelEntity = FictionDetailPageModelEntity.fromJson(json.decode(data.toString()));
        Iterator<FictionDetailPageModelFiciton> iterator =fictionDetailPageModelEntity.ficitons.iterator;
        while(iterator.moveNext()){
          FictionDetailPageModelFiciton f = iterator.current;
          if(f.id==showFictionId){
            showFiction = f;
            fictionDetailPageModelEntity.ficitons.remove(f);
          }
        }
        notifyListeners();
      }
    });
  }
}