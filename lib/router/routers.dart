import 'package:fluro/fluro.dart';
import 'router_handler.dart';


class Routers{
  static Router router = new Router();//申明一个路由
  static String base = "/";
  static String searchPage = "/searchPage";
  static String fictionDetailPage = "/searchPage";

  static void configureRoutes(){//这个方法需要在main.dart中调用一次进行路由对象初始化，dart中没有静态代码块初始化静态变量，只能手动初始化
    router
      ..define(searchPage,handler:RouterHandler.searchPageHandler)//注册路由,page1:页面的路由地址,handler:生成新页面的处理器，可以把handler提出到一个新类中，是这个路由管理类看着更清晰
      ..define(fictionDetailPage, handler:RouterHandler.fictionDetailHandler);

    router.notFoundHandler = new Handler(
        handlerFunc: (context,paramas){
          print("未找到此路由地址！");
        }
    );
  }
}