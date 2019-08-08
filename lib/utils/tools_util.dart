import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/user_setting.dart';
import 'package:new_app/views/first_detail.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:provider/provider.dart';
import '../config/provider_config.dart';

//工具信息
class ToolInfo {
  static bool floatbtn = true;
  static bool tool = false;
  static bool toolbar = false;
  static bool size = false;
  static bool position = false;
  static bool change = false;
  static bool slider = false;
  static AnimationController controller;
  static Animation animation;
}

//水印信息
class WaterInfo {
  static double top;
  static double right;
  static double bottom = 10;
  static double left = 10;
  static double step = 5;
}

//图片信息
class PicInfo {
  static double height;
  static double width;
}

class CommonBtn extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function func;
  CommonBtn({@required this.text, this.icon, this.func});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onTap: () {
        func();
        // Provider.of<CommonModel>(context).backUtil();
      },
    ));
  }
}

class SliderBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slider(
        activeColor: Colors.white,
        min: 1,
        max: 100,
        value: WaterInfo.step,
        onChanged: (newValue) {
          Provider.of<CommonModel>(context).sliderVal(newValue);
        },
      ),
    );
  }
}

class ToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: ToolInfo.animation,
        builder: (ctx, child) {
          return Transform.translate(
              offset: Offset(0, -(ToolInfo.animation.value) * 10),
              child: Transform.scale(
                  scale: ToolInfo.animation.value, child: child));
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
                color:
                    Themes.dark ? Colors.grey : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular((15.0))),
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Bar())));
  }
}

class Bar extends StatelessWidget {
  List<Widget> toolbar;

  @override
  Widget build(BuildContext context) {
    if (ToolInfo.toolbar) {
      toolbar = [
        CommonBtn(
            text: '返回',
            icon: Icons.chevron_left,
            func: () {
              Provider.of<CommonModel>(context).backUtil();
            }),
        CommonBtn(
            text: '水印位置',
            icon: Icons.swap_vert,
            func: () {
              Provider.of<CommonModel>(context).posUtil();
            }),
        CommonBtn(
            text: '切换水印',
            icon: Icons.phone_android,
            func: () {
              if (Setting.usrMark != null) {
                CustomSimpleDialog.dialog(
                    context,
                    '自定义水印列表',
                    Info.mark.map((radio) => radio).toList(),
                    Colors.white,
                    Colors.black);
              } else {
                CustomSimpleDialog.dialog(
                    context,
                    '水印列表',
                    Info.mark.map((radio) => radio).toList(),
                    Colors.white,
                    Colors.black);
              }
            }),
        CommonBtn(
            text: '重置修改',
            icon: Icons.refresh,
            func: () {
              Provider.of<CommonModel>(context).resetUtil();
            }),
      ];
    } else if (ToolInfo.position) {
      toolbar = [
        CommonBtn(
            text: '返回',
            icon: Icons.chevron_left,
            func: () {
              Provider.of<CommonModel>(context).backUtil();
            }),
        CommonBtn(
            text: '向上',
            icon: Icons.arrow_upward,
            func: () {
              Provider.of<CommonModel>(context).upUtil();
            }),
        CommonBtn(
            text: '向右',
            icon: Icons.arrow_forward,
            func: () {
              Provider.of<CommonModel>(context).rightUtil();
            }),
        CommonBtn(
            text: '向下',
            icon: Icons.arrow_downward,
            func: () {
              Provider.of<CommonModel>(context).downUtil();
            }),
        CommonBtn(
            text: '向左',
            icon: Icons.arrow_back,
            func: () {
              Provider.of<CommonModel>(context).leftUtil();
            }),
        CommonBtn(
            text: '移动步长',
            icon: Icons.flight,
            func: () {
              Provider.of<CommonModel>(context).sliderUtil();
            }),
      ];
    } else if (ToolInfo.slider) {
      toolbar = [
        CommonBtn(
            text: '返回',
            icon: Icons.chevron_left,
            func: () {
              Provider.of<CommonModel>(context).backUtil();
            }),
        SliderBtn(),
        Text(
          WaterInfo.step.roundToDouble().toString() + 'px',
          style: TextStyle(color: Colors.white),
        )
      ];
    }

    return AnimatedBuilder(
        animation: ToolInfo.animation,
        builder: (ctx, child) {
          return Transform.translate(
              offset: Offset(0, -(ToolInfo.animation.value) * 10),
              child: Transform.scale(
                  scale: ToolInfo.animation.value, child: child));
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
                color:
                    Themes.dark ? Colors.grey : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular((15.0))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: toolbar),
            )));
  }
}
