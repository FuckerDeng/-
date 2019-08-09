import 'package:flutter/material.dart';
import '../../router/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FictionBaseWidget {
  //小说横向展示的组件
  static Widget fictionRowInfo(BuildContext context){
    return new InkWell(
      onTap: (){
        print("小说被点击了");
        Routers.router.navigateTo(context, Routers.fictionDetailPage);
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
  static Widget typeOrRecord(String typeOrRecordStr,int type){
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

  ///热门推荐、火热连载的标题部分
  ///
  /// @titleName 左边的标题名字
  /// @needRightName 是否要显示右边的加载名字和图标
  /// @rightName 右边的加载名字
  static Widget sectionTitle(String titleName,bool needRightName,String rightName){
    return Container(
      padding: EdgeInsets.fromLTRB(0,10, 10,0),
      margin:EdgeInsets.only(bottom: 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(//左边的名字：热门推荐、火热连载等
            titleName,
            style: new TextStyle(
                fontSize: ScreenUtil().setSp(50),
                color: Colors.black
            ),
          ),
          !needRightName?new Container():new InkWell(
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
}