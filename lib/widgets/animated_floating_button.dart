import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_app/config/floating_border.dart';
import 'package:new_app/config/theme_data.dart';
import '../utils/tools_util.dart';
import 'package:provider/provider.dart';
import '../config/provider_config.dart';

class AnimatedFloatingButton extends StatefulWidget {
  final Color bgColor;

  const AnimatedFloatingButton({Key key, this.bgColor}) : super(key: key);

  @override
  _AnimatedFloatingButtonState createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    ToolInfo.controller.reverse();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, (_animation.value) * 56),
          child: Transform.scale(scale: 1 - _animation.value, child: child),
        );
      },
      child: Transform.rotate(
        angle: -pi / 2,
        child: FloatingActionButton(
          onPressed: () async {
            Provider.of<CommonModel>(context).toolUtil();
            _controller.forward();
            ToolInfo.controller.forward();
          },
          child: Transform.rotate(
            angle: pi / 2,
            child: Icon(
              Icons.arrow_upward,
              size: 25,
              color: Themes.dark ? Colors.white : Colors.white,
            ),
          ),
          backgroundColor:
              Themes.dark ? Colors.grey : Theme.of(context).primaryColor,
          // shape: FloatingBorder(),
        ),
      ),
    );
  }
}
