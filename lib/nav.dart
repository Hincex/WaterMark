//底部导航插件
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//底部导航目录
import 'config/provider_config.dart';
import 'views/first.dart';
import 'views/second.dart';
import 'views/third.dart';

class Nav extends StatefulWidget {
  @override
  NavState createState() => NavState();
}

class NavState extends State<Nav> with TickerProviderStateMixin {
  /*默认选中首页*/
  int _currentIndex;
  /*进行跳转的四个页面*/
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageList = <StatefulWidget>[First(), Second(), Third()];
    _currentPage = _pageList[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPage,
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: Provider.of<CommonModel>(context).color,
          activeIconColor: Colors.white,
          tabs: [
            TabData(iconData: Icons.home, title: "首页"),
            TabData(iconData: Icons.flip_to_front, title: "自定义"),
            TabData(iconData: Icons.settings, title: "设置")
          ],
          onTabChangedListener: (index) {
            setState(() {
              _currentIndex = index;
              _currentPage = _pageList[index];
            });
          },
        ));
  }
}
