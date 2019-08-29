import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as Img;
import 'package:image/src/exif_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_saver/image_picker_saver.dart' hide ImageSource;
import 'package:new_app/models/public.dart';
import 'dart:ui' as ui;
import 'package:new_app/models/user_setting.dart';
import 'package:exif/exif.dart';
import 'package:new_app/utils/tools_util.dart';
import 'package:toast/toast.dart';

class PicUtil {
  static var tt;
  static Map picInfo = {};
  static Future<String> getExifFromFile(File _image) async {
    if (_image == null) {
      return null;
    }

    var bytes = await _image.readAsBytes();
    var tags = await readExifFromBytes(bytes);
    tt = tags;
    var sb = StringBuffer();
    tags.forEach((k, v) {
      sb.write("$k: $v \n");
      PicUtil.picInfo[k] = v;
    });
    print(sb.toString());
    return sb.toString();
  }

  //拍照
  static Future takePic() async {
    PublicInfo.img = null;
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      PublicInfo.img = image;
      List _imageData = PublicInfo.img.readAsBytesSync();
      Img.Image temp = Img.decodeImage(_imageData);
      PicInfo.width = temp.width.toDouble();
      PicInfo.height = temp.height.toDouble();
    }
  }

  //获取图库
  static Future getGallery() async {
    PublicInfo.img = null;
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      PublicInfo.img = image;
      List _imageData = PublicInfo.img.readAsBytesSync();
      Img.Image temp = Img.decodeImage(_imageData);
      print(temp.exif);
      PicInfo.width = temp.width.toDouble();
      PicInfo.height = temp.height.toDouble();
      // getExifFromFile(image);
    }
  }

  static outputType(decodeImg) {
    if (Setting.outputType == 'JPEG') {
      return Img.encodeJpg(decodeImg);
    } else if (Setting.outputType == 'PNG') {
      return Img.encodePng(decodeImg,
          level: Setting.outputQuality['outputQuality'].toInt());
    } else if (Setting.outputType == 'TGA') {
      return Img.encodeTga(decodeImg);
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
    List bytes = await PublicInfo.img.readAsBytes();
    // 进行图片编码处理
    // var temp = Img.decodeJpg(bytes);
    var decodeImg = Img.decodeImage(pngBytes);
    // decodeImg.exif = temp.exif;
    // 导出格式
    var encodeImg = outputType(decodeImg);
    // var codec = await ui.instantiateImageCodec(pngBytes);
    // var frameInfo = await codec.getNextFrame();
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path; // 应用文件夹
    // final imageFile = File(path.join(appDocPath,
    //     '${DateTime.now().toString().replaceAll(' ', '').replaceAll('-', '')}.png')); // 保存在应用文件夹内
    // return await imageFile.writeAsBytes(pngBytes);
    //保存导出的图片
    var filePath = await ImagePickerSaver.saveFile(fileData: encodeImg);
    var savedFile = File.fromUri(Uri.file(filePath));

    return savedFile;
  }
}
