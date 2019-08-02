import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:new_app/utils/global_config.dart';
// import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';
import 'dart:ui' as ui;
import '../models/mark.dart';
import '../utils/tools.dart';
import '../models/brand.dart';
import '../models/public.dart';
import '../models/user_setting.dart';
import '../utils/loading.dart';
import 'package:flutter/animation.dart';

class FirstDetail extends StatefulWidget {
  @override
  FirstDetailState createState() => FirstDetailState();
}

//水印信息
class WaterInfo {
  static double top;
  static double right;
  static double bottom = 10;
  static double left = 10;
}

//图片信息
class PicInfo {
  static double height;
  static double width;
}

//工具信息
class ToolInfo {
  static bool toolbar = true;
  static bool size = false;
  static bool position = false;
  static bool change = false;
}

class FirstDetailState extends State<FirstDetail>
    with TickerProviderStateMixin {
  //分别是导出图片、appbar、图片的key
  final GlobalKey globalKey = GlobalKey();
  final GlobalKey appbar = GlobalKey();
  final GlobalKey imgkey = GlobalKey();
  CurvedAnimation curved; //曲线动画，动画插值，
  AnimationController controller; //动画控制器
  File img;
  //分别是工具箱、图片尺寸工具箱、水印位置工具箱
  List _tools = [], _sizetools = [], _postools = [];
  List<Widget> _mark = [];
  double slider = 2;

  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    curved = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //模仿小球自由落体运动轨迹
    controller.forward();
    //初始化图片状态
    initPic();
    //获取当前品牌所有水印
    Mark.mark[Brand.key].forEach((key, value) {
      _mark.add(Mark.markRatio(key, (val) {
        Mark.key = val;
        setState(() {});
        Navigator.of(context).pop();
      }));
    });

    //依次添加工具箱
    //水印位置工具
    _tools.add(Tools.positionBtn(() {
      ToolInfo.toolbar = false;
      ToolInfo.position = true;
      controller.forward();
      setState(() {});
    }));
//    _tools.add(Tools.picSize(() {
//      ToolInfo.toolbar = false;
//      ToolInfo.size = true;
//      // if (PicInfo.height > MediaQuery.of(context).size.height - 100) {
//      // } else {
//      //   PicInfo.height += 20;
//      // }
//      setState(() {});
//    }));
    //更改水印工具
    _tools.add(Tools.changeMark(() {
      showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            children: _mark.map((radio) => radio).toList(),
          );
        },
      );
      //使水印发生变化，重绘界面
      setState(() {});
    }));
    //重置修改工具
    _tools.add(Tools.resetPic(() {
      initPic();
      setState(() {});
    }));
    //位置工具内容
    _postools.add(Tools.backBtn(() {
      setState(() {
        ToolInfo.size = false;
        ToolInfo.position = false;
        ToolInfo.toolbar = true;
        controller.reverse();
        controller.forward();
      });
    }));
    _postools.add(Tools.upBtn(() {
      setState(() {
        WaterInfo.bottom += Setting.speed;
      });
    }));
    _postools.add(Tools.downBtn(() {
      if (WaterInfo.bottom > 0) {
        setState(() {
          WaterInfo.bottom -= Setting.speed;
        });
      }
    }));
    _postools.add(Tools.leftBtn(() {
      if (WaterInfo.left > 0) {
        setState(() {
          WaterInfo.left -= Setting.speed;
        });
      }
    }));
    _postools.add(Tools.rightBtn(() {
      setState(() {
        WaterInfo.left += Setting.speed;
      });
    }));
    _postools.add(Tools.speedBtn(() {
      showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            children: [
              Slider(
                  value: slider,
                  max: 100.0,
                  min: 0.0,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.transparent,
                  onChanged: (double val) {
                    setState(() {
                      slider = val.roundToDouble();
                    });
                  })
            ],
          );
        },
      );
    }));
