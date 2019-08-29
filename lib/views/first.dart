import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/public.dart';
import 'package:new_app/utils/pics_util.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:toast/toast.dart';
import '../models/brand.dart';
import 'package:flutter/animation.dart';

bool isGrid = false;

class First extends StatefulWidget {
  @override
  FirstState createState() => FirstState();
}

class FirstState extends State<First> with TickerProviderStateMixin {
  //品牌列表
  List _list = [];
  List _grid = [];
  IconData _actionIcon = Icons.menu;
  @override
  void initState() {
    //遍历品牌列表
    Brand.brand.forEach((key, value) {
      _list.add(list(value, key));
      _grid.add(grid(value, key));
    });

    super.initState();
  }

  @override
  void dispose() {
    //销毁后清空品牌列表
    _list.clear();
    _grid.clear();
    super.dispose();
  }

  // Widget brandCard() {
  //   return isGrid
  //       ? GridView.builder(
  //           shrinkWrap: true,
  //           primary: false,
  //           reverse: false,
  //           scrollDirection: Axis.vertical,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3, //每行三列
  //               // crossAxisSpacing: 10.0, // 横向间距
  //               childAspectRatio: 1),
  //           itemBuilder: (BuildContext context, int index) {
  //             return _grid[index];
  //           },
  //           itemCount: _grid.length,
  //         )
  //       : ListView.builder(
  //           shrinkWrap: true,
  //           primary: false,
  //           reverse: false,
  //           scrollDirection: Axis.vertical,
  //           itemBuilder: (BuildContext context, int index) {
  //             return _list[index];
  //           },
  //           itemCount: _list.length,
  //         );
  // }

  Widget card(Image brand, key, bool grid) {
    return InkWell(
        child: grid
            ? Center(
                child: Text(key),
              )
            : brand,
        onTap: () {
          Brand.key = key;
          CustomSimpleDialog.dialog(context, '选择图片', [
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
                  Navigator.of(context).pushNamed("/detail");
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
                  Navigator.of(context).pushNamed("/detail");
                }
              },
            )
          ]);
        });
  }

  Widget grid(Image brand, key) {
    return Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: card(brand, key, true));
  }

  //品牌列表卡片
  Widget list(Image brand, key) {
    return Card(
        clipBehavior: Clip.hardEdge,
        // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: card(brand, key, false));
  }

  //主界面构造
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.themeData,
      home: Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   title: Text('水印库'),
          //   elevation: 0,
          //   actions: <Widget>[
          //     IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {},
          //     )
          //   ],
          //   leading: AnimatedSwitcher(
          //     duration: Duration(milliseconds: 300),
          //     transitionBuilder: (Widget child, Animation<double> animation) {
          //       return ScaleTransition(child: child, scale: animation);
          //     },
          //     child: IconButton(
          //       key: ValueKey(_actionIcon),
          //       highlightColor: Colors.transparent,
          //       splashColor: Colors.transparent,
          //       icon: Icon(_actionIcon),
          //       onPressed: () {
          //         setState(() {
          //           isGrid = !isGrid;
          //           isGrid
          //               ? _actionIcon = Icons.apps
          //               : _actionIcon = Icons.menu;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: IconButton(
                key: ValueKey(_actionIcon),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(_actionIcon),
                onPressed: () {
                  setState(() {
                    isGrid = !isGrid;
                    isGrid
                        ? _actionIcon = Icons.apps
                        : _actionIcon = Icons.menu;
                  });
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Toast.show('暂未开放搜索功能', context);
                },
              )
            ], //右侧的内容和点击事件啥的
            //左侧按钮
            /**
             * 如果没有leading，automaticallyImplyLeading为true，就会默认返回箭头
             * 如果 没有leading 且为false，空间留给title
             * 如果有leading，这个参数就无效了
             */
            automaticallyImplyLeading: true,
            centerTitle: true, //标题是否居中
            elevation: 0, //阴影的高度
            forceElevated: false, //是否显示阴影
            backgroundColor: Themes.themeData.primaryColor, //背景颜色
            brightness: Brightness.dark, //黑底白字，lignt 白底黑字
            iconTheme: IconThemeData(
                color: Colors.white,
                size: 30,
                opacity: 1), //所有的icon的样式,不仅仅是左侧的，右侧的也会改变
            textTheme: TextTheme(), //字体样式
            primary: true, // appbar是否显示在屏幕的最上面，为false是显示在最上面，为true就显示在状态栏的下面
            titleSpacing: 16, //标题两边的空白区域
            // expandedHeight: 200.0, //默认高度是状态栏和导航栏的高度，如果有滚动视差的话，要大于前两者的高度
            floating: true, //滑动到最上面，再滑动是否隐藏导航栏的文字和标题等的具体内容，为true是隐藏，为false是不隐藏
            pinned: false, //是否固定导航栏，为true是固定，为false是不固定，往上滑，导航栏可以隐藏
            snap:
                false, //只跟floating相对应，如果为true，floating必须为true，也就是向下滑动一点儿，整个大背景就会动画显示全部，网上滑动整个导航栏的内容就会消失
            flexibleSpace: FlexibleSpaceBar(
              title: Text("水印库"),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
            ),
          ),
          isGrid
              ? SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, //每行三列
                      // crossAxisSpacing: 10.0, // 横向间距
                      childAspectRatio: 1),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _grid[index];
                  }, childCount: _grid.length))
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                  return isGrid ? _grid[index] : _list[index];
                }, childCount: _list.length))
        ],
      )),
      // body: ListView(
      //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      //   children: <Widget>[
      //     //生成列表
      //     brandCard()
      //   ],
      // )),
    );
  }
}
