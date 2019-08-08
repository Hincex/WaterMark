import 'dart:typed_data';

class Usr {
  int _id;
  String _image;
  double _pointLng;
  double _pointLat;

  Usr(this._image, this._pointLng, this._pointLat);

  Usr.map(dynamic obj) {
    this._id = obj['id'];
    this._image = obj['image'];
    this._pointLng = obj['pointLng'];
    this._pointLat = obj['pointLat'];
  }

  int get id => _id;
  String get image => _image;
  double get pointLng => _pointLng;
  double get pointLat => _pointLat;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['image'] = _image;
    map['pointLng'] = _pointLng;
    map['pointLat'] = _pointLat;
    return map;
  }

  Usr.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._image = map['image'];
    this._pointLng = map['pointLng'];
    this._pointLat = map['pointLat'];
  }
}
