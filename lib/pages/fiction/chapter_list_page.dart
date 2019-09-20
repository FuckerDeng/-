import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../public/provide/chapter_list_provider.dart';
import '../../public/models/chapter_list_model.dart';



class ChapterListPage extends StatefulWidget{
  String fictionName = "";
  String fictionId = "";

  ChapterListPage(this.fictionId,this.fictionName);
  @override
  State createState() {
    // TODO: implement createState
    return new _ChapterListPage();
  }


}

class _ChapterListPage extends State<ChapterListPage> {
  List<String> fictionChapters = new List<String> ();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provide.value<ChapterListProvider>(context).getData(int.parse(widget.fictionId));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: chaptersAppBar(context),
      body: fictionChaptersListView(),
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

  Widget fictionChaptersListView(){
    return new ListView(
      children:  Provide.value<ChapterListProvider>(context).bigChapters.length<0?<Widget>[new Center(child: new Text("未发现任何章节！"),)]:bigChapters(Provide.value<ChapterListProvider>(context).bigChapters),
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
          !bigChapter.open?null:new Column(//如果被展开就显示具体的20个章节
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
        },
        child: new Container(//具体小说章节
          color: Colors.black26,
          height: ScreenUtil().setHeight(160),
          padding: EdgeInsets.only(left: 20),
          child: new Row(
            children: <Widget>[
              new Icon(Icons.chevron_right,color: new Color.fromRGBO(0, 0, 0, 1),),
              new Container(
                margin: EdgeInsets.only(left: 20),
                child: new Text(
                  ch.title,
                  style: new TextStyle(
                      fontSize: ScreenUtil().setSp(40)
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