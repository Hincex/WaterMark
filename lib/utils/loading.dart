import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  static bool loading;
  Widget child;
  String loadingText;
  bool isloading;
  Loading({this.child, this.loadingText, this.isloading});
  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Stack(
        children: <Widget>[
          child,
          Opacity(
              opacity: 0.8,
              child: ModalBarrier(
                color: Colors.black87,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitWave(
                color: Colors.white,
                size: 50,
                type: SpinKitWaveType.center,
              ),
              Text(
                loadingText,
                style: TextStyle(color: Colors.white),
              )
            ],
          )
        ],
      );
    } else {
      return child;
    }
  }
}
