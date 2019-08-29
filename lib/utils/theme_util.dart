import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_app/config/provider_config.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
// import 'package:toast/toast.dart';

class ThemeUtil {
  static int prevIndex;
  //本地持久化主题设置
  static void saveTheme(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('localTheme', index);
    // print(index);
  }

  //判断是否夜间模式
  static void setTheme(index, BuildContext context) {
    if (Themes.dark && index != 0) {
      Toast.show('请先关闭夜间模式！', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      Timer(Duration(milliseconds: 50), () {
        // 只在倒计时结束时回调
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
      //记录当前数据
      Themes.tempThemeData =
          Themes.dark ? Themes.tempThemeData : Themes.themes[index];
      // 记录显示数据
      Themes.themeData = Themes.themes[index];
      Provider.of<CommonModel>(context)
          .themechange(Themes.dark ? Themes.themeData : Themes.tempThemeData);
      if (index != 0 && Themes.dark) {
        Themes.dark = !Themes.dark;
      }
      print(Themes.dark);
      saveTheme(index);
    }
  }

  //夜间/日间模式切换
  static void themeMode(BuildContext context) {
    // controller.reverse();
    Themes.dark = !Themes.dark;
    /**主题切换逻辑 */
    Themes.themeData = Themes.dark ? Themes.themes[0] : Themes.tempThemeData;
    if (Themes.dark) {
      setTheme(0, context);
    } else {
      setTheme(Themes.themes.indexOf(Themes.tempThemeData), context);
    }
    Provider.of<CommonModel>(context).themechange(Themes.themeData);
  }

//选择主题
  static void selectTheme(BuildContext context) {
    //主题选择对话框
    CustomSimpleDialog.dialog(context, '选择主题', [
      ListTile(
        title: Text('水鸭青',
            style: TextStyle(color: Themes.dark ? Colors.white : Colors.black)),
        trailing: CircleAvatar(backgroundColor: Colors.teal),
        onTap: () {
          setTheme(1, context);
        },
      ),
      ListTile(
        title: Text('基佬紫',
            style: TextStyle(color: Themes.dark ? Colors.white : Colors.black)),
        trailing: CircleAvatar(backgroundColor: Colors.purple),
        onTap: () {
          setTheme(2, context);
        },
      ),
      ListTile(
        title: Text('姨妈红',
            style: TextStyle(color: Themes.dark ? Colors.white : Colors.black)),
        trailing: CircleAvatar(backgroundColor: Colors.red),
        onTap: () {
          setTheme(3, context);
        },
      ),
      ListTile(
        title: Text('少女粉',
            style: TextStyle(color: Themes.dark ? Colors.white : Colors.black)),
        trailing: CircleAvatar(backgroundColor: Colors.pinkAccent),
        onTap: () {
          setTheme(4, context);
        },
      ),
      ListTile(
        title: Text('谷歌蓝',
            style: TextStyle(color: Themes.dark ? Colors.white : Colors.black)),
        trailing: CircleAvatar(backgroundColor: Colors.blue),
        onTap: () {
          setTheme(5, context);
        },
      ),
    ]);
  }
}
