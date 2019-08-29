import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/user_setting.dart';
import 'package:new_app/utils/loading.dart';
import 'package:new_app/utils/pics_util.dart';
import 'package:new_app/views/first_detail.dart';
import 'package:new_app/views/second.dart';
import 'package:toast/toast.dart';
import '../utils/tools_util.dart';

class CommonModel with ChangeNotifier {
  //主题相关变量
  //初始主题
  ThemeData _indexTheme;
  //初始主题的primaryColor
  Color color = Themes.themeData.primaryColor;
  ThemeData themeUsr = Themes.themeData;
  List usrcard = [];

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
    } //次顶层返回按钮
    else {
      if (ToolInfo.position == false) {
        ToolInfo.position = true;
        ToolInfo.slider = false;
      } else {
        ToolInfo.toolbar = true;
        ToolInfo.position = false;
      }
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
    WaterInfo.bottom += WaterInfo.step;
    //通知consumer
    notifyListeners();
  }

  void rightUtil() {
    WaterInfo.left += WaterInfo.step;
    //通知consumer
    notifyListeners();
  }

  void downUtil() {
    WaterInfo.bottom -= WaterInfo.step;
    //通知consumer
    notifyListeners();
  }

  void leftUtil() {
    WaterInfo.left -= WaterInfo.step;
    //通知consumer
    notifyListeners();
  }

  void sliderUtil() {
    ToolInfo.position = false;
    ToolInfo.slider = true;
    //通知consumer
    notifyListeners();
  }

  void sliderVal(double newValue) {
    WaterInfo.step = newValue;
    //通知consumer
    notifyListeners();
  }

  void resetUtil() {
    WaterInfo.bottom = 10;
    WaterInfo.left = 10;
    //通知consumer
    notifyListeners();
  }

  void addUsr(BuildContext context, String path) {
    Setting.info.add(path);
    //通知界面
    Usr.usr.add(Setting.usrCard(context, path));
    //通知consumer
    notifyListeners();
  }

  void deleteUsr(BuildContext context, String path) {
    Setting.info.remove(path);
    //通知界面
    Usr.usr.remove(Setting.usrCard(context, path));
    //通知consumer
    notifyListeners();
  }

  void saveImg(BuildContext context) {
    if (Loading.loading == false) {
      //加载框刷新
      Loading.loading = true;
      //通知consumer
      notifyListeners();
      //开始保存
      PicUtil.capturePng(Info.globalKey).then((savedFile) {
        print('图片保存成功!导出路径为:$savedFile');
        if (savedFile != null) {
          Loading.loading = false;
          // Toast.show('保存成功', context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          //通知consumer
          notifyListeners();
        } else {
          Loading.loading = false;
          // Toast.show('保存失败', context,
          // duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          //通知consumer
          notifyListeners();
        }
      });
    }
  }

  //通知获得的初始主题
  get indexTheme => _indexTheme;
}
