import 'package:flutter/material.dart';
import '../public/IconFont.dart';
import 'home/home_page.dart';
import 'fenlei/fenlei_page.dart';
import 'bookself/bookshelf_page.dart';
import 'findbook/findbook_page.dart';
import 'person/person_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyApp();
  }
}

class _MyApp extends State<MyApp>{
  List<Widget> pages_list = new List();
  int _nowPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    pages_list
      ..add(new HomePage())
      ..add(new FenleiPage())
      ..add(new Bookshelf())
      ..add(new FindBookPage())
      ..add(new PersonPage());
    super.initState();
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String itemName){
    IconData iconData = null;
    switch(itemName){
      case "书城":{
        iconData = _nowPage==0?IconFont.zhuye2:IconFont.zhuye1;
      }
      break;
      case "分类":{
        iconData = _nowPage==0?IconFont.fenlei:IconFont.leimupinleifenleileibie_copy;
      }
      break;
      case "书架":{
        iconData = _nowPage==0?IconFont.shujia:IconFont.shujiashugui;
      }
      break;
      case "求书":{
        iconData = _nowPage==0?IconFont.xuqiu:IconFont.xuqiu;
      }
      break;
      case "我的":{
        iconData = _nowPage==0?IconFont.icon_jiaosefuzhi:IconFont.icon_jiaosefuzhi1;
      }
      break;
    }



    return new BottomNavigationBarItem(
        icon: new Icon(iconData),
        title: new Text(itemName)
    );
  }

  ///底部导航栏
  List<BottomNavigationBarItem> _bottomNavigationbarItems (){
    List<BottomNavigationBarItem> items =  new List<BottomNavigationBarItem>();
    items
      ..add(_bottomNavigationBarItem("书城"))
      ..add(_bottomNavigationBarItem("分类"))
      ..add(_bottomNavigationBarItem("书架"))
      ..add(_bottomNavigationBarItem("求书"))
      ..add(_bottomNavigationBarItem("我的"));
    return items;

  }


  @override
  Widget build(BuildContext context) {
    initScreen(context);

    return mainApp(context);
  }

  ///屏幕适配初始化
  ///
  /// 初始化必须放在statelessWidget中，不然会报错
  void initScreen(BuildContext context){
//    // 方式一：默认设置宽度1080px，高度1920px
//    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//    // 方式二：设置宽度750px，高度1334px
//    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // 方式三：设置宽度750px，高度1334px，根据系统字体进行缩放,系统字体设置改变后，app内的字体大小也会跟着变
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 2248, allowFontScaling: true)..init(context);
  }


  Widget mainApp(BuildContext context){
    return new Scaffold(
      body: new IndexedStack(//使用这个组件，配合autokeepalive保持切换前页面的状态，不会每次切换页面都刷新
        index: _nowPage,
        children: pages_list,
      ),
      bottomNavigationBar: new BottomNavigationBar(
          items: _bottomNavigationbarItems(),
          type: BottomNavigationBarType.fixed,//底部导航栏的数目超过3个以后就不显示样式了，需要添加这个属性
          currentIndex: _nowPage,////设置当前显示的页面索引，使用已设定的属性。
          onTap: (int index){//参数设置为默认的index，这个index就是点击的按钮的index
            setState(() {
              _nowPage = index;
            });
          }
      ),
    );
  }
}