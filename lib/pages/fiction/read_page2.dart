import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../public/my_theme.dart';
import 'dart:ui';
import 'dart:async';




class ReadPage2 extends StatefulWidget{
  String fictionId= "";
  String fictionName= "";
  ReadPage2(this.fictionId,this.fictionName);
  @override
  State createState() {
    // TODO: implement createState
    return new _ReadPage2();
  }
}

class _ReadPage2 extends State<ReadPage2> {
  List<Widget> pages = new List<Widget>();
  List<Widget> pagesRevere = new List<Widget>();
  Map<int,double> pageLeft = new Map();

  bool isFirst = true;//第一页标志
  bool isLast = false;//最后一页标志

  int nowPage = 1;
  int nowIndex = 0;
  double dragEnd = 0;
  bool changed = false;
  bool leftChanged = false;
  double dragDownDx = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages
    ..add(readPage2(1,Colors.pink))
//    ..add(readPage2(2,Colors.orange))
    ..add(readPage2(2,Colors.orange));
    pagesRevere = pages.reversed.toList();

    //每页的左右位移量进行初始化
    for(int i=0;i<pages.length;i++){
      pageLeft[i+1] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    ///设置主题
    SystemChrome.setSystemUIOverlayStyle(MyTheme.light);
    double statusTopBarHeight = MediaQuery.of(context).padding.top;
    double statusBottomBarHeight = MediaQuery.of(context).padding.bottom;
//    print("build执行了");
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
              children: getPages()
            )
        ),
        onHorizontalDragDown: (DragDownDetails details){
          print("下按的坐标：${details.globalPosition.dx}");
          dragDownDx = details.globalPosition.dx;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details){
          double nowDx = details.globalPosition.dx;
          double moviedLen = nowDx-dragDownDx;
//          print(nowPage);
          setState(() {
            changed = true;
            if(moviedLen<0){
              if(isLast){
                print("已是最后一页，尝试向左滑动");
                return;
              }
              pageLeft.update(nowPage, (value)=>(moviedLen));
              print("当前页左滑动了: ${pageLeft[nowPage]}");
            }else{
              if(isFirst){
                print("已是第一页，尝试向右滑动");
                return;
              }
              pageLeft.update(nowPage, (value)=>(pageLeft[nowPage-1]-moviedLen));
              leftChanged  = true;
            }

          });
        },
        onHorizontalDragEnd: (DragEndDetails details){
          print("当前页码：${nowPage}");
          print(pageLeft[nowPage]);
          bool left = pageLeft[nowPage].abs()>=200;
          if(isFirst){
            if(pageLeft[nowPage]<0){
//              print("执行了");
              //滑动小于屏幕的1/4
              if(pageLeft[nowPage].abs()<50){
                print("滑动小于50不翻页");
                while(pageLeft[nowPage]<0){
                  setState(() {
                    changed = true;
                    pageLeft.update(nowPage, (value)=>(pageLeft[nowPage]+2));
                  });
                  Future.delayed(new Duration(milliseconds: 2));
                }
                setState(() {
                  pageLeft.update(nowPage, (value)=>(0));
                });
                return;
              }
              //滑动大于屏幕的1/4
              if(pageLeft[nowPage].abs()<200){//屏幕的1/4，就翻页
                print("滑动大于50进行翻页");
                print(pageLeft[nowPage]);
                print(pageLeft[nowPage].abs());
                while(pageLeft[nowPage].abs()<200){//屏幕的宽度
                  setState(() {
                    changed = true;
                    pageLeft.update(nowPage, (value)=>(pageLeft[nowPage]-2));
                    print("继续左移一点");
                  });
                  Future.delayed(new Duration(milliseconds: 2));
                }
                setState(() {
                  pageLeft.update(nowPage, (value)=>(-200));
                });
                print(pageLeft[nowPage].abs());
                nowPage +=1;
                return;
              }

              //滑动大于整个屏幕
              setState(() {
                pageLeft.update(nowPage, (value)=>(-180));
              });
              nowPage +=1;

            }
          }else{

          }

        },
      )
    );
  }

  List<Widget> getPages(){
    if(changed){
      Color nowColor = Colors.pink;
      if(leftChanged){
        print("左页改变了");
        pagesRevere.removeAt(pagesRevere.length-nowPage+1);
        if(nowPage == 3){
          nowColor = Colors.orange;
        }
        pagesRevere.insert(pagesRevere.length-nowPage+1, readPage2(nowPage-1, nowColor));
        leftChanged = false;
      }else{
        print("当前页改变了");
        pagesRevere.removeAt(pagesRevere.length-nowPage);

        if(nowPage == 2){
          nowColor = Colors.orange;
        }
        if(nowPage == 3){
          nowColor = Colors.grey;
        }

//        print(pagesRevere.length-nowPage);
        (pagesRevere.length-nowPage)==-1?pagesRevere.add(readPage2(nowPage, nowColor)):pagesRevere.insert(pagesRevere.length-nowPage, readPage2(nowPage, nowColor));

      }
      changed = false;
    }
    return pagesRevere;
  }

  checkNums(){
    TextPainter();
  }

  Widget readPage2(int num,Color color){
    return new Positioned(
      top: 0,
      left: pageLeft[num],
      child: Container(
        decoration: new BoxDecoration(
          color: color,
//          boxShadow:[BoxShadow(color: Colors.grey, offset: Offset(0.5, 0.5), blurRadius: 0, spreadRadius: 2.0), BoxShadow(color: Color(0x9900FF00), offset: Offset(1.0, 1.0)), BoxShadow(color: Colors.grey)],
        ),
        width: 200+num*10.0,
        height: 200+num*10.0,

        child: new Column(
          children: <Widget>[
            new Text("1"),
            new Text("2"),
            new Text("3"),
            new Text("4"),
            new Text("5"),
            new Text("6"),
            new Text("7"),
            new Text("8"),
            new Text("9"),
            new Text("10"),
            new Text("11"),
            new Text("12"),
            new Text("12"),
          ],
        )
      ),
    );
  }

}