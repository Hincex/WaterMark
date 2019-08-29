import 'package:flutter/material.dart';
import 'brand.dart';

class Mark {
  static Map mark = {
    "华为": {
      0: {
        'title': 'mate20x',
        'pics': Image.asset(
          'public/mark/mate20x.png',
        ),
      },
      1: {
        'title': 'mate20pro',
        'pics': Image.asset(
          'public/mark/mate20pro.png',
        ),
      },
      3: {
        'title': 'p30pro',
        'pics': Image.asset(
          'public/mark/p30pro.png',
        ),
      }
    },
    "荣耀": {
      0: {
        'title': 'honor10',
        'pics': Image.asset(
          'public/mark/honor10.png',
        ),
      }
    },
    "苹果": {
      0: {
        'title': 'iphone XR',
        'pics': Image.asset(
          'public/mark/ipxr.png',
        ),
      }
    },
    "三星": {
      0: {
        'title': 'samsung s10',
        'pics': Image.asset(
          'public/mark/samsungs10.png',
        ),
      }
    },
    "一本道": {
      0: {
        'title': 'samsung s10',
        'pics': Image.asset(
          'public/mark/1pondo.png',
        ),
      }
    },
    "小米": {
      0: {
        'title': 'mi8UD',
        'pics': Image.asset(
          'public/mark/mi8UD.png',
        ),
      }
    }
  };

  //水印列表
  static Widget markRatio(int key, Function func) {
    return ListTile(
      // title: Text(Mark.mark[Brand.key][key]['title']),
      title: Center(
        child: Mark.mark[Brand.key][key]['pics'],
      ),
      onTap: () {
        func(key);
      },
    );
  }

  //自定义水印列表
  static Widget usrMarkRatio(String img, Function func) {
    return ListTile(
      // title: Text(Mark.mark[Brand.key][key]['title']),
      title: Center(
        child: Image.asset(img.replaceAll("File: ", '').replaceAll('\'', ''),
            width: 200),
      ),
      onTap: () {
        func(key);
      },
    );
  }

  static dynamic key = 0;
}
