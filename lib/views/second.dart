import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/database_helper.dart';
import 'package:new_app/models/public.dart';
import 'package:new_app/models/user_setting.dart';
import 'package:new_app/models/user_setting.dart' as prefix1;
import 'package:new_app/utils/usr_mark_util.dart';
import 'package:new_app/widgets/dialog.dart';

class Second extends StatefulWidget {
  @override
  SecondState createState() => SecondState();
}

class Usr {
  static List usr = [];
}

class SecondState extends State<Second> with TickerProviderStateMixin {
  CurvedAnimation curved; //曲线动画，动画插值，
  AnimationController controller; //动画控制器
  var db = new DatabaseHelper();

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    curved = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    controller.forward();
    //先添加一个添加按钮
    Usr.usr.insert(0, addCard());
    Setting.info.forEach((value) {
      if (value != null) Usr.usr.add(Setting.usrCard(context, value));
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Usr.usr.clear();
    Usr.usr.insert(0, addCard());
    Setting.info.forEach((value) {
      if (value != null) Usr.usr.add(Setting.usrCard(context, value));
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    Usr.usr.clear();
    super.dispose();
  }

  //添加按钮卡片
  Widget addCard() {
    return Container(
      height: 100,
      child: Card(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: InkWell(
              child: Icon(Icons.add),
              onTap: () {
                CustomSimpleDialog.dialog(context, '选择自定义水印', [
                  SimpleDialogOption(
                    child: ListTile(
                      title: Text(
                        '拍照',
                      ),
                      trailing: Icon(Icons.camera),
                    ),
                    onPressed: () async {
                      await UsrMarkUtil.takePic(context);
                      //先关闭对话框
                      Navigator.of(context).pop();
                      if (PublicInfo.usrMark != null) {
                        //再进入编辑界面
                        setState(() {
                          // usrcard.add(usrCard(PublicInfo.usrMark));
                        });
                      }
                    },
                  ),
                  SimpleDialogOption(
                    child: ListTile(
                      title: Text(
                        '图库',
                      ),
                      trailing: Icon(Icons.insert_photo),
                    ),
                    onPressed: () async {
                      await UsrMarkUtil.getGallery(context);
                      //先关闭对话框
                      Navigator.of(context).pop();
                      if (PublicInfo.usrMark != null) {
                        //再进入编辑界面
                        // setState(() {
                        // usrcard.add(usrCard(PublicInfo.usrMark));
                        // });
                      }
                    },
                  )
                ]);
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.themeData,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('自定义'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          children: <Widget>[
            //生成列表
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              reverse: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Usr.usr[index];
              },
              itemCount: Usr.usr.length,
            )
          ],
        ),
      ),
    );
  }
}
