//底部导航插件
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//底部导航目录
import 'models/store/model/index.dart';
import 'views/first.dart';
import 'views/second.dart';
import 'views/third.dart';

class Nav extends StatefulWidget {
  @override
  NavState createState() => NavState();
}

class NavState extends State<Nav> with TickerProviderStateMixin {
  /*默认选中首页*/
  int _currentIndex = 0;
  /*进行跳转的四个页面*/
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;
  void initState() {
    super.initState();

    _pageList = <StatefulWidget>[First(), Second(), Third()];
    _currentPage = _pageList[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPage,
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Provider.of<ThemeChange>(context).color,
          activeIconColor: Colors.white,
          // inactiveIconColor: Colors.black,
          tabs: [
            TabData(iconData: Icons.home, title: "首页"),
            TabData(iconData: Icons.flip_to_front, title: "自定义"),
            TabData(iconData: Icons.settings, title: "设置")
          ],
          onTabChangedListener: (position) {
            setState(() {
              // print(position);
              _currentIndex = position;
              _currentPage = _pageList[position];
            });
          },
        ));
  }
}
