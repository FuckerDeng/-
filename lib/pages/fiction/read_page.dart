import "package:flutter/material.dart";

import 'package:flutter/services.dart';
import '../../public/my_theme.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../public/global.dart';
import '../../public/server.dart';
import '../../public/models/chapter.dart';



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
  List<Widget> pages = new List<Widget>();
  Chapter nowChapter;
  Map<int,String> pageInfos = new Map();//分页信息
  Map<String,Object> localInfo;
  bool isFirst = true;//第一页标志
  bool isLast = false;//最后一页标志
  bool needFenye = true;

  PageController pageController = new PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localInfo = getChpterIdFromLocal(widget.fictionId);
    Server.getChpterInfo(int.parse(widget.fictionId), localInfo["chapterId"]).then((chapter){
      if(chapter==null){
        print("未获取到章节信息");
        return;
      }
      nowChapter = chapter;
    });
  }

  //从本地获取上次读取章节的信息:以后用sqlflite存储数据
  Map<String,String> getChpterIdFromLocal(String fictionId){
    Map<String,Object> localInfo = new Map();
    localInfo["chapterId"] = 1;
    localInfo["readPage"] = 1;
    return localInfo;

  }
  ///计算阅读页面每行的字数或整个屏幕文字的行数
  initReadPageNum(BuildContext context,bool checkRow){
    String txt = "中";

    if(checkRow){
      print("初始化行的字数");
      while(!checkRowFull1(new TextSpan(text: txt,style: new TextStyle(fontSize: ScreenUtil().setSp(36))), context,checkRow)){
//      print("增加字符");
        txt +="中";
      }
      Global.readPageRowWorldNum = txt.length-1;
    }else{
      print("初始化列数");
      while(!checkScreenFull(new TextSpan(text: txt,style: new TextStyle(fontSize: ScreenUtil().setSp(36))), context,checkRow)){
//      print("增加字符");
        txt +="中";
      }
      double cNum = (txt.length-1)/Global.readPageRowWorldNum;
      Global.readPageColoumNum = cNum.toInt();
    }
  }

  ///文字未超过整个屏幕返回false，超过则返回true
  bool checkRowFull1(TextSpan span,BuildContext context,bool checkRow){
    TextPainter painter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = span
      ..maxLines = 1
      ..layout(maxWidth: MediaQuery.of(context).size.width-20);
    return painter.didExceedMaxLines || painter.size.height>(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom-50);
  }

  ///文字未超过整个屏幕返回false，超过则返回true
  bool checkScreenFull(TextSpan span,BuildContext context,bool checkRow){
    TextPainter painter = TextPainter()
      ..textDirection = TextDirection.ltr
      ..text = span
      ..layout(maxWidth: MediaQuery.of(context).size.width-20);
    return painter.didExceedMaxLines || painter.size.height>(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom-50);
  }

  @override
  Widget build(BuildContext context) {
    ///设置主题
    SystemChrome.setSystemUIOverlayStyle(MyTheme.light);

    // TODO: implement build
    String txt = "";

    ///如果此设备上的行字数和每页的列数还没有被初始化过，则进行初始化
    if(!Global.rowWorldNumIsInit){
      print("readPage 行字数和列数进行初始化！");
      initReadPageNum(context, true);
      initReadPageNum(context, false);
      if(Global.readPageRowWorldNum>1 && Global.readPageColoumNum>1){
        print("一行 ${Global.readPageRowWorldNum} 个字");
        print("一页 ${Global.readPageColoumNum} 列");
        Global.rowWorldNumIsInit = true;
      }

    }
    ///对章节进行分页
    if(needFenye){
       pageInfos= fenye(nowChapter.content);
       needFenye = false;
    }
    ///把每页文字渲染成展示的组件
    pageInfos.forEach((page,pageStr){
      pages.add(readPage2(page,context,pageStr,pageInfos.length));
    });

    return new Scaffold(
        backgroundColor: Colors.white,
        body: new PageView(
          physics: BouncingScrollPhysics(),
          controller: pageController,
          scrollDirection: Axis.horizontal,
          children: pages,
          onPageChanged: (index){
            print(index);
          },

        ),
    );
  }

  ///对章节文本进行分页
  Map<int,String> fenye(String txt){
    int rowWorldNum = Global.readPageRowWorldNum;
    int pageColumnTotalCount = Global.readPageColoumNum;
    int page = 1;
    List<String> rows = txt.split("\n");
    String content = "";
    int nowPageColumnCount = 0;
    Map<int,String> pageInfos = new Map();
    for(String r in rows){
      ///先对当前content的文本进行处理，因为content可能在上次循环中还有没处理的文本
      int contentRow = (content.length/rowWorldNum).floor();
      int contentLastWordNum = content.length%rowWorldNum;
      if(contentLastWordNum!=0){
        contentRow+=1;
      }
      while(contentRow>=pageColumnTotalCount){
        //得到新页数据
        pageInfos[page] = contentRow==pageColumnTotalCount?content:content.substring(0,pageColumnTotalCount*rowWorldNum);
        //对content进行裁剪，获得未处理的文本
        content = contentRow==pageColumnTotalCount?"":content.substring(pageColumnTotalCount*rowWorldNum);
        contentRow-=pageColumnTotalCount;//计算还剩多少行没处理
        nowPageColumnCount=0;//换新页的时候都要把当前页文本行数重置为0
        page++;
      }

      //行首增加两个空白字符，可以由搜狗输入法，输入v1，选择d 得到空白字符
      r = "　　"+r;
      int lastWordNum = r.length%rowWorldNum;
      int rowNum = (r.length/rowWorldNum).floor();
      if(lastWordNum!=0){
        r +="\n";
        rowNum+=1;
      }

      if(nowPageColumnCount+rowNum>=pageColumnTotalCount){
        int needRow = pageColumnTotalCount-nowPageColumnCount;
        content = content + (needRow==1?r:r.substring(0,needRow*rowWorldNum));
//        content= content+r.substring(0,needRow*rowWorldNum);
        pageInfos[page] = content;
        page++;
        nowPageColumnCount = 0;
        content = needRow==1?"":r.substring(0,needRow*rowWorldNum);
        continue;
      }
      content +=r;
      nowPageColumnCount +=rowNum;
    }

    int contentRow = (content.length/rowWorldNum).floor();
    int contentLastWordNum = content.length%rowWorldNum;
    if(contentRow==0 && contentLastWordNum==0){
      return pageInfos;
    }

    if(contentLastWordNum!=0){
//    content +="\n";
      contentRow+=1;
    }
    while(contentRow>=pageColumnTotalCount){
      int needRow = pageColumnTotalCount-nowPageColumnCount;
      //得到新页数据
      pageInfos[page] = contentRow==pageColumnTotalCount?content:content.substring(0,pageColumnTotalCount*rowWorldNum);
      //对content进行裁剪，获得未处理的文本
      content = contentRow==pageColumnTotalCount?"":content.substring(pageColumnTotalCount*rowWorldNum);
      contentRow-=pageColumnTotalCount;
      page++;
    }

    pageInfos[page] = content;

    return pageInfos;

  }

  ///阅读页面
  Widget readPage2(int num,BuildContext context,String txt,int allPageNum){
    return new Container(
      width: Global.screenWidth,
      height: Global.screenHeight,
      padding: EdgeInsets.fromLTRB(10, Global.statusTopBarHeight,5, Global.statusBottomBarHeight),
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.red)
      ),
      child: new Stack(
        children: <Widget>[
          new Container(//小说文本现实部分
            width: Global.screenWidth,
            height: Global.screenHeight-Global.statusTopBarHeight-Global.statusBottomBarHeight,
            padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
            decoration: new BoxDecoration(
              border: Border.all(color: Colors.red)
            ),
            child:new Text(
              txt,
              style: new TextStyle(
                fontSize: ScreenUtil().setSp(36),
              ),
            ),
          ),
          new Positioned(//页面顶部小说章节名字
            top: 0,
            left: 0,
            child: new Row(
              children: <Widget>[
                new Text("${nowChapter.title}"),
              ],
            ),
          ),
          new Positioned(//页面底部电量和页码现实部分
            bottom: 0,
            left: 0,
            child: new Container(
              width: Global.screenWidth-30,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text("电量信息"),
                  new Text("${num}/${allPageNum}")
                ],
              ),
            )
          )
        ],
      )
    );
  }

}