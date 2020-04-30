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
            SizedBox(
              height: 20.0,
            ),
            //appBar(),
            topInfo(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: RaisedButton(
                child: Text("More info"),
                onPressed: () {},
                color: Colors.transparent,
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
              ),
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
    var rank = _user.getCsgoDetails().skill_level;
    rank = 8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: 40.0,
            ),
            child: Column(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    _user.avatarImgLink,
                    height: 110.0,
                    width: 110.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 40.0,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _user.nickname,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("country"),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                      ),
                      width: 40.0,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Text(
                        _user.country,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("rank"),
                    Container(
                      width: 40.0,
                      decoration: BoxDecoration(
                          color:
                              getRankColor(rank)),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Text(
                        rank.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color getRankColor(int rank) {
    if (rank == 1)
      return Colors.white70;
    else if (rank == 2 || rank == 3)
      return Colors.green;
    else if (rank >= 4 && rank <= 7)
      return Colors.yellow;
    else if (rank == 8 || rank == 9)
      return Colors.deepOrange;
    else if (rank == 10) return Colors.red;
    return null;
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
