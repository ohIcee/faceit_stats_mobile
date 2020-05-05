import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/models/CsgoDetails.dart';
import 'package:faceit_stats/models/userDetailArguments.dart';
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
  List<Match> _userMatchHistory;

  double coverImageHeight = 200.0;
  double avatarImageSize = 150.0;
  double coverImageOpacity = .8;
  double secondPageNicknameScale = 0.0;

  bool isSecondPage = false;
  bool matchesLoaded = true;

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

  final pageViewController = PageController(initialPage: 0);
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    pageViewController.addListener(() {
      setState(() {
        currentPageValue = pageViewController.page;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserDetailArguments args = ModalRoute.of(context).settings.arguments;
    _user = args.user;
    _userMatchHistory = args.matchHistory;

    debugPrint(currentPageValue.toString());

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
            topInfo(),
            Expanded(
              child: PageView.builder(
                controller: pageViewController,
                itemBuilder: (context, position) {
                  return position == 0 ? _buildFirstPage() : _buildSecondPage();
                },
                itemCount: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHistory() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      itemCount: _userMatchHistory.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var match = _userMatchHistory[index];
        return Text(match.match_id);
      },
    );
  }

  Widget _buildSecondPage() {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              child: Text(
                "Match History",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 23.0, letterSpacing: .7),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(child: _buildMatchHistory()),
          ],
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Icon(
            Icons.chevron_left,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstPage() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Transform.translate(
              offset: Offset.fromDirection(
                  3, (currentPageValue * 200.0).clamp(0.0, 200.0)),
              child: Text(
                _user.nickname,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 23.0, letterSpacing: .7),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            recentResults(_user.getCsgoDetails().recent_results),
            SizedBox(
              height: 20.0,
            ),
            csgoInfo(),
          ],
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Icon(
            Icons.chevron_right,
          ),
        ),
      ],
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
    return Column(
      children: <Widget>[
        appBar(),
        AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          height: ((1 - currentPageValue) * 200.0).clamp(100.0, 200.0),
          curve: Curves.easeOutCubic,
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  child: Image.network(_user.coverImgLink, fit: BoxFit.cover),
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
                            ((1 - currentPageValue) * 150.0).clamp(80.0, 150.0),
                        curve: Curves.easeOutCubic,
                        child: Image.network(
                          _user.avatarImgLink,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 20.0,
                      ),
                      width: (currentPageValue * 150.0).clamp(0.0, 150.0),
                      child: Opacity(
                        opacity: currentPageValue,
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
      height: 50.0,
      child: Text(
        "FACEIT STATS",
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
