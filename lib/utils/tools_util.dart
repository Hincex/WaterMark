import 'package:flutter/material.dart';
import 'package:new_app/views/first_detail.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:provider/provider.dart';
import '../config/provider_config.dart';
import 'dart:math';

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

class Tools {
  //通用返回按钮
  static Widget backBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chevron_left, color: Theme.of(context).primaryColor),
            Text(
              '返回',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        // ToolInfo.controller.reverse();
        Provider.of<CommonModel>(context).backUtil();
      },
    ));
  }

  //水印位置按钮
  static Widget posBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.swap_vert, color: Theme.of(context).primaryColor),
            Text(
              '水印位置',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).posUtil();
      },
    ));
  }

  //向上按钮
  static Widget upBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_upward, color: Theme.of(context).primaryColor),
            Text(
              '向上',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).upUtil();
      },
    ));
  }

  //向右按钮
  static Widget rightBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
            Text(
              '向右',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).rightUtil();
      },
    ));
  }

  //向下按钮
  static Widget downBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_downward, color: Theme.of(context).primaryColor),
            Text(
              '向下',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).downUtil();
      },
    ));
  }

  //向左按钮
  static Widget leftBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            Text(
              '向左',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).leftUtil();
      },
    ));
  }

  //移动步长按钮
  static Widget stepBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.flight, color: Theme.of(context).primaryColor),
            Text(
              '步长',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).sliderUtil();
      },
    ));
  }

  //滑块按钮
  static Widget sliderBtn(BuildContext context) {
    return Container(
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        min: 1,
        max: 100,
        value: WaterInfo.step,
        onChanged: (newValue) {
          Provider.of<CommonModel>(context).sliderVal(newValue);
        },
      ),
    );
  }

  //水印位置按钮
  static Widget changeBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.phone_android, color: Theme.of(context).primaryColor),
            Text(
              '切换水印',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        CustomSimpleDialog.dialog(
            context,
            '水印列表',
            Info.mark.map((radio) => radio).toList(),
            Colors.white,
            Colors.black);
      },
    ));
  }

  //重置修改按钮
  static Widget resetBtn(BuildContext context) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.refresh, color: Theme.of(context).primaryColor),
            Text(
              '重置修改',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<CommonModel>(context).resetUtil();
      },
    ));
  }

  static List<Widget> bar(BuildContext context) {
    if (ToolInfo.toolbar) {
      return [
        backBtn(context),
        posBtn(context),
        changeBtn(context),
        resetBtn(context)
      ];
    } else if (ToolInfo.position) {
      return [
        backBtn(context),
        upBtn(context),
        rightBtn(context),
        downBtn(context),
        leftBtn(context),
        stepBtn(context)
      ];
    } else if (ToolInfo.slider) {
      return [
        backBtn(context),
        sliderBtn(context),
        Text(
          WaterInfo.step.roundToDouble().toString() + 'px',
          style: TextStyle(color: Colors.black),
        )
      ];
    }
  }

  static AnimatedBuilder toolbar(BuildContext context) {
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
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular((15.0))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: bar(context),
              ),
            )));
  }
}
