import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_app/config/provider_config.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/utils/theme_util.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:path_provider/path_provider.dart';
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
  CurvedAnimation light; //曲线动画，动画插值，

  AnimationController controller; //动画控制器
  AnimationController lightcontroller; //动画控制器
  String sDocumentDir;

  Future getUserSetting() async {
    sDocumentDir = (await getApplicationDocumentsDirectory()).toString();
    SharedPreferences pref = await SharedPreferences.getInstance();
    double outputQuality = pref.getDouble("outputQuality");
    String outputQualityText = pref.getString("outputQualityText");
    Setting.outputQuality['outputQuality'] = outputQuality;
    Setting.outputQuality['outputQualityText'] = outputQualityText;
  }

  @override
  void initState() {
    //获取用户自定义设置
    getUserSetting();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    lightcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    curved = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    light = CurvedAnimation(
        parent: lightcontroller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    controller.forward().then((f) {
      // controller.reverse();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  //导出路径
  Widget outputPath() {
    return listCard(ListTile(
      title: Text('导出路径'),
      leading: Icon(Icons.folder),
      subtitle: sDocumentDir == null ? null : Text(sDocumentDir),
      onTap: () async {
        // String sDocumentDir = (await getApplicationDocumentsDirectory()).path;
        // debugPrint(sDocumentDir);
      },
    ));
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
        CustomSimpleDialog.dialog(context, '导出质量选择', [
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
        ]);
      },
    ));
  }

  Widget theme() {
    return listCard(ListTile(
      title: Text('主题选择'),
      leading: Icon(Icons.palette),
      trailing: CircleAvatar(
        radius: 15,
        backgroundColor: Provider.of<CommonModel>(context).color,
      ),
      onTap: () async {
        ThemeUtil.selectTheme(context);
      },
    ));
  }

  Widget lightMode() {
    return AnimatedBuilder(
      animation: light,
      builder: (ctx, child) {
        return Transform.rotate(
          angle: -pi / 2 * light.value,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: IconButton(
              icon: Icon(Themes.dark ? Icons.brightness_2 : Icons.brightness_5,
                  color: Themes.dark ? Colors.purple : Colors.orange),
              onPressed: () {
                ThemeUtil.themeMode(context);
                lightcontroller.forward().then((f) {
                  lightcontroller.reverse();
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<CommonModel>(context).themeUsr,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('设置'),
          ),
          body: AnimatedBuilder(
              animation: curved,
              builder: (ctx, child) {
                return Transform.translate(
                  offset: Offset(0, (curved.value)),
                  child: ListView(
                    children: <Widget>[
                      outputPath(),
                      outputQuality(),
                      theme(),
                      lightMode(),
                    ],
                  ),
                );
              })),
    );
  }
}
