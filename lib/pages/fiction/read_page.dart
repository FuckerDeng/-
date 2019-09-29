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
import 'battery_widget.dart';
//import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ReadPage extends StatefulWidget{
  String fictionId= "";
  String chapterId = "";
  ReadPage(this.fictionId,this.chapterId);
  @override
  State createState() {
    // TODO: implement createState
    return new _ReadPage();
  }
}
enum ScrollDirection{left,right}
enum PageJumpType { stay, firstPage, lastPage }
class _ReadPage extends State<ReadPage> {
  List<Widget> pages = new List<Widget>();//前、当前、下章节组成的页面

  Chapter preChapter = null;//前一章节
  Chapter nowChapter = null;//当前阅读的章节
  Chapter nextChapter = null;//下一章节

  Map<String,String> pageInfos = new Map();//分页信息
  Map<String,Object> localInfo;
  bool canScroll = true;
  bool needFenye = true;
  int start = 0;
  ScrollDirection direct = ScrollDirection.right;

  Future<void> chapterInitMethod;
  Future<void> screenInitMethod;
  Future<void> beforeRead;

  PageController pageController = new PageController(keepPage: false,viewportFraction: 1.0);
  double fontsize = ScreenUtil().setSp(45);
  double fontheight = 1.2;
  //当前章节中展示的页面index
  int nowPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localInfo = getChpterIdFromLocal(widget.fictionId,widget.chapterId);
    chapterInitMethod = getAllChapter( localInfo["chapterId"],PageJumpType.stay);
    pageController.addListener(scrollLinstener);
  }



  //从网络获取章节信息
  Future<List<Chapter>> getAllChapter(int chapterId,PageJumpType jumpType) async{
    Future<List<Chapter>> fromNet = Server.getChpterInfo(int.parse(widget.fictionId),chapterId,1);
    List<Chapter> c= null;
    await fromNet.then((chapters){
      if(chapters.length ==0){
        print("未获取到章节信息");
        return [];
      }
      for(Chapter c in chapters){
        if(c.chapterId == chapterId-1){
          preChapter = c;
          fenye(preChapter);
        }
        if(c.chapterId == chapterId){
          nowChapter = c;
          fenye(nowChapter);
        }
        if(c.chapterId == chapterId+1){
          nextChapter = c;
          fenye(nextChapter);
        }
      }
      if (jumpType == PageJumpType.firstPage) {
        nowPage = 0;
      } else if (jumpType == PageJumpType.lastPage) {
        nowPage = nowChapter.pageStrs.length - 1;
      }
      if (jumpType != PageJumpType.stay) {
        pageController.jumpToPage((preChapter != null ? preChapter.pageStrs.length : 0) + nowPage);
      }
      setState(() {
        print("上一章和下一章信息获取完成，需要重新构建");
      });
      c= chapters;

    });
    print("完成！");
    return c;
  }

  ///获取下一章节信息
  Future getNextChapter(int chapterId) async {
    if(nextChapter!=null || canScroll==false || chapterId<=0){
      return;
    }
    canScroll = false;
    Future<List<Chapter>> fromNet = Server.getChpterInfo(int.parse(widget.fictionId),chapterId,0);
    await fromNet.then((chapters){
      if(chapters.length ==0){
        print("未获取到章节信息:chapterId=${chapterId}");
        canScroll = true;
        return ;
      }
      nextChapter = chapters[0];
      fenye(nextChapter);
      canScroll = true;
      setState(() {
        print("下一章信息获取完成，需要重新构建");
      });

    });
    print("完成");
  }

  ///获取上一章节信息
  Future getPreChapter(int chapterId) async {
    if(preChapter!=null || canScroll==false || chapterId<=0){
      return;
    }
    canScroll = false;
    List<Chapter> fromNet = await Server.getChpterInfo(int.parse(widget.fictionId),chapterId,0);
    var startTime = new DateTime.now().second;
    if(fromNet.length ==0){
      print("未获取到章节信息:chapterId=${chapterId}");
      canScroll = true;
      return ;
    }

    preChapter = fromNet[0];
    fenye(preChapter);


//    await fromNet.then((chapters){
//      if(chapters.length ==0){
//        print("未获取到章节信息:chapterId=${chapterId}");
//        canScroll = true;
//        return ;
//      }
//
//      preChapter = chapters[0];
//      fenye(preChapter);
//      canScroll = true;
//      setState(() {
//        print("上一章信息获取完成，需要重新构建");
//        });
//
//    });
    var endTime = new DateTime.now().second;
    print("章节分页用时 ${endTime-startTime} 秒！");
    pageController.jumpToPage(preChapter.pageStrs.length+nowPage);
    setState(() {
      print("上一章信息获取完成，需要重新构建");
    });
    canScroll = true;
  }

  //从本地获取上次读取章节的信息:以后用sqlflite存储数据
  Map<String,int> getChpterIdFromLocal(String fictionId,String chapterId){
    Map<String,int> localInfo = new Map();
    localInfo["chapterId"] = int.parse(chapterId);
    localInfo["readPage"] = 1;
    return localInfo;

  }

  ///对章节进行分页
  fenye(Chapter chapter){
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
    Future.delayed(new Duration(milliseconds: 5));
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new FutureBuilder(
            future: this.chapterInitMethod,
            builder: (BuildContext context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return readBody(context);
              }else{
                if(nowChapter==null){
                  return new Center(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new CircularProgressIndicator(),//转圈的加载动画
//            new Image.asset("res/imgs/waitting.gif",width: 50,height: 50,fit: BoxFit.cover,),
                        new Text("    加载处理中...")
                      ],
                    ),
                  );
                }
              }

        })
    );
  }

  Widget readBodyOld(BuildContext context){
    new FutureBuilder(
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

          int pageCount = (preChapter==null?0:preChapter.pageStrs.length)+(nowChapter==null?0:nowChapter.pageStrs.length)+(nextChapter==null?0:nextChapter.pageStrs.length);
          var showChapter;
          return PageView.builder(
            controller: pageController,
            itemCount: pageCount,
            itemBuilder: (context,index){
              print("index:${index}");
              int nowPageIndex = index -  (preChapter==null?0:preChapter.pageStrs.length-1);
              print(nowPageIndex);
              if(nowPageIndex>=nowChapter.pageStrs.length){
                //翻到下一章节
                showChapter = nextChapter;
                nowPageIndex = 0;
              }else if(pageCount<0){
                //翻到上一章节
                showChapter = preChapter;
                nowPageIndex = preChapter.pageStrs.length-1;
              }else{
                showChapter = nowChapter;
              }
              var p = createReadPage(showChapter,nowPageIndex,pageCount,context);
              return p;
            },
            onPageChanged: (index){
              var page = index - (preChapter != null ? preChapter.pageStrs.length : 0);
              if (page < nowChapter.pageStrs.length && page >= 0) {
                setState(() {
                  nowPage = page;
                });
              }
            },
          );
        }
      },
    );
  }

  Widget readBody(BuildContext context){
    int prePageNum = (preChapter==null?0:preChapter.pageStrs.length);
    int nowPageNum = (nowChapter==null?0:nowChapter.pageStrs.length);
    int nextPageNum = (nextChapter==null?0:nextChapter.pageStrs.length);
    print("readBody-prePageNum=${prePageNum}===nowPageNum=${nowPageNum}===nextPageNum=${nextPageNum}");
    int pageCount = prePageNum+nowPageNum+nextPageNum;
    var showChapter;
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: pageCount,
      itemBuilder: (context,index){
        print("builder-开始构建");
        print("builder-index:${index}");
        int nowPageIndex = index -  (preChapter==null?0:preChapter.pageStrs.length);

        if(nowPageIndex>=nowChapter.pageStrs.length){
          //翻到下一章节
          print("builder-翻到下一张");
          showChapter = nextChapter;
          nowPageIndex = 0;
        }else if(nowPageIndex<0){

            //翻到上一章节
            print("builder-翻到上一张");
            showChapter = preChapter;
            nowPageIndex = preChapter.pageStrs.length-1;

        }else{
          showChapter = nowChapter;
        }
        print("builder-nowPageIndex=${nowPageIndex}");
        var p = createReadPage(showChapter,nowPageIndex,pageCount,context);
        return p;
      },
      onPageChanged: (index){
        var page = index - (preChapter != null ? preChapter.pageStrs.length : 0);
        if (page < nowChapter.pageStrs.length && page >= 0) {
          setState(() {
            nowPage = page;
          });
        }
      },
    );
  }

  Widget createReadPage(Chapter showChapter,int nowPageIndex,int allNum,BuildContext context) {
    return readPage2("${showChapter.chapterId}-${nowPageIndex+1}#${showChapter.title}", context, showChapter.pageStrs[nowPageIndex], allNum);
  }

  ///阅读页面,包含顶部的章节标题部分，底部电量，页数部分，中间正文部分
  Widget readPage2(String num,BuildContext context,String txt,int allPageNum){
    DateTime dateTime = DateTime.now();
    var time = "${dateTime.hour}:${dateTime.minute}";
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
                  new BatteryView(),
                  new Text(
                      time,
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
    if(xPosition>=0.55){

      if(nowPage>=(nowChapter.pageStrs.length-1) && nextChapter==null){
        Fluttertoast.showToast(msg: "已经是最后一页了",gravity: ToastGravity.CENTER);
        return;
      }
      print("阅读页面右侧被点击了,向后翻页");
      pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    }else if(xPosition<=0.45){
      print("阅读页面左侧被点击了，向前翻页");
      if(nowPage==0 && preChapter==null){
        Fluttertoast.showToast(msg: "已经是第一页了",gravity: ToastGravity.CENTER);
        return;
      }
      pageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
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
    if(!canScroll) {
//      Fluttertoast.showToast(msg: "从网络获取内容中...",gravity: ToastGravity.CENTER);
      return;
    };
    var pageOffset = pageController.offset/Screen.width;

    print("scrollLinstener-pageOffset=${pageOffset}");
    var nextChapterIndex = nowChapter.pageStrs.length +(preChapter==null?0:preChapter.pageStrs.length);
    if (pageOffset >= nextChapterIndex) {
      print('scrollLinstener-到达下个章节了');

      preChapter = nowChapter;
      nowChapter = nextChapter;
      nextChapter = null;
      nowPage = 0;
      pageController.jumpToPage(preChapter.pageStrs.length);
      getNextChapter(nowChapter.chapterId+1);
      setState(() {});

    }
    if (preChapter != null && pageOffset <= preChapter.pageStrs.length - 1) {

      print('scrollLinstener-到达上个章节了');
      nextChapter = nowChapter;
      nowChapter = preChapter;
      preChapter = null;
      nowPage = nowChapter.pageStrs.length - 1;
      pageController.jumpToPage(nowChapter.pageStrs.length - 1);
      getPreChapter(nowChapter.chapterId-1);
      setState(() {});


    }

  }
}