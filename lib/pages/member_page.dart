import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {
  MemberPage({Key key}) : super(key: key);

  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("个人中心")));
  }
}
