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

class _UserDetailPageState extends State<UserDetailPage>
    with TickerProviderStateMixin {
  User _user;

  double coverImageHeight = 200.0;
  double avatarImageSize = 150.0;
  double coverImageOpacity = .8;
  double secondPageNicknameScale = 0.0;

  bool isSecondPage = false;

  void ToSecondPage() {
    setState(() {
      isSecondPage = true;
      coverImageHeight = 100.0;
      avatarImageSize = 80.0;
      coverImageOpacity = .35;
      secondPageNicknameScale = 1.0;
    });
  }

  void ToFirstPage() {
    setState(() {
      isSecondPage = false;
      coverImageHeight = 200.0;
      avatarImageSize = 150.0;
      coverImageOpacity = .8;
      secondPageNicknameScale = 0.0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;

    var csgoDetails = _user.getCsgoDetails();
    var stats = <Widget>[
      stat(csgoDetails.match_count, "Matches"),
      stat(csgoDetails.win_rate, "Win rate %"),
      stat(csgoDetails.longest_win_streak, "Longest Win Streak"),
      stat(csgoDetails.average_kd, "Average K/D Ratio"),
      stat(csgoDetails.avg_headshot, "Average Headshots %"),
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 22, 22, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            appBar(),
            topInfo(),
            SizedBox(
              height: 20.0,
            ),
            isSecondPage
                ? Container()
                : Text(
                    _user.nickname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        letterSpacing: .7),
                  ),
            isSecondPage
                ? Container()
                : SizedBox(
                    height: 20.0,
                  ),
            recentResults(_user.getCsgoDetails().recent_results),
            SizedBox(
              height: 20.0,
            ),
            csgoInfo(),
            isSecondPage
                ? IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      ToFirstPage();
                    },
                  )
                : Container(),
            !isSecondPage
                ? Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    width: 170.0,
                    child: RaisedButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      onPressed: () {
                        ToSecondPage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.history,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "Match history",
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
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

    return SizedBox(
      child: Container(
        child: Column(
          children: stats,
        ),
      ),
    );
  }

  Widget stat(dynamic value, String title) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 10.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
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
                color: result == "1"
                    ? Color.fromRGBO(0, 209, 21, 1)
                    : Color.fromRGBO(212, 0, 0, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        list.add(
          SizedBox(
            width: 5.0,
          ),
        );
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget topInfo() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: coverImageHeight,
      curve: Curves.easeOutCubic,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              child: Image.network(_user.coverImgLink, fit: BoxFit.cover),
              opacity: coverImageOpacity,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    height: avatarImageSize,
                    curve: Curves.easeOutCubic,
                    child: Image.network(
                      _user.avatarImgLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                isSecondPage
                    ? SizedBox(
                        width: 20.0,
                      )
                    : Container(),
                isSecondPage
                    ? Text(
                        _user.nickname,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.0,
                          letterSpacing: .7,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
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
      color: Color.fromRGBO(255, 85, 0, 1),
      alignment: Alignment.center,
      height: 75.0,
      child: Text(
        "FACEIT STATS",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
