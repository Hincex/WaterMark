import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/provider_config.dart';
import 'config/theme_data.dart';
import 'nav.dart';
//路由
import 'views/first_detail.dart';
//本地存储
import 'models/user_setting.dart';

void main() async {
  await Setting.getUsrSetting();
  runApp(ChangeNotifierProvider<CommonModel>.value(
    value: CommonModel(Themes.themeData),
    child: MyApp(),
  ));
  //安卓状态栏沉浸
  if (Platform.isAndroid) {
    //写在组件渲染之后，为了在渲染后进行set赋值，覆盖状态栏
    //写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<CommonModel>(context).themeUsr,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Nav(),
      ),
      routes: {
        "/detail": (BuildContext context) => FirstDetail(),
      },
    );
  }
}
