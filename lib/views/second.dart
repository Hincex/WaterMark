import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/public.dart';
import 'package:new_app/utils/usr_mark_util.dart';
import 'package:new_app/widgets/dialog.dart';

class Second extends StatefulWidget {
  @override
  SecondState createState() => SecondState();
}

class SecondState extends State<Second> with TickerProviderStateMixin {
  CurvedAnimation curved; //曲线动画，动画插值，
  AnimationController controller; //动画控制器
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    curved = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //品牌列表卡片
  Widget addCard() {
    return AnimatedBuilder(
        animation: curved,
        builder: (ctx, child) {
          return Transform.translate(
              offset: Offset(0, (curved.value)),
              child: Container(
                height: 100,
                child: Card(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                await UsrMarkUtil.takePic();
                                //先关闭对话框
                                Navigator.of(context).pop();
                                if (PublicInfo.img != null) {
                                  //再进入编辑界面
                                  // Navigator.of(context).pushNamed("/detail");
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
                                await UsrMarkUtil.getGallery();
                                //先关闭对话框
                                Navigator.of(context).pop();
                                if (PublicInfo.usrMark != null) {
                                  //再进入编辑界面
                                  // Navigator.of(context).pushNamed("/detail");
                                }
                              },
                            )
                          ]);
                        })),
              ));
        });
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
          children: <Widget>[
            addCard(),
          ],
        ),
      ),
    );
  }
}
