import 'package:flutter/material.dart';
import 'pages/myapp.dart';
import 'router/routers.dart';

void main(){
  Routers.configureRoutes();//初始化路由
  runApp(MyAppStateless());
}

class MyAppStateless extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new MaterialApp(
      title: "武邦阅读",
      theme: new ThemeData(
          primarySwatch: Colors.orange
      ),
//      debugShowMaterialGrid: true,
      debugShowCheckedModeBanner: false,
      home: new MyApp(),
    );
  }


}