//    _sizetools.add(Tools.backBtn(() {
//      ToolInfo.size = false;
//      ToolInfo.position = false;
//      ToolInfo.toolbar = true;
//      setState(() {});
//    }));
//    _sizetools.add(Tools.adjustSize(() {
////      ToolInfo.size = false;
////      ToolInfo.position = false;
////      ToolInfo.toolbar = true;
//      setState(() {});
//    }));
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    PicInfo.width = MediaQuery.of(context).size.width;
  }

  void dispose() {
    super.dispose();
    controller.dispose();
    //将默认置为0,避免换了水印之后其他品牌没有该索引
    Mark.key = 0;
  }

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    //pixelRatio决定导出质量
    ui.Image image = await boundary.toImage(
        pixelRatio: Setting.outputQuality['outputQuality']);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // var codec = await ui.instantiateImageCodec(pngBytes);
    // var frameInfo = await codec.getNextFrame();
    // print(pngBytes);
    //强制刷新Widget
    //保存导出的图片
    Uint8List _outputImage;
    setState(() {
      _outputImage = pngBytes;
    });
    _saveImg(_outputImage);
  }

  Future _saveImg(Uint8List _outputImage) async {
    var filePath = await ImagePickerSaver.saveFile(fileData: _outputImage);
    var savedFile = File.fromUri(Uri.file(filePath));
    if (savedFile != null) {
      setState(() {
        Loading.loading = false;
        Toast.show('保存成功', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      });
    } else {
      setState(() {
        Loading.loading = false;
        Toast.show('保存失败', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      });
    }
    setState(() {});
  }

  //初始化图片信息
  void initPic() {
    WaterInfo.top = null;
    WaterInfo.right = null;
    WaterInfo.bottom = 10;
    WaterInfo.left = 10;
    PicInfo.height = 250;
    // PicInfo.width = MediaQuery.of(context).size.width;
  }

  Widget bottomShow(BuildContext context) {
    if (ToolInfo.toolbar) {
      return FadeTransition(
          opacity: curved,
          child: Container(
            alignment: Alignment.center,
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(50.0)),
            //工具按钮
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              reverse: false,
              itemBuilder: (_, int index) => _tools[index],
              itemCount: _tools.length,
            ),
          ));
      // return FadeTransition(
      //     opacity: curved,
      //     child: Container(
      //       margin: EdgeInsets.only(bottom: 10),
      //       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      //       height: 70,
      //       width: MediaQuery.of(context).size.width,
      //       child: FloatingActionButton(
      //         isExtended: true,
      //         onPressed: () {},
      //         child: ListView.builder(
      //           scrollDirection: Axis.horizontal,
      //           reverse: false,
      //           itemBuilder: (_, int index) => _tools[index],
      //           itemCount: _tools.length,
      //         ),
      //       ),
      //     ));
    } else {
//      if (ToolInfo.size) {
//        return Container(
//          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      // height: MediaQuery.of(context).size.height / 4,
      // width: 80,
      //  decoration: BoxDecoration(
      //     color: Colors.black54,
      //     borderRadius: BorderRadius.circular(15.0)),
//          //工具按钮
//          child: ListView.builder(
//            scrollDirection: Axis.horizontal,
//            // padding: EdgeInsets.all(8.0),
//            reverse: false,
//            itemBuilder: (_, int index) => _sizetools[index],
//            itemCount: _sizetools.length,
//          ),
//        );
//      } else if (ToolInfo.position) {
      if (ToolInfo.position) {
        return FadeTransition(
          opacity: curved,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: MediaQuery.of(context).size.height / 2,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15.0)),
            //工具按钮
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              // padding: EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, int index) => _postools[index],
              itemCount: _postools.length,
            ),
          ),
        );
      }
    }
  }

