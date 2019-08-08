import "package:flutter/material.dart";
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../public/IconFont.dart';
import '../../router/routers.dart';



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
  bool searchNeedShow = true;

  @override
  void initState() {
    // TODO: implement initState
    //给整个页面的listvie的控制器加监听，向下滑动超过
    _scrollController.addListener(
        (){
//          print("${searchNeedShow?"true":"false"}  ${_scrollController.offset}");
          if(_scrollController.offset>30 && searchNeedShow==true){
            setState(() {
              searchNeedShow = false;
            });
          }
          if(_scrollController.offset<30 && searchNeedShow==false){
            setState(() {
              searchNeedShow = true;
            });
          }
        }
    );
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  ///顶部搜索栏部分
  Widget searchSection(BuildContext context){
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
            searchEdit(context),
            searchButton()
          ],
        ),
      ),
    );
  }

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
  Widget searchEdit(BuildContext context){
    return new Expanded(
        flex: 2,
        child: new InkWell(
            onTap: (){
              Routers.router.navigateTo(context, Routers.searchPage);
            },
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

  /// listview顶部的轮播组件
  /// futurebuilder 了解下
  Widget topLunBo(BuildContext context){
    return new Container(
      height: ScreenUtil().setHeight(400),
      margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
      child: new ClipRRect(//设置一个圆角的组件，直接通过外部的Container不能设置圆角，后续查下原理
        borderRadius: BorderRadius.circular(10),
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
          autoplay: true,
          autoplayDisableOnInteraction: true,
//        viewportFraction: 0.9,///展示的item的缩放大小
//        scale: 0.8,///所有轮播item缩放大小
          itemCount: 3,
//        itemHeight: 300,
          pagination: new SwiperPagination(),//有此参数则显示点，表示第几张图
          controller: new SwiperController(),
          onTap: (index){
            print("第 ${index} 张轮播图被点击！");
          },
        ),
      )
    );
  }

  /// 小的导航栏按钮
  Widget littleFenleiItem(IconData iconData,Color color,String fenleiName){
    return new InkWell(
      onTap: (){
        print("${fenleiName}  被点击了");
      },
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Icon(iconData,color:color),
            margin: EdgeInsets.only(bottom: 10),
          ),
          new Text(fenleiName)
        ],
      ),
    );
  }

  ///小的导航栏整体
  Widget littleFenlei(){
    return new Container(
      width: ScreenUtil().setWidth(ScreenUtil.screenWidth),
//      padding: EdgeInsets.all(50),
      height: ScreenUtil().setHeight(200),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          littleFenleiItem(IconFont.bangdan,Colors.blue,"榜单"),
          littleFenleiItem(IconFont.wsdzb_zbgzt_xxzx_newpxb_type,Colors.red,"分类"),
          littleFenleiItem(IconFont.jingpin,Colors.deepPurpleAccent,"精品"),
          littleFenleiItem(IconFont.yiwanjie,Colors.orangeAccent,"完结"),
        ],
      )
    );
  }

  ///热门推荐
  Widget hotRecomment(){
    return new Container(
      margin: EdgeInsets.fromLTRB(8, 5, 8, 2),
      padding: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          sectionTitle("热门推荐", "换一换"),//标题部分
          fictionRowInfo(),//横向展示小说内容
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              fictionColumnInfo(),
              fictionColumnInfo(),
              fictionColumnInfo(),
              fictionColumnInfo(),
            ],
          )
        ],
      ),
    );
  }

  ///热门推荐、火热连载的标题部分
  ///
  /// @titleName 左边的标题名字
  /// @rightName 右边的加载名字
  Widget sectionTitle(String titleName,String rightName){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10,0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(//左边的名字：热门推荐、火热连载等
              titleName,
            style: new TextStyle(
              fontSize: ScreenUtil().setSp(50),
              fontWeight: FontWeight.bold
            ),
          ),
          new InkWell(
            onTap: (){
                print("${titleName} 需要 ${rightName}");
            },
            child: new Row(//右侧部分
              children: <Widget>[
                new Text(//
                  rightName,
                  style: new TextStyle(
                      color: Colors.black38,
                      fontSize: ScreenUtil().setSp(30)
                  ),
                ),
                new Text("  "),
                new Icon(rightName=="换一换"?Icons.refresh:Icons.chevron_right,size: 15,),
              ],
            ),
          )
        ],
      ),
    );
  }

  //小说横向展示的组件
  Widget fictionRowInfo(){
    return new InkWell(
      onTap: (){
        print("小说被点击了");
      },
      child: new Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil().setHeight(470),
        padding: EdgeInsets.fromLTRB(7, 5, 10, 10),
        child: new Row(
          children: <Widget>[
            new Container(//左边小说封面图片
              width: ScreenUtil().setWidth(235),
              height: ScreenUtil().setHeight(400),
              margin: EdgeInsets.only(right: 10),
              child: Image.asset("res/imgs/180.jpg",fit: BoxFit.cover,),
            ),
            new Expanded(
              child: new Column(//右边小说信息部分
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(//小说名字
                    child: new Text(
                      "小说名字",
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(40),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  new Container(//小说简介
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: new Text(
                      "小说信息:通过给列表中的每个条目分配为“语义” key，无限列表可以更高效，因为框架将同步条目与匹配的语义key并因此具有相似（或相同）的可视外观",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  new Row(//小说作者、类型和分数
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text("作者名字"),
                      new Container(
                        child: new Row(
                          children: <Widget>[
                            typeOrRecord("小说类型", 0),
                            new Text(" "),
                            typeOrRecord("小说分数", 1),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  ///小说类型或者分数的组件
  ///
  /// @typeOrRecordStr 小说类型或者分数的字符串形式
  /// @type 这个组件的类型：0 小说类型 1 小说分数
  Widget typeOrRecord(String typeOrRecordStr,int type){
    Color nowColor = type==0?Colors.grey:Colors.orange;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: nowColor,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: new Text(
        typeOrRecordStr,
        style: new TextStyle(
          color: nowColor,
          fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }

  ///小说信息竖向展示
  Widget fictionColumnInfo(){
    return new InkWell(
      onTap: (){
        print("竖向展示的小说被点击了！");
      },
      child: new Column(
        children: <Widget>[
          new Container(
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setHeight(400),
            child: Image.asset("res/imgs/180.jpg"),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
            child: Text(
              "小说名字",
              style: new TextStyle(
                  fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          new Text(
            "小说人气",
            style: new TextStyle(
                fontSize: ScreenUtil().setSp(20),
                color: Colors.grey
            ),
          )
        ],
      ),
    );
  }

  ///小说推送部分
  Widget fictionPush(String pushName){
    return new Container(
      margin: EdgeInsets.fromLTRB(8, 5, 8, 2),
      padding: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          sectionTitle(pushName, "查看更多"),
          fictionRowInfo(),
          fictionRowInfo(),
          fictionRowInfo(),
          fictionRowInfo(),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    ///下拉回调方法,方法需要有async和await关键字，没有await，刷新图标立马消失，没有async，刷新图标不会消失
    Future<Null> _onRefresh() async{
      setState(() {
        searchNeedShow = false;
      });
      return null;
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
            topLunBo(context),//轮播图
            littleFenlei(),//小的分类导航
//            Divider(),
            hotRecomment(),//热门推荐
            fictionPush("火热连载"),//火热连载
            fictionPush("猜你喜欢"),//猜你喜欢
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
              homeListView,//整个页面的内容
              searchNeedShow?searchSection(context):new Container(),//顶部搜索框部分
            ],
          )
        ),
      );
    }

    return homePage();
  }
}