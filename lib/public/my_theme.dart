import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTheme {
  //字体颜色白色
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Color.fromRGBO(193,193,193, 1),
    statusBarColor: null,//为null表示顶部状态栏的颜色透明
    systemNavigationBarIconBrightness: Brightness.light,
//    statusBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );


  /// System overlays should be drawn with a dark color. Intended for
  /// applications with a light background.
  /// 字体颜色黑色
  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
}