import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';





class ReadPage extends StatefulWidget{
  String fictionId= "";
  String fictionName= "";
  ReadPage(this.fictionId,this.fictionName);
  @override
  State createState() {
    // TODO: implement createState
    return new _ReadPage();
  }


}

class _ReadPage extends State<ReadPage> {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays([]);
  ///设置沉浸式的方案
    // TODO: implement build
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: new Center(
              child: new Text("test"),
            ),
          )
        ],
      )
    );
  }
}