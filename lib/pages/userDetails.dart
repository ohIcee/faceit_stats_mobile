import 'package:flutter/material.dart';

import '../models/user.dart';

class UserDetailPage extends StatefulWidget {
  static const routeName = '/userDetails';

  UserDetailPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  User _user;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          appBar(),
          topInfo(),
          SizedBox(
            height: 40.0,
          ),
          csgoInfo(),
        ],
      )),
    );
  }

  Widget csgoInfo() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "CS:GO",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Text("Rank ${_user.getGameDetails("csgo").skill_level} (${_user.getGameDetails("csgo").faceit_elo})"),
                  ),
                ),
              ),
              SizedBox(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Text("${_user.getGameDetails("csgo").region} region"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget topInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipOval(
          child: Image.network(
            _user.avatarImgLink,
            height: 150.0,
            width: 150.0,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _user.nickname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.asset(
              'icons/flags/png/${_user.country}.png',
              package: 'country_icons',
              scale: 2,
            ),
          ],
        ),
      ],
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
