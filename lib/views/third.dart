import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:new_app/config/provider_config.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/utils/theme_util.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_setting.dart';
// import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';

CurvedAnimation curved; //曲线动画，动画插值，
CurvedAnimation light; //曲线动画，动画插值，

AnimationController controller; //动画控制器
AnimationController lightcontroller; //动画控制器

class Third extends StatefulWidget {
  @override
  ThirdState createState() => ThirdState();
}

class ListCard extends StatelessWidget {
  final Widget title, leading, subtitle, trailing;
  final Function func;
  ListCard({this.title, this.leading, this.subtitle, this.trailing, this.func});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: ListTile(
          title: title,
          leading: leading,
          subtitle: subtitle,
          trailing: trailing,
          onTap: () => func()),
    );
  }
}

class LightMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: Container(
        key: ValueKey(Themes.dark),
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
  }
}

class ThirdState extends State<Third> with TickerProviderStateMixin {
  String sDocumenttempDir;
  String sDocumentDir;
  String sDCardDir;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String device;
  Future getUserSetting() async {
    if (Platform.isAndroid) {
      sDocumenttempDir = (await getExternalStorageDirectory()).toString();
      //去除首尾
      sDocumentDir =
          sDocumenttempDir.replaceAll('\'', '').replaceAll('Directory: /', '');
    }
    sDocumentDir = '内部存储/Pictures/';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.utsname.machine;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    double outputQuality = pref.getDouble("outputQuality");
    String outputQualityText = pref.getString("outputQualityText");
    String outputType = pref.getString("outputType");
    Setting.outputQuality['outputQuality'] = outputQuality;
    Setting.outputQuality['outputQualityText'] = outputQualityText;
    Setting.outputType = outputType;
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

  //导出路径
  Widget outputPath() {
    return ListCard(
        title: Text('导出路径'),
        leading: Icon(Icons.folder),
        subtitle: sDocumentDir == null ? null : Text(sDocumentDir),
        func: () async {
          // PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          //   String appName = packageInfo.appName;
          //   String packageName = packageInfo.packageName;
          //   String version = packageInfo.version;
          //   String buildNumber = packageInfo.buildNumber;
          //   print(appName);
          // });
          // String sDocumentDir = (await getApplicationDocumentsDirectory()).path;
          // debugPrint(sDocumentDir);
        });
  }

  Future setType(String type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('outputType', type);
    Setting.outputType = type;
  }

  List types = ['JPEG', 'PNG', 'TGA'];
  Widget outputType() {
    return ListCard(
        title: Text('导出格式'),
        leading: Icon(Icons.insert_drive_file),
        trailing:
            Text(Setting.outputType, style: TextStyle(color: Colors.grey)),
        func: () {
          CustomSimpleDialog.dialog(
              context,
              '导出格式',
              types.map((output) {
                return ListTile(
                  title: Text(output),
                  trailing: CircleAvatar(
                      child: Text(
                        output,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: Colors.blue),
                  onTap: () {
                    setState(() {
                      setType(output);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList());
        });
  }

  Widget theme() {
    return ListCard(
        title: Text('主题选择'),
        leading: Icon(Icons.palette),
        trailing: CircleAvatar(
          radius: 15,
          backgroundColor: Provider.of<CommonModel>(context).color,
        ),
        func: () async {
          ThemeUtil.selectTheme(context);
        });
  }

  //导出质量选项
  Widget outputQuality() {
    return ListCard(
      title: Text('导出质量'),
      leading: Icon(Icons.sd_card),
      trailing: Text(Setting.outputQuality['outputQualityText'],
          style: TextStyle(color: Colors.grey)),
      func: () async {
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
    );
  }

  //设备信息
  Widget deviceList() {
    return ListCard(
      title: Text('设备信息'),
      leading: Icon(Icons.phone_android),
      trailing: Text(
        device != null ? device : '未知设备',
        style: TextStyle(color: Colors.grey),
      ),
      func: () {},
    );
  }

  //项目地址
  Widget projectUrl() {
    return ListCard(
      title: Text('项目地址'),
      leading: Icon(Icons.code),
      trailing: Text(
        '喜欢就点个star8~',
        style: TextStyle(color: Colors.grey),
      ),
      func: () async {
        const url = 'https://github.com/Vincehx97/WaterMark';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw '无法加载 $url';
        }
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
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    children: <Widget>[
                      outputPath(),
                      outputType(),
                      theme(),
                      outputQuality(),
                      deviceList(),
                      projectUrl(),
                      LightMode(),
                    ],
                  ),
                );
              })),
    );
  }
}
