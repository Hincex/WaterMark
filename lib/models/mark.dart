import 'dart:ui';
import 'package:flutter/material.dart';
import 'brand.dart';

class Mark {
  static Map mark = {
    "Huawei": {
      0: {
        'title': 'mate20x',
        'pics': Image.asset(
          'public/mark/mate20x.png',
          width: 200,
        ),
      },
      1: {
        'title': 'mate20pro',
        'pics': Image.asset(
          'public/mark/mate20pro.png',
          width: 200,
        ),
      },
      3: {
        'title': 'p30pro',
        'pics': Image.asset(
          'public/mark/p30pro.png',
          width: 200,
        ),
      }
    },
    "Honor": {
      0: {
        'title': 'honor10',
        'pics': Image.asset(
          'public/mark/honor10.png',
          width: 200,
        ),
      }
    },
    "Xiaomi": {
      0: {
        'title': 'mi8UD',
        'pics': Image.asset(
          'public/mark/mi8UD.png',
          width: 200,
        ),
      }
    }
  };
  static List _tools = [
    Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(color: Colors.black),
    )
  ];
  static Widget markRatio(int key, Function func) {
    return ListTile(
      title: Center(
        child: Text(Mark.mark[Brand.key][key]['title']),
      ),
      onTap: () {
        func(key);
      },
    );
  }

  static dynamic key = 0;
}
