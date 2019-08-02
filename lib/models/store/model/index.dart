import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
import '../../../utils/global_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChange with ChangeNotifier {
  //初始主题
  ThemeData _indexTheme;
  //初始主题的primaryColor
  Color color = GlobalConfig.themeData.primaryColor;
  Color navcolor = GlobalConfig.themeData.bottomAppBarColor;
  ThemeData themeUsr = GlobalConfig.themeData;
  bool selected = true;
  //执行第一个通知
  ThemeChange(this._indexTheme);

  void themechange(theme) {
    //获得更改的主题
    GlobalConfig.themeData = theme;
    themeUsr = theme;
    color = GlobalConfig.themeData.primaryColor;
    navcolor = GlobalConfig.themeData.bottomAppBarColor;
    //通知consumer
    notifyListeners();
  }

  //通知获得的初始主题
  get indexTheme => _indexTheme;
}
