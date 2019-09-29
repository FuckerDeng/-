import 'package:dio/dio.dart';
import 'dart:convert';
//import 'dart:mirrors';
import '../models/chapter.dart';


class DioUtils{
  static  Future<String> dataFromNet(String url) async{
    try{
//      Response response = await Dio().get("http://127.0.0.1:8080/fictons");
      print("DioUtils--get data from：${url}");
      Response response = await Dio().get(url);
//      print("DioUtils-get data from net: ${response.data.toString()}");
      return response.data;
    }catch(e){
      print("DioUtils:dataFromNet==>${e}");
      return null;
    }
  }

}