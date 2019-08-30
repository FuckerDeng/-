import "package:flutter/material.dart";

import 'package:flutter/services.dart';
import '../../public/my_theme.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../public/global.dart';
import 'package:bangwu_app/public/net/server.dart';
import '../../public/models/chapter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../public/screen.dart';



class ReadPage extends StatefulWidget{
  String fictionId= "";
  ReadPage(this.fictionId);
  @override
  State createState() {
    // TODO: implement createState
    return new _ReadPage();
  }
}

class _ReadPage extends State<ReadPage> {
  List<Widget> pages = new List<Widget>();//前、当前、下章节组成的页面

  Chapter preChapter = null;//前一章节
  Chapter nowChapter = null;//当前阅读的章节
  Chapter nextChapter = null;//下一章节

  Map<String,String> pageInfos = new Map();//分页信息
  Map<String,Object> localInfo;
  bool isFirst = true;//第一页标志
  bool isLast = false;//最后一页标志
  bool needFenye = true;

  Future<void> chapterInitMethod;
  Future<void> screenInitMethod;
  Future<void> beforeRead;

  PageController pageController = new PageController(keepPage: false);
  double fontsize = ScreenUtil().setSp(45);
  double fontheight = 1.2;
  int nowPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localInfo = getChpterIdFromLocal(widget.fictionId);
    chapterInitMethod = getNextChapter( localInfo["chapterId"]);
    pageController.addListener(scrollLinstener);
  }



  //从网络获取章节信息
  Future<void> getNextChapter(int chapterId) async{

    Future<List<Chapter>> fromNet = Server.getChpterInfo(int.parse(widget.fictionId),chapterId,1);
    await fromNet.then((chapters){
      if(chapters.length ==0){
        print("未获取到章节信息");
        return ;
      }
      for(Chapter c in chapters){
        if(c.chapterId == chapterId-1){
          preChapter = c;
        }
        if(c.chapterId == chapterId){

          nowChapter = c;
        }
        if(c.chapterId == chapterId+1){
          nextChapter = c;
        }
      }
    });
  }

  //从本地获取上次读取章节的信息:以后用sqlflite存储数据
  Map<String,int> getChpterIdFromLocal(String fictionId){
    Map<String,int> localInfo = new Map();
    localInfo["chapterId"] = 1;
    localInfo["readPage"] = 1;
    return localInfo;

  }

  ///对章节进行分页
  checkCheck(Chapter chapter){
    TextPainter painter = TextPainter();
    String testStr = "　　"+chapter.content;
    testStr = testStr.replaceAll("\n", "\n　　");
    List<String> pageStrs = new List();
    int start = 0;
    while(true){
      painter
        ..textDirection = TextDirection.ltr
        ..text = new TextSpan(text: testStr,style:readFontTextStyle(fontsize, fontheight))
        ..layout(maxWidth:  Screen.width-20);
      int end = painter.getPositionForOffset(new Offset(Screen.width-20, Screen.height-Screen.topSafeHeight-Screen.bottomSafeHeight-60)).offset;
      
      if(end==0) {
        break;
      };
      String pageStr = testStr.substring(start,end);
      if(pageStr.substring(0,1)=="\n"){
        pageStr = pageStr.substring(1);
      }
      testStr = testStr.substring(end);
      pageStrs.add(pageStr);

    }
    chapter.pageStrs = pageStrs;
  }


  Future beforeReadInit() async {
    await Future.wait([this.screenInitMethod,this.chapterInitMethod]);
  }

  @override
  Widget build(BuildContext context) {

    ///设置主题
    SystemChrome.setSystemUIOverlayStyle(MyTheme.light);

    return new Scaffold(
        backgroundColor: Colors.white,
        body: new FutureBuilder(
          future: this.chapterInitMethod,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              print("等待中。。。");
              return new Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(),//转圈的加载动画
                    new Text("    加载处理中...")
                  ],
                )
              );
            }else if(snapshot.connectionState==ConnectionState.done){
              ///对章节进行分页
              if(needFenye){
                if(preChapter!=null) {
                  checkCheck(preChapter);
                  updatePages(preChapter,context);
                };
                if(nowChapter!=null) {
                  checkCheck(nowChapter);
                  updatePages(nowChapter,context);
                };
                if(nextChapter!=null) {
                  checkCheck(nextChapter);
                  updatePages(nextChapter,context);
                };
                needFenye = false;




              }


              return new PageView(
//                physics: BouncingScrollPhysics(),
                physics: BouncingScrollPhysics(),
                controller: pageController,
                scrollDirection: Axis.horizontal,
                children: pages,
                onPageChanged: (index){
                  print(index);
                  setState(() {
                    nowPage = index;
                  });
                },

              );
            }
          },
        )
    );
  }

  needPreOrNextChater(){
    int allPage = 0;
    if(preChapter!=null){
      allPage +=preChapter.pageStrs.length;
    }
    if(nowChapter!=null){
      allPage +=nowChapter.pageStrs.length;
    }
    if(nextChapter!=null){
      allPage +=nextChapter.pageStrs.length;
    }
    if(preChapter!=null && nowPage==(preChapter.pageStrs.length-1)){

    }
  }

  updatePages(Chapter chapter,BuildContext context){
    int i = 1;
    for(String str in chapter.pageStrs){
      pages.add(readPage2("${chapter.chapterId}-${i++}#${chapter.title}",context,str,chapter.pageStrs.length));
    }
  }

  ///阅读页面,包含顶部的章节标题部分，底部电量，页数部分，中间正文部分
  Widget readPage2(String num,BuildContext context,String txt,int allPageNum){
//    print("第${num}页内容：${txt}");
    return new Container(
      width: Screen.width,
      height: Screen.height,
      padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight,5,Screen.bottomSafeHeight),
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.red)
      ),
      child: new Stack(
        children: <Widget>[
          new Container(//中间正文部分
            width: Screen.width,
            height: Screen.screenContentHeight,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            decoration: new BoxDecoration(
              border: Border.all(color: Colors.red)
            ),
            child:new GestureDetector(
              child: new Text(
                txt,
                style: readFontTextStyle(fontsize,fontheight)
              ),
              onTapUp: readSectionOnTap
            )
          ),
          new Positioned(//页面顶部小说章节名字
            top: 0,
            left: 0,
            child: new Row(
              children: <Widget>[
                new Text(
                    "${num.split("#")[1]}",
                  style: readFontTextStyle(fontsize-5,1)
                ),
              ],
            ),
          ),
          new Positioned(//页面底部电量和页码现实部分
            bottom: 0,
            left: 15,
            child: new Container(
              width: Global.screenWidth-30,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                      "电量信息",
                    style:readFontTextStyle(fontsize-5,1)
                  ),
                  new Text(
                      "${num.split("#")[0]}",
                      style:readFontTextStyle(fontsize-5,1)
                  ),
                  new Text(
                    "${1}/${allPageNum}",
                    style: readFontTextStyle(fontsize-5,1)
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }

  ///阅读区域点击时的响应
  void readSectionOnTap(TapUpDetails tapUpDetail){
    double xPosition = tapUpDetail.globalPosition.dx.abs()/(ScreenUtil.screenWidth/2);
    if(xPosition>=0.5){
      if(nowPage == pages.length-1){
        Fluttertoast.showToast(msg: "已经是最后一页了",gravity: ToastGravity.CENTER);
        print("最后一页了");

        return;
      }
      print("页面右侧被点击了");
//                  pageController.jumpToPage(nowPage);
      print(nowPage);
      pageController.animateToPage(nowPage+1, duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        nowPage++;
      });
    }else {
      print("页面左侧被点击了");
      if(nowPage == 0){
        Fluttertoast.showToast(msg: "已经是第一页了",gravity: ToastGravity.CENTER);
        print("第一页了");
        return;
      }
      print(nowPage);
      pageController.animateToPage(nowPage-1, duration: new Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        nowPage--;
      });
    }
  }


  ///阅读区域文字样式
  TextStyle readFontTextStyle(double fontsize,double fontheight){
    return new TextStyle(
      height: fontheight,
      fontSize: fontsize,
    );
  }

  scrollLinstener(){
//    pageController.offset 为滑动的总距离
    double pageOffset = pageController.offset/Screen.width;
    print(pageOffset);
  }
}