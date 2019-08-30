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

  PageController pageController = new PageController();
  double fontsize = ScreenUtil().setSp(45);
  double fontheight = 1.2;
  int nowPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localInfo = getChpterIdFromLocal(widget.fictionId);
    chapterInitMethod = getNextChapter( localInfo["chapterId"]);
//    screenInitMethod = screenInit();
//    beforeRead = beforeReadInit();
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
  ///计算阅读页面每行的字数或整个屏幕文字的行数
  initReadPageNum(BuildContext context,bool checkRow,double fontsize){
    String txt = "中";

    if(checkRow){
      print("初始化行的字数");
      //字体大小36
      while(!checkRowFull1(new TextSpan(text: txt,style: new TextStyle(fontSize: fontsize,height: fontheight)), context,checkRow)){
//      print("增加字符");
        txt +="中";
      }
      Global.readPageRowWorldNum = txt.length-1;
    }else{
      print("初始化列数");
      while(!checkScreenFull(new TextSpan(text: txt,style: new TextStyle(fontSize: fontsize,height: fontheight)), context,checkRow)){
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

  ///初始化当前页面能显示的没行文字数和总行数
  Future screenInit() async {
    ///如果此设备上的行字数和每页的列数还没有被初始化过，则进行初始化
    if(!Global.rowWorldNumIsInit){
      print("readPage 行字数和列数进行初始化！");
      initReadPageNum(context, true,fontsize);
      await initReadPageNum(context, false,fontsize);
      if(Global.readPageRowWorldNum>1 && Global.readPageColoumNum>1){
        print("一行 ${Global.readPageRowWorldNum} 个字");
        print("一页 ${Global.readPageColoumNum} 列");
        Global.rowWorldNumIsInit = true;
      }

    }
  }

  Future beforeReadInit() async {
    await Future.wait([this.screenInitMethod,this.chapterInitMethod]);
  }

  @override
  Widget build(BuildContext context) {

    ///设置主题
    SystemChrome.setSystemUIOverlayStyle(MyTheme.light);
    ///如果此设备上的行字数和每页的列数还没有被初始化过，则进行初始化
    if(!Global.rowWorldNumIsInit){
      print("readPage 行字数和列数进行初始化！");
      initReadPageNum(context, true,fontsize);
      initReadPageNum(context, false,fontsize);
      if(Global.readPageRowWorldNum>1 && Global.readPageColoumNum>1){
        print("一行 ${Global.readPageRowWorldNum} 个字");
        print("一页 ${Global.readPageColoumNum} 列");
        Global.rowWorldNumIsInit = true;
      }

    }
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
                if(preChapter !=null) pageInfos.addAll(fenye(preChapter));
                if(nowChapter !=null) pageInfos.addAll(fenye(nowChapter));
                if(nextChapter !=null) pageInfos.addAll(fenye(nextChapter));

                needFenye = false;
              }

//              ///把每页文字渲染成展示的组件
              pageInfos.forEach((pageNum,pageStr){
                pages.add(readPage2(pageNum,context,pageStr,pageInfos.length));
              });
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

  ///对章节文本进行分页
  ///
  /// 返回值为map，键值为“章节id-当前内容在章节中的页数#章节标题” eg:"1-2#第一章：XXX":表示第一章第二页
  Map<String,String> fenye(Chapter chapter){
    List<String> rows = chapter.content.split("\n");
    int rowWorldNum = Global.readPageRowWorldNum;
    int pageColumnTotalCount = Global.readPageColoumNum;
    int page = 1;
    String content = "";
    int nowPageColumnCount = 0;
    Map<String,String> pageInfos = new Map();
    for(String r in rows){
      ///先对当前content的文本进行处理，因为content可能在上次循环中还有没处理的文本
      int contentRow = (content.length/rowWorldNum).floor();
      int contentLastWordNum = content.length%rowWorldNum;
      if(contentLastWordNum!=0){
        contentRow+=1;
      }
      while(contentRow>=pageColumnTotalCount){
        //得到新页数据
        String pageContent = contentRow==pageColumnTotalCount?content:content.substring(0,pageColumnTotalCount*rowWorldNum);
        pageInfos["${chapter.chapterId}-${page}#${chapter.title}"] = pageContent;
//        print("第${page}页内容：${pageInfos[page]}");
        //对content进行裁剪，获得未处理的文本
        content = contentRow==pageColumnTotalCount?"":content.substring(pageColumnTotalCount*rowWorldNum);
        contentRow-=pageColumnTotalCount;//计算还剩多少行没处理
        nowPageColumnCount=0;//换新页的时候都要把当前页文本行数重置为0
        page++;
      }

      if(nowPageColumnCount==0){
        nowPageColumnCount = contentRow;
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
        content = content + (needRow==rowNum?r:r.substring(0,needRow*rowWorldNum));
//        content= content+r.substring(0,needRow*rowWorldNum);
        pageInfos["${chapter.chapterId}-${page}#${chapter.title}"] = content;
//        print("第${page}页内容：${pageInfos[page]}");
        page++;
        nowPageColumnCount = 0;
        content = needRow==rowNum?"":r.substring(needRow*rowWorldNum);
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
      pageInfos["${chapter.chapterId}-${page}#${chapter.title}"] = contentRow==pageColumnTotalCount?content:content.substring(0,pageColumnTotalCount*rowWorldNum);
//      print("第${page}页内容：${pageInfos[page]}");
      //对content进行裁剪，获得未处理的文本
      content = contentRow==pageColumnTotalCount?"":content.substring(pageColumnTotalCount*rowWorldNum);
      contentRow-=pageColumnTotalCount;
      page++;
    }

    pageInfos["${chapter.chapterId}-${page}#${chapter.title}"] = content;
//    print("第${page}页内容：${pageInfos[page]}");
    return pageInfos;

  }

  ///阅读页面
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
          new Container(//小说文本现实部分
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
}