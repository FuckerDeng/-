import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class FenleiPage extends StatefulWidget{

  @override
  State createState() {
    // TODO: implement createState
    return new _FenleiPage();
  }


}

class _FenleiPage extends State<FenleiPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Text("分类页面"),
          ],
        ),
      ),
    );
  }
}