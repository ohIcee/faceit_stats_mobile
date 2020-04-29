import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  UserDetailPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: <Widget>[
              appBar(),
            ],
          )),
    );
  }

  Widget appBar() {
    return Container(
      alignment: Alignment.center,
      height: 75.0,
      child: Text(
        "Faceit Stats",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
