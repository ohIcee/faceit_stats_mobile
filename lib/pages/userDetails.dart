import 'package:faceit_stats/models/CsgoDetails.dart';
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
      appBar: AppBar(
        title: Text("Faceit Stats"),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //appBar(),
            topInfo(),
            SizedBox(
              height: 40.0,
            ),
            csgoInfo(),
          ],
        ),
      ),
    );
  }

  Widget csgoInfo() {
    CsgoDetails csgoDetails = _user.getCsgoDetails();

    var stats = <Widget>[
      stat(csgoDetails.match_count, "Matches"),
      stat(csgoDetails.win_rate, "Win rate %"),
      stat(csgoDetails.longest_win_streak, "Longest Win Streak"),
      stat(csgoDetails.average_kd, "Average K/D Ratio"),
      stat(csgoDetails.avg_headshot, "Average Headshots %"),
    ];

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 100.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: stats.length,
              padding: EdgeInsets.only(left: 25.0, right: 10.0),
              itemBuilder: (ctx, ind) {
                return stats[ind];
              },
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          recentResults(csgoDetails.recent_results),
        ],
      ),
    );
  }

  Widget recentResults(List<dynamic> results) {
    var list = new List<Widget>();
    list.add(
      Text(
        "Recent Results",
        style: TextStyle(
          color: Colors.white70,
        ),
      ),
    );
    list.add(
      SizedBox(
        width: 10.0,
      ),
    );
    results.forEach((result) {
      if (result != null) {
        list.add(
          AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.bounceIn,
            child: new Text(
              result == "1" ? "W" : "L",
              style: TextStyle(
                fontSize: 17.0,
                color: result == "1" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        list.add(
          SizedBox(
            width: 4.0,
          ),
        );
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget stat(String stat, String category) {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      margin: EdgeInsets.only(
        right: 20.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              stat,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            Text(
              category.toUpperCase(),
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
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
            height: 125.0,
            width: 125.0,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 40.0,
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
