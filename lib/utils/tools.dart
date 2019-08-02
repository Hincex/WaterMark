import 'package:flutter/material.dart';

class Tools {
  //通用返回按钮
  static Widget backBtn(Function func) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chevron_left, color: Colors.white),
            Text(
              '返回',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onTap: () {
        func();
      },
    ));
  }

  //水印位置按钮
  static Widget positionBtn(Function func) {
    return Container(
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.swap_vert, color: Colors.white),
            Text(
              '水印位置',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onTap: () {
        func();
      },
    ));
  }

  //向上
  static Widget upBtn(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_upward, color: Colors.white),
                Text(
                  '向上',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //向下
  static Widget downBtn(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_downward, color: Colors.white),
                Text(
                  '向下',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //向左
  static Widget leftBtn(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_back, color: Colors.white),
                Text(
                  '向左',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //向右
  static Widget rightBtn(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_forward, color: Colors.white),
                Text(
                  '向右',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //向右
  static Widget speedBtn(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.sort, color: Colors.white),
                Text(
                  '移动步长',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //图片尺寸按钮
  static Widget picSize(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.collections, color: Colors.white),
                Text(
                  '图片尺寸',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //图片尺寸按钮
  static Widget adjustSize(Function func) {
    return Container(
        // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
      child: Container(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//              Icon(Icons.collections, color: Colors.white),
//              Text(
//                '图片尺寸',
//                style: TextStyle(color: Colors.white),
//              ),
            Slider(
              value: 0,
              onChanged: (value) {
                print(value);
              },
            )
          ],
        ),
      ),
      onTap: () {
        func();
      },
    ));
  }

  //重置修改按钮
  static Widget resetPic(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.refresh, color: Colors.white),
                Text(
                  '重置修改',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }

  //切换水印按钮
  static Widget changeMark(Function func) {
    return Container(
        child: InkWell(
          child: Container(
            height: 70,
            child: Column(
              children: <Widget>[
                Icon(Icons.phone_android, color: Colors.white),
                Text(
                  '切换水印',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          onTap: () {
            func();
          },
        ));
  }
}
