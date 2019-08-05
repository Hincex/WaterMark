import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';

class CustomSimpleDialog {
  static dialog(BuildContext context, List<Widget> widget) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor:
              Themes.dark ? ThemeData.dark().backgroundColor : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          children: widget,
        );
      },
    );
  }
}
