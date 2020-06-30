
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget{
  MinePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MinePageState();
}

class MinePageState extends State<MinePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    SafeArea(
        child: Text("main page"))
    );
  }
}
