import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_app/utils/global_config.dart';
import '../models/brand.dart';
// import '../models/mark.dart';
import '../models/public.dart';
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
    controller.forward();
    //遍历品牌列表
    Brand.brand.forEach((key, value) {
      _list.add(brandCard(value, key));
    });
    controller.forward();
    // print(Mark.mark['Honor'][0]['pics']);
  }

  void dispose() {
    controller.dispose();
    _list.clear();
    super.dispose();
    //销毁后清空品牌列表
  }

  //拍照
  Future _takePic() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      PublicInfo.img = image;
      Navigator.of(context).pushNamed("/detail");
    }
  }

  //获取图库
  Future _getGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      PublicInfo.img = image;
      Navigator.of(context).pushNamed("/detail");
    }
  }

  //品牌列表卡片
  Widget brandCard(Image brand, key) {
    return FadeTransition(
        opacity: curved,
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
                          backgroundColor: GlobalConfig.dark
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
                              onPressed: () {
                                _takePic();
                                Navigator.of(context).pop();
                              },
                            ),
                            SimpleDialogOption(
                              child: ListTile(
                                title: Text(
                                  '图库',
                                ),
                                trailing: Icon(Icons.insert_photo),
                              ),
                              onPressed: () {
                                _getGallery();
                                Navigator.of(context).pop();
                              },
                            )
                          ]);
                    },
                  );
                })));
  }

  //主界面构造
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlobalConfig.themeData,
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
