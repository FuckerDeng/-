import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'fiction_base_widget.dart';
import '../../public/IconFont.dart';
import '../../router/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import '../../public/provide/fictionDetailProvider.dart';
import '../../public/models/fiction_detail_page_model_entity.dart';
import 'package:provide/provide.dart';

class FictionDetailPage extends StatefulWidget {
  String fictionid;

  FictionDetailPage(this.fictionid);
  @override
  State createState() {
    // TODO: implement createState
    return new _FictionDetailPage();
  }
}

class _FictionDetailPage extends State<FictionDetailPage> {
  ScrollController _controller = new ScrollController();
  double _topBarShowOpacity = 1; //1是透明，0是不透明
  bool _isExpand = true;
  bool _introduceLengthIsBg100 = false;
  bool isInit = false;
  Future futureFunc= null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (_introduceLengthIsBg100) _isExpand = false;
    _controller.addListener(topBarListener);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  initPageData(BuildContext context) async{
    Future future = Provide.value<FictionDetailProvider>(context)
        .getData(int.parse(widget.fictionid));
    return future;
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);

    if(this.futureFunc==null){
      futureFunc = this.initPageData(context);
    }
    return new Scaffold(
      body: showBody(context)
    );
  }
  Widget showBody(BuildContext context){
    return new FutureBuilder(
      future: this.futureFunc,
      builder: (BuildContext context,snapshot){
        if(snapshot.connectionState==ConnectionState.done && snapshot.data!=null){
          return new Container(
            color: new Color.fromRGBO(230, 230, 230, 1),
            child: new Stack(
              children: <Widget>[pageBody(), topBar(context), bottomBar()],
            ),
          );
        }else{
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void topBarListener() {
//    print(_controller.offset);
    //滑动超过100，则直接设置成不透明
    if (_controller.offset >= 100 && _topBarShowOpacity > 0) {
      setState(() {
        _topBarShowOpacity = 0;
      });
    }

    //滑动在50-100之间时，根据滑动的举例来设置透明度,因为滑动越靠近100，就越不需要透明，但(_controller.offset-50)/50越靠近1，因此要用1减去这个值
    if (_controller.offset < 100 && _controller.offset >= 50) {
      setState(() {
        _topBarShowOpacity = 1 - (_controller.offset - 50) / 50;
      });
    }

    //滑动小于50，则一直透明
    if (_controller.offset < 50 && _topBarShowOpacity < 1) {
      setState(() {
        _topBarShowOpacity = 1;
      });
    }
  }

  ///顶部导航栏
  Widget topBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: new Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
        height: ScreenUtil().setHeight(235),
        padding: EdgeInsets.fromLTRB(10, ScreenUtil().setHeight(75), 10, 0),
        decoration: BoxDecoration(
            color: new Color.fromRGBO(
                245, 245, 245, 1 - _topBarShowOpacity), //158, 158, 158 gray
            border: new Border(
                bottom: BorderSide(
                    color: new Color.fromRGBO(
                        235, 235, 235, 1 - _topBarShowOpacity)))),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new Expanded(
              child: new Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: ScreenUtil().setHeight(150)),
                child: new Text(
                  Provide.value<FictionDetailProvider>(context)
                      .showFiction
                      .fictionName,
                  style: new TextStyle(
                      color:
                          new Color.fromRGBO(0, 0, 0, 1 - _topBarShowOpacity)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///页面的主题部分，显示小说的详细内容
  Widget pageBody() {
    return Container(
//      margin: EdgeInsets.only(top: ScreenUtil().setHeight(75)),
      padding: EdgeInsets.only(bottom: 50),
      decoration: new BoxDecoration(
          border: new Border(top: BorderSide(color: Colors.black))),
      child: ListView(
//        shrinkWrap: true,
        controller: _controller,
        children: <Widget>[
          blackContainer(), //占位置的空容器
          fictionHeaderSection(), //详情页头部部分，展示小说基本信息
          fictionIntroduceSection(), //详情页小说简介部分
          fictionChaptersSection(), //详情页小说章节展示部分
          yourLikeSection(context), //详情页 猜你喜欢 推荐部分
          fictionTypePushSection(context), //同类型书籍推荐
          banquanSection() //版权信息
        ],
      ),
    );
  }

  Widget blackContainer() {
    return new Container(
      width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
      height: ScreenUtil().setHeight(150),
      color: Colors.white,
//            decoration: BoxDecoration(
//              border: new Border(bottom: BorderSide(color: Colors.black))
//            ),
    );
  }

  ///页面的底部部分，包含【加入书架】和【开始阅读】按钮
  Widget bottomBar() {
    return new Positioned(
        left: 0,
        bottom: 0,
        child: new Container(
          decoration: BoxDecoration(
              border: new Border(top: BorderSide(color: Colors.black26))),
          child: new Row(
            children: <Widget>[
              bottomButton(
                  "加入书架", Colors.white, Colors.orange, IconFont.shujia),
              bottomButton("开始阅读", Colors.orange, Colors.white, IconFont.shu),
            ],
          ),
        ));
  }

  ///底部的按钮组件：【加入书架】或【开始阅读】按钮
  ///
  /// @buttonName 按钮的显示文字
  /// @bgColor 按钮的背景颜色
  /// @textColor 按钮上文字和ICON图标的颜色
  /// @buttonIconData 按钮上的icon图标
  Widget bottomButton(String buttonName, Color bgColor, Color textColor,
      IconData buttonIconData) {
    return new InkWell(
      onTap: () {
        if (buttonName == "开始阅读") {
          Routers.router.navigateTo(context, Routers.fictionReadPage+"?fictionid=${widget.fictionid}",
              transition: TransitionType.inFromRight);
        }
        if (buttonName == "加入书架") {}
      },
      child: new Container(
        width: ScreenUtil().setWidth(ScreenUtil.screenWidth / 2),
        height: ScreenUtil().setHeight(170),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: new Column(
          children: <Widget>[
            new Icon(
              buttonIconData,
              color: textColor,
            ),
            new Text(
              buttonName,
              style: new TextStyle(color: textColor),
            )
          ],
        ),
      ),
    );
  }

  //小说详情页的顶部部分，介绍小说的基本信息
  Widget fictionHeaderSection() {
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: new Column(
        children: <Widget>[topRow(), bottomRow()],
      ),
    );
  }

  /// 小说详情页的顶部部分的上半部
  Widget topRow() {
    return new Container(
      margin: EdgeInsets.only(bottom: 20),
      child: new Row(
        children: <Widget>[
          new Container(
            width: ScreenUtil().setWidth(280),
            height: ScreenUtil().setHeight(480),
            child: new Image.asset(
              "res/imgs/180.jpg",
              fit: BoxFit.cover,
            ),
          ),
          new Expanded(
            child: new Container(
              padding: EdgeInsets.fromLTRB(30, 10, 10, 5),
              height: ScreenUtil().setHeight(480),
              child: new Provide<FictionDetailProvider>(
                  builder: (context, child, fictionDetailProvider) {
                return new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Text(
                      fictionDetailProvider.showFiction.fictionName==null?"小说名字为null":fictionDetailProvider.showFiction.fictionName,
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                    new Text(
                      fictionDetailProvider.showFiction.author,
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(25), color: Colors.grey),
                    ),
                    new Text(
                      "暂未统计",
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(30), color: Colors.grey),
                    ),
                    new Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        color: new Color.fromRGBO(252, 238, 237, 1),
                        child: new Text(
                          fictionDetailProvider.showFiction.fictiontype,
                          style: new TextStyle(
                              color: new Color.fromRGBO(240, 143, 138, 1),
                              fontSize: ScreenUtil().setSp(23)),
                        ))
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  /// 小说详情页的顶部部分的下半部
  Widget bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        numberShow("2.3", "万", "人气值"),
        numberShow("8.1", null, "评分"),
        numberShow("未统计", null, "本周在读人数"),
      ],
    );
  }

  /// 小说的数值展示
  ///
  /// @showNum 展示的数值
  /// @showType 展示的类型
  Widget numberShow(String showNum, String danwei, String showType) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Text(
              showNum,
              style: new TextStyle(
                  fontSize: ScreenUtil().setSp(50),
                  fontWeight: FontWeight.bold),
            ),
            danwei == null
                ? new Text("")
                : new Text(
                    danwei,
                    style: new TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold),
                  ),
          ],
        ),
        new Text(
          showType,
          style: new TextStyle(
              fontSize: ScreenUtil().setSp(25), color: Colors.grey),
        ),
      ],
    );
  }

  ///小说简介部分
  Widget fictionIntroduceSection() {
    return InkWell(
      onTap: () {
        setState(() {
          if (Provide.value<FictionDetailProvider>(context)
                  .showFiction
                  .fictionDesc
                  .length >
              100) {
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
                  new Provide<FictionDetailProvider>(
                      builder: (context, child, fictionDetailProvider) {
                    return new Text(
                      fictionDetailProvider.showFiction.fictionDesc,
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Colors.black54),
                      maxLines: _isExpand ? 100 : 3,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                  new Text("")
                ],
              ),
              _isExpand
                  ? new Container()
                  : new Positioned(
                      right: 0,
                      bottom: 0,
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            "展开",
                            style: new TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                          new Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    )
            ],
          )),
    );
  }

  ///小说目录部分
  Widget fictionChaptersSection() {
    return InkWell(
      onTap: () {
        String fictionName = Provide.value<FictionDetailProvider>(context).showFiction.fictionName;
//        print("小说目录部分被点击！小说名：${fictionName}");
        String encodedName = Uri.encodeQueryComponent(fictionName);
//        String encodedName = Uri.encodeComponent(fictionName);
//        print("小说名编码后：${encodedName}");
        String url = Routers.fictionChapterListPage + "?fictionid=${Provide.value<FictionDetailProvider>(context).showFiction.id}&fictionname=${encodedName}";
//        print("编码后的url：${url}");
        Routers.router.navigateTo(
            context,
            url,
            transition: TransitionType.inFromRight);
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
              new Provide<FictionDetailProvider>(
                  builder: (context, child, fictionDetailProvider) {
                return   new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      fictionDetailProvider
                          .fictionDetailPageModelEntity.lastChapter.title,
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Colors.black54),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          fictionDetailProvider
                              .fictionDetailPageModelEntity.lastChapter.ctime,
                          style: new TextStyle(
                            color: Colors.orange,
                            fontSize: ScreenUtil().setSp(30),
                          ),
                        ),
                        new Icon(
                          Icons.chevron_right,
                          size: ScreenUtil().setSp(50),
                        )
                      ],
                    )
                  ],
                );
              }),
            ],
          )),
    );
  }

  ///猜你喜欢推荐部分
  Widget yourLikeSection(BuildContext context) {
    return new Container(
      width: ScreenUtil().setHeight(ScreenUtil.screenWidth),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Colors.white,
      child: new Column(children: yourLikeWigdets()),
    );
  }

  List<Widget> yourLikeWigdets() {
    List<Widget> list = new List();
    list.add(FictionBaseWidget.sectionTitle("猜你喜欢", false, null));
    var fs = Provide.value<FictionDetailProvider>(context)
        .fictionDetailPageModelEntity
        .fictions;
    for (FictionDetailPageModelFiction f in fs) {
      list.add(FictionBaseWidget.fictionRowInfo(context, f));
    }
    return list;
  }

  ///与展示的书籍同类型推荐
  Widget fictionTypePushSection(BuildContext context) {
    return Container(
      width: ScreenUtil().setHeight(ScreenUtil.screenWidth),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: FictionBaseWidget.sectionTitle("小说类型", false, null),
          ),
          new GridView.count(
              mainAxisSpacing: 5,
              childAspectRatio: 0.8,
              shrinkWrap: true,
              crossAxisCount: 3,
              semanticChildCount: 6,
              children: sameTypeWigdets())
        ],
      ),
    );
  }

  List<Widget> sameTypeWigdets() {
    List<Widget> list = new List();
    for (FictionDetailPageModelFiction f
        in Provide.value<FictionDetailProvider>(context)
            .fictionDetailPageModelEntity
            .sameTypeFictions) {
      list.add(FictionBaseWidget.fictionColumnInfo(context, false, f));
    }
    return list;
  }

  ///底部版权部分
  Widget banquanSection() {
    return new Container(
      width: ScreenUtil().setHeight(ScreenUtil.screenWidth),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Colors.white,
      child: new Text(
        "版权信息：本网站的所有内容来源于网络，如果侵权，请联系邮箱：844537819@qq.com，我们会第一时间删除并道歉。",
        style: new TextStyle(fontSize: ScreenUtil().setSp(25)),
      ),
    );
  }
}
