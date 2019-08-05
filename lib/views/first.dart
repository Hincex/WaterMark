import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/public.dart';
import 'package:new_app/utils/pics_util.dart';
import '../models/brand.dart';
import 'package:flutter/animation.dart';

class First extends StatefulWidget {
  @override
  FirstState createState() => FirstState();
}

class FirstState extends State<First> with TickerProviderStateMixin {
  //品牌列表
  List _list = [];
  CurvedAnimation curved; //曲线动画，动画插值，
  AnimationController controller; //动画控制器
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    curved = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    //遍历品牌列表
    Brand.brand.forEach((key, value) {
      _list.add(brandCard(value, key));
    });
    controller.forward().then((f) {
      controller.reverse();
    });
  }

  void dispose() {
    controller.dispose();
    //销毁后清空品牌列表
    _list.clear();
    super.dispose();
  }

  //品牌列表卡片
  Widget brandCard(Image brand, key) {
    return AnimatedBuilder(
        animation: curved,
        builder: (ctx, child) {
          return Transform.translate(
              offset: Offset(0, (curved.value)),
              child: Card(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: InkWell(
                      child: brand,
                      onTap: () {
                        Brand.key = key;
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                                backgroundColor: Themes.dark
                                    ? ThemeData.dark().backgroundColor
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                title: Text(
                                  '选择图片',
                                  textAlign: TextAlign.center,
                                ),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: ListTile(
                                      title: Text(
                                        '拍照',
                                      ),
                                      trailing: Icon(Icons.camera),
                                    ),
                                    onPressed: () async {
                                      await PicUtil.takePic();
                                      //先关闭对话框
                                      Navigator.of(context).pop();
                                      if (PublicInfo.img != null) {
                                        //再进入编辑界面
                                        Navigator.of(context)
                                            .pushNamed("/detail");
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
                                      await PicUtil.getGallery();
                                      //先关闭对话框
                                      Navigator.of(context).pop();
                                      if (PublicInfo.img != null) {
                                        //再进入编辑界面
                                        Navigator.of(context)
                                            .pushNamed("/detail");
                                      }
                                    },
                                  )
                                ]);
                          },
                        );
                      })));
        });
  }

  //主界面构造
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.themeData,
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('水印库'),
            elevation: 0,
          ),
          body: ListView(
            children: <Widget>[
              //生成列表
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                reverse: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return _list[index];
                },
                itemCount: _list.length,
              )
            ],
          )),
    );
  }
}
