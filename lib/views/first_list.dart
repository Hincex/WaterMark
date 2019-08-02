import 'package:flutter/material.dart';
import '../models/mark.dart';
import '../models/brand.dart';

class FirstList extends StatefulWidget {
  @override
  FirstListState createState() => FirstListState();
}

class FirstListState extends State<FirstList> {
  List _list = [];
  List info = [];
  void initState() {
    super.initState();
    if (Mark.mark[Brand.key] == null) {
      _list.add(Container(
        child: null,
      ));
    } else {
      Mark.mark[Brand.key].forEach((key, value) {
        _list.add(markCard(value, key));
      });
    }
  }

  void dispose() {
    super.dispose();
    _list.clear();
  }

  Widget markCard(Image brand, key) {
    return Card(
        color: Colors.black,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: InkWell(
            child: brand,
            onTap: () {
              Mark.key = key;
              Navigator.of(context).pushNamed("/detail");
            }));
  }

  @override
  Widget build(BuildContext context) {
    info = ModalRoute.of(context).settings.arguments;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(Brand.key),
            elevation: 0,
            leading: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: ListView(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                reverse: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return _list[index];
                },
                itemCount: _list.length,
              )
            ],
          )),
    );
  }
}
