import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String screenId = 'MainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('HoopHop', style: TextStyle(color: Colors.yellowAccent)),
      ),
    );
  }
}
