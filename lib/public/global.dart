
class Global{
  ///本设备阅读页的每行字数、每页列数是否初始化的标志：在read_page.dart中build方法中进行初始化
  static bool rowWorldNumIsInit = false;
  ///阅读页每行字数
  static int readPageRowWorldNum = 1;
  ///阅读页总行数
  static int readPageColoumNum = 1;

  //顶部状态栏的高度：就是现实时间、电量的状态栏：在myapp.dart中build方法中进行初始化
  //注意flutter默认单位是dp，不是像素pix，查下区别
  static double statusTopBarHeight = 0;
  //底部虚拟按键栏的高度
  static double statusBottomBarHeight = 0;
  //屏幕宽度
  static double screenWidth = 0;
  //屏幕高度
  static double screenHeight = 0;
}