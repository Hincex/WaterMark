import 'package:new_app/config/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  // static double outputQuality;
  static Map outputQuality = {'outputQuality': 7.0, 'outputQualityText': '高'};
  static double speed = 1;
  //获取用户本地个性化设置
  static Future getUsrSetting() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int themeIndex = pref.getInt("localTheme");
    if (themeIndex != null) {
      Themes.themeData = Themes.themes[themeIndex];
      Themes.tempThemeData = Themes.themes[themeIndex];
      return themeIndex;
    } else {
      Themes.themeData = Themes.themes[1];
    }
    double outputQuality = pref.getDouble("outputQuality");
    String outputQualityText = pref.getString("outputQualityText");
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
    } else {
      pref.setDouble('outputQuality', 7.0);
      pref.setString('outputQualityText', '高');
      Setting.outputQuality['quality'] = 7.0;
    }
  }
}
