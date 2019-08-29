import 'package:flutter/material.dart';
import 'package:new_app/config/provider_config.dart';
import 'package:new_app/config/theme_data.dart';
import 'package:new_app/models/public.dart';
import 'package:new_app/utils/pics_util.dart';
import 'package:new_app/widgets/dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';

class Setting {
  // static double outputQuality;
  static Map outputQuality = {'outputQuality': 7.0, 'outputQualityText': '高'};
  static String outputType = 'JPEG';
  static double speed = 1;
  static List<String> info = [];
  static var db = new DatabaseHelper();
  static String usrMark;

  //获取用户本地个性化设置
  //仅初始化时调用
  static Future getUsrSetting() async {
    List pics;
    pics = await db.getAllUsrs();
    pics.forEach((pic) {
      String img = pic['image'];
      // print(pic);
      Setting.info.add(img.toString());
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    int themeIndex = pref.getInt("localTheme");
    if (themeIndex != null) {
      Themes.themeData = Themes.themes[themeIndex];
      Themes.tempThemeData =
          themeIndex == 0 ? Themes.tempThemeData : Themes.themes[themeIndex];
      Themes.dark = themeIndex == 0 ? true : false;
    } else {
      Themes.themeData = Themes.themes[1];
    }
    double outputQuality = pref.getDouble("outputQuality");
    String outputQualityText = pref.getString("outputQualityText");
    String outputType = pref.getString("outputType");

    double speed = pref.getDouble("speed");
    if (speed != null) {
      Setting.speed = speed;
    } else {
      pref.setDouble('speed', 1.0);
      Setting.speed = 1;
    }
    if (outputQuality != null) {
      Setting.outputQuality['outputQuality'] = outputQuality;
      Setting.outputQuality['outputQualityText'] = outputQualityText;
      Setting.outputType = outputType;
    } else {
      pref.setDouble('outputQuality', 7.0);
      pref.setString('outputQualityText', '高');
      pref.setString('outputType', 'JPEG');
      Setting.outputQuality['quality'] = 7.0;
      Setting.outputType = 'JPGE';
    }
  }

  static Widget usrCard(BuildContext context, String img) {
    return Container(
        height: 100,
        child: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: InkWell(
              child: Image.asset(
                  img.replaceAll("File: ", '').replaceAll('\'', '')),
              onLongPress: () {
                CustomSimpleDialog.alert(context, '确认删除?', '将删除该水印', '删除', '取消',
                    () async {
                  Provider.of<CommonModel>(context).deleteUsr(context, img);
                  await db.deleteUsr(img);
                });
              },
              onTap: () {
                Setting.usrMark = img;
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
              },
            )));
  }
}
