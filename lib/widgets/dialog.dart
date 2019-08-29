import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';

class CustomSimpleDialog {
  static dialog(BuildContext context, String title, List<Widget> widget,
      [Color textcolor, Color bgcolor]) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: bgcolor != null
              ? bgcolor
              : Themes.dark ? ThemeData.dark().backgroundColor : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(title,
              style: textcolor != null ? TextStyle(color: textcolor) : null),
          children: widget,
        );
      },
    );
  }

  static alert(BuildContext context, String title, String content, String ok,
      String cancel,
      [Function func, Color bgcolor, Color textcolor]) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                backgroundColor: bgcolor != null
                    ? bgcolor
                    : Themes.dark
                        ? ThemeData.dark().backgroundColor
                        : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Text(title,
                    style:
                        textcolor != null ? TextStyle(color: textcolor) : null),
                content: Text(content,
                    style:
                        textcolor != null ? TextStyle(color: textcolor) : null),
                actions: <Widget>[
                  FlatButton(
                    child: Text(cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      ok,
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      if (func() != null) func();
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }
}
