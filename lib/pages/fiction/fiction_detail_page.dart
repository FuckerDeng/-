import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'fiction_base_widget.dart';
import '../../public/IconFont.dart';


class FictionDetailPage extends StatefulWidget{


  @override
  State createState() {
    // TODO: implement createState
    return new _FictionDetailPage();
  }


}

class _FictionDetailPage extends State<FictionDetailPage> {
  ScrollController _controller = new ScrollController();
  double _topBarShowOpacity = 1;
  bool _isExpand = true;
  bool _introduceLengthIsBg28 = false;
  String jianjie = "小说简介，即简明扼要的介绍。是当事人全面而简洁地介绍情况的一种书面表达方式，它是应用写作学研究的一种日常应用文体。是当事人全面而简洁地介绍情况的一种书面表达方式，它是应用写作学研究的一种日常应用文体。是当事人全面而简洁地介绍情况的一种书面表达方式，它是应用写作学研究的一种日常应用文体。";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _introduceLengthIsBg28 = jianjie.length>96?true:false;
    if(_introduceLengthIsBg28) _isExpand = false;
    _controller.addListener((){
        if(_controller.offset>=50 && _topBarShowOpacity<1){
          setState(() {
            _topBarShowOpacity = 0;
          });
        }

        if(_controller.offset<50){
          setState(() {
            _topBarShowOpacity = 1-_controller.offset/50;
          });
        }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.chevron_left),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        elevation: 0,
        centerTitle: true,
        title: new Text(
            "小说名字",
          style: new TextStyle(
            color: new Color.fromRGBO(0, 0, 0, _topBarShowOpacity)
          ),
        ),
        backgroundColor: new Color.fromRGBO(255, 255, 255, _topBarShowOpacity) ,//158, 158, 158 gray
      ),
      body: new Container(
        color: new Color.fromRGBO(230,230,230, 1),
        child: new Stack(
          children: <Widget>[
            pageBody(),
//            topBar(context),
            bottomBar()
          ],
        ),
      ),
    );
  }

  ///顶部导航栏
  Widget topBar(BuildContext context){
    return Positioned(
      top: 0,
      left: 0,
      child: new Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
        height: ScreenUtil().setHeight(200),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            color: new Color.fromRGBO(255, 255, 255, 1)
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.chevron_left),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
            new Expanded(
              child: new Container(
                alignment: Alignment.center,
                child: new Text(
                    "小说名字",
                  style: new TextStyle(
                    color: new Color.fromRGBO(0, 0, 0, 0.1)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///页面的主题部分，显示小说的详细内容
  Widget pageBody(){
    return ListView(
      controller: _controller,
      children: <Widget>[
        fictionHeaderSection(),
        fictionIntroduceSection(),
        fictionChaptersSection()
      ],
    );
  }

  ///页面的底部部分，包含【加入书架】和【开始阅读】按钮
  Widget bottomBar(){
    return new Positioned(
      left: 0,
      bottom: 0,
      child: new Row(
        children: <Widget>[
          bottomButton("加入书架", Colors.white, Colors.orange,IconFont.shujia),
          bottomButton("开始阅读", Colors.orange, Colors.white,IconFont.shu),

        ],
      ),
    );
  }

  ///底部的按钮组件：【加入书架】或【开始阅读】按钮
  ///
  /// @buttonName 按钮的显示文字
  /// @bgColor 按钮的背景颜色
  /// @textColor 按钮上文字和ICON图标的颜色
  /// @buttonIconData 按钮上的icon图标
  Widget bottomButton(String buttonName,Color bgColor,Color textColor,IconData buttonIconData){
    return new InkWell(
      onTap: (){},
      child: new Container(
        width: ScreenUtil().setWidth(ScreenUtil.screenWidth/2),
        height: ScreenUtil().setHeight(170),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor,
        ),
        child: new Column(
          children: <Widget>[
            new Icon(buttonIconData,color: textColor,),
            new Text(buttonName,style: new TextStyle(color:textColor),)
          ],
        ),
      ),
    );
  }

  //小说详情页的顶部部分，介绍小说的基本信息
  Widget fictionHeaderSection(){
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: new Column(
        children: <Widget>[
          topRow(),
          bottomRow()
        ],
      ),
    );
  }

  /// 小说详情页的顶部部分的上半部
  Widget topRow(){
    return new Container(
      margin: EdgeInsets.only(bottom: 20),
      child: new Row(
        children: <Widget>[
          new Container(
            width: ScreenUtil().setWidth(280),
            height: ScreenUtil().setHeight(480),
            child: new Image.asset("res/imgs/180.jpg",fit: BoxFit.cover,),
          ),
          new Expanded(
            child: new Container(
              padding: EdgeInsets.fromLTRB(30, 10, 10, 5),
              height: ScreenUtil().setHeight(480),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(
                    "小说名字",
                    style: new TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  new Text(
                    "作者名字",
                    style: new TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey),
                  ),
                  new Text(
                    "小说字数",
                    style: new TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    color: new Color.fromRGBO(252,238,237, 1),
                    child: new Text(
                      "小说类型",
                      style: new TextStyle(color: new Color.fromRGBO(240,143,138, 1),fontSize: ScreenUtil().setSp(23)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 小说详情页的顶部部分的下半部
  Widget bottomRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        numberShow("2.3","万", "人气值"),
        numberShow("8.1", null,"评分"),
        numberShow("939",null,"本周在读人数"),
      ],
    );
  }

  /// 小说的数值展示
  ///
  /// @showNum 展示的数值
  /// @showType 展示的类型
  Widget numberShow(String showNum,String danwei,String showType){
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Text(
              showNum,
              style: new TextStyle(fontSize: ScreenUtil().setSp(50),fontWeight: FontWeight.bold),
            ),
            danwei==null?new Text(""):new Text(
              danwei,
              style: new TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),
            ),
          ],
        ),
        new Text(
          showType,
          style: new TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.grey),
        ),
      ],
    );
  }

  ///小说简介部分
  Widget fictionIntroduceSection(){
    return InkWell(
          onTap: (){
    setState(() {
    if(_introduceLengthIsBg28){
    _isExpand = !_isExpand;
    }
    });
    },
      child: Container(
          width: ScreenUtil().setHeight(ScreenUtil.screenWidth),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 3),
          color: Colors.white,
          child: new Stack(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                FictionBaseWidget.sectionTitle("简介", false, null),
                new Text(
                  jianjie,
                  style: new TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: Colors.black54
                  ),
                  maxLines: _isExpand?100:3,
                  overflow: TextOverflow.ellipsis,
                ),
                new Text("")
              ],
            ),
            _isExpand?new Container():new Positioned(
              right: 0,
              bottom: 0,
              child: new Row(
                children: <Widget>[
                  new Text(
                    "展开",
                    style: new TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30)),
                  ),
                  new Icon(Icons.keyboard_arrow_down,color: Colors.grey,)
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  ///小说目录部分
  Widget fictionChaptersSection(){
    return InkWell(
      onTap: (){
        setState(() {
          print("小说目录部分被点击！");
        });
      },
      child: Container(
          width: ScreenUtil().setHeight(ScreenUtil.screenWidth),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          color: Colors.white,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FictionBaseWidget.sectionTitle("查看目录", false, null),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "最后一章的名字",
                    style: new TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.black54
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                          "最后一章更新时间/已完结",
                        style: new TextStyle(color: Colors.orange,fontSize: ScreenUtil().setSp(30),),
                      ),
                      new Icon(Icons.chevron_right,size:ScreenUtil().setSp(50) ,)
                    ],
                  )
                ],
              ),
            ],
          )
      ),
    );
  }
}