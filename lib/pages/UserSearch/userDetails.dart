import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/models/KDHistory.dart';
import 'package:faceit_stats/models/user.dart';
import 'package:faceit_stats/pages/UserSearch/UserDetailsTab.dart';
import 'package:faceit_stats/pages/UserSearch/UserMapStatsTab.dart';
import 'package:faceit_stats/pages/UserSearch/UserMatchHistoryTab.dart';
import 'package:faceit_stats/appBar.dart';

import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  static const routeName = '/userDetails';

  UserDetailPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with TickerProviderStateMixin {
  User _user;

  final pageViewController = PageController(initialPage: 0);
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _user = MatchHistory.currentUser;
    pageViewController.addListener(() {
      setState(() {
        currentPageValue = pageViewController.page;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _user = null;
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 22, 22, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            topInfo(),
            Expanded(
              child: PageView(
                controller: pageViewController,
                children: <Widget>[
                  UserDetailsTab(currentPageValue),
                  UserMatchHistoryTab(),
                  UserMapStatsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topInfo() {
    return Column(
      children: <Widget>[
        CustomAppBar(backButton: true),
        AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          height: ((1 - currentPageValue) * 200.0).clamp(100.0, 165.0),
          curve: Curves.easeOutCubic,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  child: Image.network(
                    _user.coverImgLink,
                    fit: BoxFit.cover,
                  ),
                  opacity: (1 - currentPageValue).clamp(.35, .8),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 700),
                        height:
                            ((1 - currentPageValue) * 150.0).clamp(80.0, 130.0),
                        width:
                            ((1 - currentPageValue) * 150.0).clamp(80.0, 130.0),
                        curve: Curves.easeOutCubic,
                        child: Image.network(
                          _user.avatarImgLink,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20.0,
                      ),
                      width: (currentPageValue * 150.0).clamp(0.0, 150.0),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: currentPageValue.clamp(0.0, 1.0),
                        child: Text(
                          _user.nickname,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23.0,
                            letterSpacing: .7,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
