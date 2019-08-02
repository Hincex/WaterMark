import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_app/models/store/model/index.dart';
import 'package:new_app/utils/global_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../models/user_setting.dart';

class Third extends StatefulWidget {
  @override
  ThirdState createState() => ThirdState();
}

class ThirdState extends State<Third> with TickerProviderStateMixin {
  CurvedAnimation curved; //曲线动画，动画插值，
  AnimationController controller; //动画控制器
  Future getUserSetting() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    double outputQuality = pref.getDouble("outputQuality");
    String outputQualityText = pref.getString("outputQualityText");
    Setting.outputQuality['outputQuality'] = outputQuality;
    Setting.outputQuality['outputQualityText'] = outputQualityText;
  }

  void initState() {
    super.initState();
    getUserSetting();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    curved = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    controller.forward();
  }

  //列表卡片
  Card listCard(Widget childWidget) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: childWidget,
    );
  }

  //导出质量选项
  Widget outputQuality() {
    return listCard(ListTile(
      title: Text('导出质量'),
      leading: Icon(Icons.sd_card),
      trailing: Text(Setting.outputQuality['outputQualityText'],
          style: TextStyle(color: Colors.grey)),
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        showDialog<Null>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              children: [
                ListTile(
                  title: Text('高'),
                  subtitle: Text('质量最好,导出时间最长'),
                  trailing: CircleAvatar(backgroundColor: Colors.blue),
                  onTap: () {
                    setState(() {
                      pref.setDouble('outputQuality', 7.0);
                      pref.setString('outputQualityText', '高');
                      Setting.outputQuality['outputQuality'] = 7.0;
                      Setting.outputQuality['outputQualityText'] = '高';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('中'),
                  subtitle: Text('质量中等,导出时间一般'),
                  trailing: CircleAvatar(backgroundColor: Colors.teal),
                  onTap: () {
                    setState(() {
                      pref.setDouble('outputQuality', 5.0);
                      pref.setString('outputQualityText', '中');
                      Setting.outputQuality['outputQuality'] = 5.0;
                      Setting.outputQuality['outputQualityText'] = '中';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('低'),
                  subtitle: Text('质量较差,导出时间最快'),
                  trailing: CircleAvatar(backgroundColor: Colors.yellow),
                  onTap: () {
                    setState(() {
                      pref.setDouble('outputQuality', 3.0);
                      pref.setString('outputQualityText', '低');
                      Setting.outputQuality['outputQuality'] = 3.0;
                      Setting.outputQuality['outputQualityText'] = '低';
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    ));
  }

  Widget lightMode() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: IconButton(
        icon: Icon(GlobalConfig.dark ? Icons.brightness_2 : Icons.brightness_5,
            color: GlobalConfig.dark ? Colors.purple : Colors.orange),
        onPressed: () {
          themeMode(context);
        },
      ),
    );
  }

  Widget theme() {
    return listCard(ListTile(
      title: Text('主题选择'),
      leading: Icon(Icons.palette),
      trailing: CircleAvatar(
        radius: 15,
        backgroundColor: Provider.of<ThemeChange>(context).color,
      ),
      onTap: () async {
        selectTheme(context);
      },
    ));
  }

  //本地持久化主题设置
  void saveTheme(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('localTheme', index);
    // print(index);
  }

//判断是否夜间模式
  void setTheme(index, BuildContext context) {
    if (GlobalConfig.dark) {
      Toast.show('请先关闭夜间模式！', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      GlobalConfig.tempThemeData = GlobalConfig.themes[index];
      GlobalConfig.themeData = GlobalConfig.themes[index];
      Provider.of<ThemeChange>(context).themechange(GlobalConfig.themes[index]);
      saveTheme(index);
      Timer(Duration(milliseconds: 50), () {
        // 只在倒计时结束时回调
        Navigator.of(context).pop();
      });
    }
  }

//夜间/日间模式切换
  void themeMode(BuildContext context) {
    // controller.reverse();
    GlobalConfig.dark = !GlobalConfig.dark;
    /**主题切换逻辑 */
    GlobalConfig.themeData =
        GlobalConfig.dark ? GlobalConfig.themes[0] : GlobalConfig.tempThemeData;
    Provider.of<ThemeChange>(context).themechange(GlobalConfig.themeData);
    // controller.forward();
  }

//选择主题
  void selectTheme(BuildContext context) {
    //主题选择对话框
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
            backgroundColor: GlobalConfig.dark
                ? ThemeData.dark().backgroundColor
                : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text(
              '选择你的主题',
              style: TextStyle(
                  color: GlobalConfig.dark ? Colors.white : Colors.black),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              ListTile(
                title: Text('水鸭青',
                    style: TextStyle(
                        color:
                            GlobalConfig.dark ? Colors.white : Colors.black)),
                trailing: CircleAvatar(backgroundColor: Colors.teal),
                onTap: () {
                  setTheme(1, context);
                },
              ),
              ListTile(
                title: Text('基佬紫',
                    style: TextStyle(
                        color:
                            GlobalConfig.dark ? Colors.white : Colors.black)),
                trailing: CircleAvatar(backgroundColor: Colors.purple),
                onTap: () {
                  setTheme(2, context);
                },
              ),
              ListTile(
                title: Text('姨妈红',
                    style: TextStyle(
                        color:
                            GlobalConfig.dark ? Colors.white : Colors.black)),
                trailing: CircleAvatar(backgroundColor: Colors.red),
                onTap: () {
                  setTheme(3, context);
                },
              ),
              ListTile(
                title: Text('少女粉',
                    style: TextStyle(
                        color:
                            GlobalConfig.dark ? Colors.white : Colors.black)),
                trailing: CircleAvatar(backgroundColor: Colors.pinkAccent),
                onTap: () {
                  setTheme(4, context);
                },
              ),
              ListTile(
                title: Text('谷歌蓝',
                    style: TextStyle(
                        color:
                            GlobalConfig.dark ? Colors.white : Colors.black)),
                trailing: CircleAvatar(backgroundColor: Colors.blue),
                onTap: () {
                  setTheme(5, context);
                },
              ),
              // ListTile(
              //   title: Text('羽光白',
              //       style: TextStyle(
              //           color: GlobalConfig.dark ? Colors.white : Colors.black)),
              //   trailing: CircleAvatar(backgroundColor: Colors.white),
              //   onTap: () {
              //     setTheme(6, context);
              //   },
              // ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeChange>(context).themeUsr,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('设置'),
          ),
          body: FadeTransition(
            opacity: curved,
            child: ListView(
              children: <Widget>[
                outputQuality(),
                theme(),
                lightMode(),
              ],
            ),
          )),
    );
  }
}
