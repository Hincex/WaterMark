import 'package:flutter/material.dart';
import 'package:new_app/config/theme_data.dart';

class Second extends StatefulWidget {
  @override
  SecondState createState() => SecondState();
}

class SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.themeData,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('自定义'),
          centerTitle: true,
        ),
      ),
    );
  }
}
