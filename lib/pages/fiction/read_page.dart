import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../public/my_theme.dart';




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
  List<Widget> pages = new List<Widget>();
  Map<int,double> pageLeft = new Map();
  int nowPage = 1;
  int nowIndex = 0;
  double dragEnd = 0;
  bool changed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages
    ..add(readPage2(1,Colors.pink))
    ..add(readPage2(2,Colors.orange))
    ..add(readPage2(3,Colors.grey));
    pageLeft[1] = 0;
    pageLeft[2] = 0;
    pageLeft[3] = 0;
  }

  @override
  Widget build(BuildContext context) {
    ///设置主题
    SystemChrome.setSystemUIOverlayStyle(MyTheme.light);
    double statusTopBarHeight = MediaQuery.of(context).padding.top;
    double statusBottomBarHeight = MediaQuery.of(context).padding.bottom;
    print("build执行了");
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new GestureDetector(
        child: new Container(
            width: double.infinity,
            height: double.infinity,//撑满整个屏幕
            padding: EdgeInsets.fromLTRB(10, statusTopBarHeight, 10, statusBottomBarHeight),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
            ),
            child:new Stack(
              children: <Widget>[
                readPage2(1,Colors.red)
              ]
            )
        ),
        onHorizontalDragUpdate: (DragUpdateDetails details){
          setState(() {
            pageLeft.update(nowPage, (value)=>(value+details.delta.dx));
            changed = true;
            print("滑动了，dragEnd:${pageLeft[nowPage]}");
          });
        },
        onHorizontalDragEnd: (DragEndDetails details){
          print("结束");
        },
      )
    );
  }

  List<Widget> getPages(){
    if(changed){
      print("改变了");
      pages.removeAt(nowPage-1);
      pages.insert(nowPage-1, readPage2(nowPage, Colors.red));
      changed = false;
    }
    return pages.reversed.toList();
  }


  Widget readPage2(int num,Color color){
    return new Positioned(
      top: 0,
      left: pageLeft[num-1],
      child: Container(
        width: 200+num*10.0,
        height: 200+num*10.0,
        color: color,
        child: new Text("${num}"),
      ),
    );
  }

}