//   Widget mainScreen() {
//     return Loading.loadingScreen(
//         Container(
//           decoration: BoxDecoration(color: Colors.black),
//           child: Stack(
//             overflow: Overflow.visible,
//             children: <Widget>[
//               ListView(
//                 children: <Widget>[
//                   Center(
//                     child: RepaintBoundary(
//                       key: globalKey,
//                       child: //图片
//                           Stack(
//                         key: imgkey,
//                         children: <Widget>[
//                           Image.file(
//                             PublicInfo.img,
// //                          height: PicInfo.height,
//                             fit: BoxFit.fill,
// //                          width: MediaQuery.of(context).size.width,
//                             filterQuality: FilterQuality.high,
//                           ),
//                           //水印
//                           Positioned(
//                               top: WaterInfo.top == null ? null : WaterInfo.top,
//                               right: WaterInfo.right == null
//                                   ? null
//                                   : WaterInfo.right,
//                               bottom: WaterInfo.bottom == null
//                                   ? null
//                                   : WaterInfo.bottom,
//                               left: WaterInfo.left == null
//                                   ? null
//                                   : WaterInfo.left,
//                               child: DragTarget(onWillAccept: (data) {
//                                 print("onWillAccept");
//                                 return data !=
//                                     null; //当Draggable传递过来的dada不是null的时候 决定接收该数据。
//                               }, onAccept: (data) {
//                                 print("donAccept");
//                                 setState(() {});
//                               }, onLeave: (data) {
//                                 print("onLeave"); //我来了 我又走了
//                               }, builder:
//                                   (context, candidateData, rejectedData) {
//                                 return Draggable(
//                                     onDragEnd: (details) {
// //                                        print(details.offset.dx);
//                                       print(details.offset.dy);
//                                       print(
//                                           globalKey.currentContext.size.height);
//                                       print(appbar.currentContext.size.height);
//                                       if (details.offset.dy <=
//                                           globalKey.currentContext.size.height +
//                                               appbar
//                                                   .currentContext.size.height) {
//                                         WaterInfo.bottom = globalKey
//                                                 .currentContext.size.height +
//                                             appbar.currentContext.size.height -
//                                             details.offset.dy;
//                                       } else {
//                                         WaterInfo.bottom = 10;
//                                       }
//                                       //强制刷新Widget
//                                       setState(() {
//                                         WaterInfo.left = details.offset.dx;
//                                         // WaterInfo.top = bottom;
//                                       });
//                                     },
//                                     feedback: Mark.mark[Brand.key][Mark.key]
//                                         ['pics'],
//                                     child: Mark.mark[Brand.key][Mark.key]
//                                         ['pics'],
//                                     //原位置占位
//                                     childWhenDragging: Container(
//                                       child: null,
//                                     ));
//                               })),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               //底部工具栏
//               Positioned(left: 0, bottom: 10, child: bottomShow(context))
//             ],
//           ),
//         ),
//         '保存中');
//   }
  Widget mainScreen() {
    return Loading.loadingScreen(
        Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Center(
                  child: SingleChildScrollView(
                child: RepaintBoundary(
                  key: globalKey,
                  child: //图片
                      Stack(
                    key: imgkey,
                    children: <Widget>[
                      Image.file(
                        PublicInfo.img,
                        // height: 2000,
                        fit: BoxFit.fill,
//                          width: MediaQuery.of(context).size.width,
                        filterQuality: FilterQuality.high,
                      ),
                      //水印
                      Positioned(
                          top: WaterInfo.top == null ? null : WaterInfo.top,
                          right:
                              WaterInfo.right == null ? null : WaterInfo.right,
                          bottom: WaterInfo.bottom == null
                              ? null
                              : WaterInfo.bottom,
                          left: WaterInfo.left == null ? null : WaterInfo.left,
                          child: DragTarget(onWillAccept: (data) {
                            print("onWillAccept");
                            return data !=
                                null; //当Draggable传递过来的dada不是null的时候 决定接收该数据。
                          }, onAccept: (data) {
                            print("donAccept");
                            setState(() {});
                          }, onLeave: (data) {
                            print("onLeave"); //我来了 我又走了
                          }, builder: (context, candidateData, rejectedData) {
                            return Draggable(
                                onDragEnd: (details) {
//                                        print(details.offset.dx);
                                  print(details.offset.dy);
                                  print(globalKey.currentContext.size.height);
                                  print(appbar.currentContext.size.height);
                                  //图片尺寸小于屏幕时
                                  if (globalKey.currentContext.size.height <
                                      MediaQuery.of(context).size.height) {
                                    WaterInfo.bottom = MediaQuery.of(context)
                                            .size
                                            .height +
                                        appbar.currentContext.size.height -
                                        details.offset.dy -
                                        (MediaQuery.of(context).size.height +
                                                appbar.currentContext.size
                                                    .height -
                                                globalKey.currentContext.size
                                                    .height) /
                                            2 -
                                        20;
                                  }
                                  //当图片高度大于屏幕时
                                  else {
                                    WaterInfo.bottom =
                                        MediaQuery.of(context).size.height -
                                            details.offset.dy;
                                  }
                                  // if (details.offset.dy <=
                                  //     globalKey.currentContext.size.height +
                                  //         appbar.currentContext.size.height) {
                                  //   WaterInfo.bottom =
                                  //       globalKey.currentContext.size.height +
                                  //           appbar.currentContext.size.height -
                                  //           details.offset.dy;
                                  // } else {
                                  //   WaterInfo.bottom = 10;
                                  // }
                                  //强制刷新Widget
                                  setState(() {
                                    WaterInfo.left = details.offset.dx;
                                    // WaterInfo.top = bottom;
                                  });
                                },
                                feedback: Mark.mark[Brand.key][Mark.key]
                                    ['pics'],
                                child: Mark.mark[Brand.key][Mark.key]['pics'],
                                //原位置占位
                                childWhenDragging: Container(
                                  child: null,
                                ));
                          })),
                    ],
                  ),
                ),
              )),
              //底部工具栏
              Positioned(right: 10, bottom: 50, child: bottomShow(context))
            ],
          ),
        ),
        '保存中');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlobalConfig.themeData,
      home: Scaffold(
          appBar: AppBar(
            key: appbar,
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(Icons.save),
                onPressed: () async {
                  setState(() {
                    Loading.loading = true;
                  });
                  await _capturePng();
                },
              )
            ],
            title: Text('制作'),
          ),
          body: mainScreen()),
    );
  }
}
