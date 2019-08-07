import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';



class HomePage extends StatefulWidget{

  @override
  State createState() {
    // TODO: implement createState
    return new _HomePage();
  }


}
//AutomaticKeepAliveClientMixin 混淆类，使用这个类，在切换tabbar的时候，能保持切换前的状态，不然的话，每次切换页面，都会重新加载页面
//但是使用这个有些条件限制：所混合的类必须是StaatefulWidget有状态的类，且必须实现wantkeepalive方法，返回true，tabbar切换的页面由indexedState 控制
class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  //easyRefresh 必须要的key
  GlobalKey<RefreshFooterState> _key = new GlobalKey<RefreshFooterState>();

  ScrollController _scrollController = new ScrollController();

  ///顶部搜索的左边部分
  Widget searchLeading(){
    return new Text(
      "书城",
      style: new TextStyle(
          fontSize: ScreenUtil().setSp(50),
//          fontWeight: FontWeight.bold
      ),
    );
  }

  ///顶部搜索的中间部分
  Widget searchEdit(){
    return new Expanded(
        flex: 2,
        child: new InkWell(
            onTap: (){},
            child: new Container(
                height: ScreenUtil().setHeight(100),
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                margin: EdgeInsets.only(left: 20,right: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.search,size: 16.0,),
                    new Text(
                      "搜索作者、书名",
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(25),
                          color: Colors.grey
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  ///顶部搜索的右边部分
  Widget searchButton(){
    return new InkWell(
      onTap: (){},
      child: new Container(
        width: ScreenUtil().setWidth(130),
        height: ScreenUtil().setHeight(90),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: new Text("福利"),
      ),
    );
  }

  /// listvie顶部的轮播组件
  /// futurebuilder 了解下
  Widget topLunBo(BuildContext context){
    return new Container(
      height: ScreenUtil().setHeight(500),
      margin: EdgeInsets.fromLTRB(35, 0, 35, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: new Swiper(
        itemBuilder: (context,index){
//          return Image.asset("res/imgs/${index+1}.jpg"); 这里不要直接返回一个图片，不然会报错，原因不是很清楚
          return new Container(
            decoration: new BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                image: AssetImage("res/imgs/${index+1}.jpg"),
                fit: BoxFit.cover
              )
            ),
          );
        },
        autoplayDisableOnInteraction: true,
//        viewportFraction: 0.9,///展示的item的缩放大小
//        scale: 0.8,///所有轮播item缩放大小
        itemCount: 3,
//        itemHeight: 300,
        pagination: new SwiperPagination(),//有此参数则显示点，表示第几张图
        controller: new SwiperController(),
        onTap: (index){},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    ///下拉回调方法,方法需要有async和await关键字，没有await，刷新图标立马消失，没有async，刷新图标不会消失
    Future<Null> _onRefresh() async{
      return null;
    }

    ///顶部搜索栏部分
    Widget searchSection(){
      return new Positioned(
        top: 0,
        left: 0,
        child: new Container(
          width: ScreenUtil().setWidth(ScreenUtil.screenWidth-80),
          decoration: new BoxDecoration(
              color:new Color.fromRGBO(255, 255, 255, 0)
          ),
          padding: EdgeInsets.fromLTRB(40, 40, 40, 15),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              searchLeading(),
              searchEdit(),
              searchButton()
            ],
          ),
        ),
      );
    }

    //整个滑动页面
    Widget homeListView = new EasyRefresh(
      refreshFooter: ClassicsFooter(
        key: _key,
        bgColor: Colors.grey,
        showMore: true,
        noMoreText: "",
        loadingText: "加载中...",
        loadReadyText: "加载完成...",
        loadText: "上拉加载...",
        moreInfo: "加载于%T",
      ),
      child: new ListView(
          controller: _scrollController,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 60),
            ),
            topLunBo(context),
            new Text("暂未获取到数据！")
          ]
      ),
      loadMore: (){
      },
      onRefresh: (){
        _onRefresh();
      },
    );





    Widget homePage(){
      return new Scaffold(
        body:new Container(
          decoration: new BoxDecoration(
            color: Colors.black12,
          ),
          child:  new Stack(
            children: <Widget>[
              searchSection(),
              homeListView
            ],
          )
        ),
      );
    }

    return homePage();
  }
}