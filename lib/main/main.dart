import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterdemo/main/DrawerBuilder.dart';
import 'package:flutterdemo/module/%E5%8F%91%E7%8E%B0/DiscoveryPage.dart';
import 'package:flutterdemo/module/%E9%A6%96%E9%A1%B5/HomePage.dart';
import 'package:flutterdemo/util/log/logUtil.dart';

import '../module/我的/MinePage.dart';

void main()  {
  LogUtil.init(isDebug: true);
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: MaterialApp(
        title: _title,
        home: MyStatefulWidget(),
        routes: {},
      )
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> pages = <Widget>[];
  
  @override
  void initState() {
    super.initState();
    pages.addAll([HomePage(), DiscoveryPage(), MinePage()]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),

      drawer: new Drawer(
          child: DrawerBuilder.homeDrawer(),
      ),

      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}