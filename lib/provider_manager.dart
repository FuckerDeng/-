import 'package:provide/provide.dart';
import 'public/provide/fictionDetailProvider.dart';
import 'public/provide/home_page_provider.dart';
import 'public/provide/chapter_list_provider.dart';


class ProviderManger{

  static providerInit(Providers providers){
    var fictionDetailProvider = new FictionDetailProvider();//小说详情页数据源
    var homePageProvider = new HomePageProvider();//数据源
    var chapterListProvider = new ChapterListProvider();//数据源

    providers
      ..provide(Provider<FictionDetailProvider>.value(fictionDetailProvider)) //将数据源加入仓库，再讲仓库加入仓库管理对象，有多个数据源时，直接在后面添加
      ..provide(Provider<ChapterListProvider>.value(chapterListProvider))
      ..provide(Provider<HomePageProvider>.value(homePageProvider)); //将数据源加入仓库，再讲仓库加入仓库管理对象，有多个数据源时，直接在后面添加
  }
}