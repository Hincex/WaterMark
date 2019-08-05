import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_saver/image_picker_saver.dart' hide ImageSource;
import 'package:new_app/models/public.dart';
import 'dart:ui' as ui;

import 'package:new_app/models/user_setting.dart';

class PicUtil {
  //拍照
  static Future takePic() async {
    PublicInfo.img = null;
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      PublicInfo.img = image;
    }
  }

  //获取图库
  static Future getGallery() async {
    PublicInfo.img = null;
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      PublicInfo.img = image;
    }
  }

  //Widget2png
  static Future capturePng(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    //pixelRatio决定导出质量
    ui.Image image = await boundary.toImage(
        pixelRatio: Setting.outputQuality['outputQuality']);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // var codec = await ui.instantiateImageCodec(pngBytes);
    // var frameInfo = await codec.getNextFrame();
    // print(pngBytes);
    //强制刷新Widget
    //保存导出的图片
    var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
    var savedFile = File.fromUri(Uri.file(filePath));
    return savedFile;
  }
}
