import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../public/provide/chapter_list_provider.dart';
import '../../public/models/chapter_list_model.dart';
import 'package:bangwu_app/router/routers.dart';
import 'package:fluro/fluro.dart';



class ChapterListPage extends StatefulWidget{
  String fictionName = "";
  String fictionId = "";

  ChapterListPage(this.fictionId,this.fictionName){}
  @override
  State createState() {
    // TODO: implement createState
    return new _ChapterListPage();
  }


}

class _ChapterListPage extends State<ChapterListPage> {
  List<String> fictionChapters = new List<String> ();
  Future futureFunc = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  initPageData(BuildContext context)async{
    String future = await Provide.value<ChapterListProvider>(context).getData(int.parse(widget.fictionId));

    return future;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(this.futureFunc == null){
      this.futureFunc = initPageData(context);
    }
    return new Scaffold(
      appBar: chaptersAppBar(context),
      body: fictionChaptersListView(context),
    );
  }

  Widget chaptersAppBar(BuildContext context){
    return new AppBar(
      leading: new IconButton(
          icon: new Icon(Icons.chevron_left),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
      title: new Text(widget.fictionName),
    );
  }

  Widget fictionChaptersListView(BuildContext context){
    return new FutureBuilder(
      future: this.futureFunc,
      builder: (BuildContext context,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.data!=null){
          return new Provide<ChapterListProvider>(
            builder: (context,child,chapterListProvider){
              return new ListView(
                children:  chapterListProvider.bigChapters.length<=0?<Widget>[new Center(child: new Text("未发现任何章节！"),)]:bigChapters(chapterListProvider.bigChapters),
              );
            },
          );
        }else{
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }

      },
    );
  }

  List<Widget> bigChapters(List<BigChapter> bigChapters){
    List<Widget> list = new List();
    for(BigChapter big in bigChapters){
      list.add(bigChapter(big));
    }
    return list;
  }


  Widget bigChapter(BigChapter bigChapter){
    return InkWell(
      onTap: (){
        bigChapter.open = !bigChapter.open;
        setState(() {
        });
      },
      child: new Column(
        children: <Widget>[
          new Container(//展示第几张-第几章
            color: Colors.white,
            height: ScreenUtil().setHeight(160),
            padding: EdgeInsets.only(left: 20),
            child: new Row(
              children: <Widget>[
                new Icon(bigChapter.open?Icons.keyboard_arrow_down:Icons.chevron_right),
                new Container(
                  margin: EdgeInsets.only(left: 20),
                  child: new Text(
                    bigChapter.bigChapterName,
                    style: new TextStyle(
                        fontSize: ScreenUtil().setSp(40)
                    ),
                  ),
                ),
              ],
            ),
          ),
          !bigChapter.open?new Container():new Column(//如果被展开就显示具体的20个章节
            children: littleChapterList(bigChapter),
          )
        ],
      )
    );
  }

  List<Widget> littleChapterList(BigChapter bigChapter){
    List<Widget> list = new List();
    for(ChapterInfo ch in bigChapter.chapterInfos){
      Widget detailChapter = new InkWell(
        onTap: (){
          print("章节：${ch.title} 被点击了！");

          Routers.router.navigateTo(context, Routers.fictionReadPage+"?fictionid=${ch.fictionId}&chapterid=${ch.chapterId}", transition: TransitionType.inFromRight);
        },
        child: new Container(//具体小说章节
          color: Colors.black26,
          height: ScreenUtil().setHeight(160),
          padding: EdgeInsets.only(left: 20),
          child: new Row(
            children: <Widget>[
              new Icon(Icons.chevron_right,color: new Color.fromRGBO(0, 0, 0, 0),),
              new Container(
                margin: EdgeInsets.only(left: 20),
                child: new Text(
                  ch.title,
                  style: new TextStyle(
                      fontSize: ScreenUtil().setSp(35)
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      list.add(detailChapter);
    }
    return list;
  }

}