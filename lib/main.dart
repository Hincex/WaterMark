import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/utils/global_config.dart';
import 'package:provider/provider.dart';
import 'models/store/model/index.dart';
import 'nav.dart';
//路由
import 'views/first_detail.dart';
import 'views/first_list.dart';
//本地存储
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_setting.dart';

//获取用户本地个性化设置
Future getUsrSetting() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int themeIndex = pref.getInt("localTheme");
  if (themeIndex != null) {
    GlobalConfig.themeData = GlobalConfig.themes[themeIndex];
    GlobalConfig.tempThemeData = GlobalConfig.themes[themeIndex];
    return themeIndex;
  } else {
    GlobalConfig.themeData = GlobalConfig.themes[1];
  }
  double outputQuality = pref.getDouble("outputQuality");
  String outputQualityText = pref.getString("outputQualityText");
  double speed = pref.getDouble("speed");
  if (speed != null) {
    Setting.speed = speed;
  } else {
    pref.setDouble('speed', 1.0);
    Setting.speed = 1;
  }
  if (outputQuality != null) {
    Setting.outputQuality['outputQuality'] = outputQuality;
    Setting.outputQuality['outputQualityText'] = outputQualityText;
  } else {
    pref.setDouble('outputQuality', 7.0);
    pref.setString('outputQualityText', '高');
    Setting.outputQuality['quality'] = 7.0;
  }
}

void main() async {
  await getUsrSetting();
  print(Setting.outputQuality);
  runApp(ChangeNotifierProvider<ThemeChange>.value(
    value: ThemeChange(GlobalConfig.themeData),
    child: MyApp(),
  ));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeChange>(context).themeUsr,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Nav(),
      ),
      routes: {
        "/detail": (BuildContext context) => FirstDetail(),
        "/list": (BuildContext context) => FirstList(),
      },
    );
  }
}
