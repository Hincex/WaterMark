import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/utils/tools_util.dart' as prefix0;
import '../utils/tools_util.dart';

class CommonModel with ChangeNotifier {
  //主题相关变量
  //初始主题
  ThemeData _indexTheme;
  //初始主题的primaryColor
  Color color = Themes.themeData.primaryColor;
  ThemeData themeUsr = Themes.themeData;
  //执行第一个通知
  CommonModel(this._indexTheme);

  void themechange(theme) {
    //获得更改的主题
    Themes.themeData = theme;
    themeUsr = theme;
    color = Themes.themeData.primaryColor;
    //通知consumer
    notifyListeners();
  }

  void backUtil() {
    //如果是顶层返回按钮则返回悬浮按钮
    if (ToolInfo.toolbar == true) {
      ToolInfo.floatbtn = true;
      ToolInfo.tool = false;
      ToolInfo.toolbar = false;
      ToolInfo.position = false;
    } //非顶层按钮则返回主工具栏
    else {
      ToolInfo.toolbar = true;
      ToolInfo.position = false;
    }
    notifyListeners();
  }

  //悬浮按钮
  void toolUtil() {
    ToolInfo.floatbtn = false;
    ToolInfo.tool = true;
    ToolInfo.toolbar = true;
    //通知consumer
    notifyListeners();
  }

  void posUtil() {
    ToolInfo.toolbar = false;
    ToolInfo.position = true;
    //通知consumer
    notifyListeners();
  }

  void upUtil() {
    WaterInfo.bottom += 5;
    //通知consumer
    notifyListeners();
  }

  void rightUtil() {
    WaterInfo.left += 5;
    //通知consumer
    notifyListeners();
  }

  void downUtil() {
    WaterInfo.bottom -= 5;
    //通知consumer
    notifyListeners();
  }

  void leftUtil() {
    WaterInfo.left -= 5;
    //通知consumer
    notifyListeners();
  }

  void resetUtil() {
    WaterInfo.bottom = 10;
    WaterInfo.left = 10;
    //通知consumer
    notifyListeners();
  }

  //通知获得的初始主题
  get indexTheme => _indexTheme;
}
