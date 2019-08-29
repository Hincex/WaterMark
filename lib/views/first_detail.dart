import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/user_setting.dart';
// import 'package:new_app/utils/pics_util.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:toast/toast.dart';
import '../models/mark.dart';
import '../utils/tools_util.dart';
import '../models/brand.dart';
import '../models/public.dart';
import '../utils/loading.dart';
import 'package:flutter/animation.dart';
import '../widgets/animated_floating_button.dart';

class FirstDetail extends StatefulWidget {
  @override
  FirstDetailState createState() => FirstDetailState();
}

class Info {
  static List<Widget> mark = [];
  static final GlobalKey globalKey = GlobalKey();
}

class FirstDetailState extends State<FirstDetail>
    with TickerProviderStateMixin {
  //分别是导出图片、appbar、图片的key
  final GlobalKey appbar = GlobalKey();
  final GlobalKey imgkey = GlobalKey();
  @override
  void initState() {
    ToolInfo.controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    ToolInfo.animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: ToolInfo.controller, curve: Curves.easeInOut));
    //初始化图片状态
    initPic();
    //自定义
    if (Setting.usrMark != null) {
      Setting.info.forEach((value) {
        Info.mark.add(Mark.usrMarkRatio(value, (value) {
          Setting.usrMark = value;
          setState(() {});
          Navigator.of(context).pop();
        }));
      });
    }
    //非自定义
    else {
      Mark.mark[Brand.key].forEach((key, value) {
        //然后添加到切换水印按钮中
        Info.mark.add(Mark.markRatio(key, (val) {
          Mark.key = val;
          setState(() {});
          Navigator.of(context).pop();
        }));
      });
    }
    ToolInfo.floatbtn = true;
    ToolInfo.tool = false;
    ToolInfo.toolbar = false;
    ToolInfo.size = false;
    ToolInfo.position = false;
    ToolInfo.change = false;
    Loading.loading = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //将默认置为0,避免换了水印之后其他品牌没有该索引
    Mark.key = 0;
    //取消导出
    // Loading.loading = false;
    //清空已加载的水印列表
    Info.mark.clear();
    //
    Setting.usrMark = null;
    //避免内存泄漏
    ToolInfo.controller.dispose();
    super.dispose();
  }

  //初始化图片信息
  void initPic() {
    WaterInfo.top = null;
    WaterInfo.right = null;
    WaterInfo.bottom = PicInfo.height / 25;
    WaterInfo.left = PicInfo.width / 25;
  }

  Widget mark() {
    return Setting.usrMark != null
        ? Container(
            width: PicInfo.width * 0.4,
            height: PicInfo.height * 0.3,
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              Setting.usrMark.replaceAll("File: ", '').replaceAll('\'', ''),
              // alignment: Alignment.topLeft),
            )
          )
        : Container(
            // decoration: BoxDecoration(color: Colors.black),
            alignment: Alignment.bottomLeft,
            width: PicInfo.width * 0.4,
            height: PicInfo.height * 0.3,
            child: Mark.mark[Brand.key][Mark.key]['pics'],
          );
  }

  Widget mainScreen(BuildContext context) {
    return Loading(
      loadingText: '保存中',
      isloading: Loading.loading,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PhotoView.customChild(
            childSize: Size(PicInfo.width, PicInfo.height),
            child: RepaintBoundary(
              key: Info.globalKey,
              child: //图片
                  Stack(
                key: imgkey,
                children: <Widget>[
                  Image.file(
                    PublicInfo.img,
                    height: PicInfo.height,
                    fit: BoxFit.fill,
                    width: PicInfo.width,
                    filterQuality: FilterQuality.high,
                  ),
                  //水印
                  Positioned(
                      top: WaterInfo.top == null ? null : WaterInfo.top,
                      right: WaterInfo.right == null ? null : WaterInfo.right,
                      bottom:
                          WaterInfo.bottom == null ? null : WaterInfo.bottom,
                      left: WaterInfo.left == null ? null : WaterInfo.left,
                      child: DragTarget(
                          onWillAccept: (data) {
                            print("onWillAccept");
                            return data !=
                                null; //当Draggable传递过来的dada不是null的时候 决定接收该数据。
                          },
                          onAccept: (data) {
                            setState(() {});
                          },
                          onLeave: (data) {},
                          builder: (context, candidateData, rejectedData) {
                            return Draggable(
                                onDragEnd: (details) {
                                  //自定义水印和自带水印偏移有出入
                                  if (Setting.usrMark != null) {
                                    setState(() {
                                      WaterInfo.left = details.offset.dx;
                                      print(details.offset.dy);
                                      print(Info.globalKey.currentContext.size
                                          .height);
                                      print(appbar.currentContext.size.height);
                                      //图片尺寸小于屏时
                                      if (Info.globalKey.currentContext.size
                                              .height <
                                          MediaQuery.of(context).size.height) {
                                        WaterInfo.bottom =
                                            MediaQuery.of(context).size.height -
                                                details.offset.dy -
                                                (MediaQuery.of(context)
                                                            .size
                                                            .height +
                                                        appbar.currentContext
                                                            .size.height -
                                                        Info
                                                            .globalKey
                                                            .currentContext
                                                            .size
                                                            .height) /
                                                    2 -
                                                100;
                                      }
                                      //当图片高度大于屏幕时
                                      else {
                                        WaterInfo.bottom =
                                            MediaQuery.of(context).size.height -
                                                details.offset.dy;
                                      }
                                    });
                                  } else {
                                    print(details.offset.dx);
                                    print(details.offset.dy);
                                    print(Info
                                        .globalKey.currentContext.size.height);
                                    print(appbar.currentContext.size.height);
                                    setState(() {
                                      //图片尺寸小于屏幕时
                                      if (Info.globalKey.currentContext.size
                                              .height <
                                          MediaQuery.of(context).size.height) {
                                        WaterInfo.bottom =
                                            MediaQuery.of(context).size.height +
                                                appbar.currentContext.size
                                                    .height -
                                                details.offset.dy -
                                                (MediaQuery.of(context)
                                                            .size
                                                            .height +
                                                        appbar.currentContext
                                                            .size.height -
                                                        Info
                                                            .globalKey
                                                            .currentContext
                                                            .size
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
                                      //强制刷新Widget
                                      WaterInfo.left = details.offset.dx;
                                    });
                                  }
                                },
                                feedback: mark(),
                                child: mark(),
                                //原位置占位
                                childWhenDragging:
                                    Opacity(opacity: 0.5, child: mark()));
                          })),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: ToolInfo.tool ? Bar() : SizedBox(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.themeData,
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
                icon: Icon(Icons.info),
                onPressed: () {
                  // if (Loading.loading == false) {
                  //   //加载框刷新
                  //   setState(() {
                  //     Loading.loading = true;
                  //   });
                  //   //开始保存
                  //   PicUtil.capturePng(Info.globalKey).then((savedFile) {
                  //     print('图片保存成功!导出路径为:$savedFile');
                  //     if (savedFile != null) {
                  //       setState(() {
                  //         Loading.loading = false;
                  //         Toast.show('保存成功', context,
                  //             duration: Toast.LENGTH_LONG,
                  //             gravity: Toast.CENTER);
                  //       });
                  //     } else {
                  //       setState(() {
                  //         Loading.loading = false;
                  //         Toast.show('保存失败', context,
                  //             duration: Toast.LENGTH_LONG,
                  //             gravity: Toast.CENTER);
                  //       });
                  //     }
                  //   });
                  // }
                },
              )
            ],
            title: Text('编辑'),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: ToolInfo.floatbtn
              ? AnimatedFloatingButton(
                  // bgColor: globalModel.isBgChangeWithCard
                  //     ? model.logic.getCurrentCardColor()
                  //     : null,
                  )
              : null,
          body: mainScreen(context)),
    );
  }
}
