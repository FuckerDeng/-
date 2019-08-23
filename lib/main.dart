import 'package:flutter/material.dart';
import 'pages/myapp.dart';
import 'router/routers.dart';
import 'package:provide/provide.dart';

void main(){
  Routers.configureRoutes();//初始化路由

//  var counter = new Counter();//数据源
  var providers = new Providers();//数据仓库管理类的对象，管理仓库（provide)
//  providers
//    ..provide(Provider<Counter>.value(counter)); //将数据源加入仓库，再讲仓库加入仓库管理对象，有多个数据源时，直接在后面添加
  runApp(new ProviderNode(child: MyAppStateless(), providers: providers));//将应用的根类设置为ProviderNode,用此根类来监听所有子节点的状态，子节点可以调用管理类管理的数据仓库和源
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


