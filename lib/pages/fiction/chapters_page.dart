import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ChaptersPage extends StatefulWidget{
  String fictionName = "";
  String fictionId = "";

  ChaptersPage(this.fictionId,this.fictionName);
  @override
  State createState() {
    // TODO: implement createState
    return new _ChaptersPage();
  }


}

class _ChaptersPage extends State<ChaptersPage> {
  List<String> fictionChapters = new List<String> ();
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
      children:  fictionChapters.length<0?<Widget>[bigChapter("未发现任何章节")]:<Widget>[
        bigChapter("第1章-第20章"),
      ]
    );
  }

  Widget bigChapter(String bigChapterName){
    return InkWell(
      onTap: (){
        print("${bigChapterName} 被点击了！");
      },
      child: new Container(
        color: Colors.white,
        height: ScreenUtil().setHeight(160),
        padding: EdgeInsets.only(left: 20),
        child: new Row(
          children: <Widget>[
            new Icon(Icons.chevron_right),
            new Container(
              margin: EdgeInsets.only(left: 20),
              child: new Text(
                  bigChapterName,
                style: new TextStyle(
                  fontSize: ScreenUtil().setSp(40)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}