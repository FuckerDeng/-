import 'package:dio/dio.dart';
//import 'dart:mirrors';

class DioUtils{
  static  Future dataFromNet(String url) async{
    try{
//      Response response = await Dio().get("http://127.0.0.1:8080/fictons");
      Response response = await Dio().get(url);
      print(response.data.toString());
      return response.data;
    }catch(e){
      print("DioUtils:dataFromNet==>"+e);
      return null;
    }
  }
}