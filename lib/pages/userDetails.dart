import 'dart:math';

import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/helpers/Rank.dart';
import 'package:faceit_stats/models/Faction.dart';
import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/models/CsgoDetails.dart';
import 'package:faceit_stats/models/user.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:time_formatter/time_formatter.dart';

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
  bool isLoadingMatches = false;

  final pageViewController = PageController(initialPage: 0);
  final matchHistoryListKey = PageStorageKey('MatchHistoryList');
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
    _user = null;
    pageViewController.dispose();
  }

  var series;

  @override
  Widget build(BuildContext context) {
    User args_user = ModalRoute.of(context).settings.arguments;
    _user = args_user;

    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 22, 22, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            topInfo(),
            Expanded(
              child: PageView.builder(
                key: matchHistoryListKey,
                controller: pageViewController,
                itemBuilder: (context, position) {
                  return position == 0
                      ? _buildUserDetailsPage()
                      : _buildMatchHistoryPage();
                },
                itemCount: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHistoryLoader() {
    return isLoadingMatches
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text("Loading...")
            ],
          )
        : MatchHistory.lastAPIResponse != API_RESPONSES.NO_MORE_MATCHES
            ? RaisedButton(
                onPressed: () => loadNextMatchHistory(20),
                child: Text(
                  "Load more...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text("No more matches to retrieve...");
  }

  Widget _buildMatchHistory() {
    // TODO ANIMATED LIST VIEW
    // animate list items into view on load
    return ListView.builder(
      key: matchHistoryListKey,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      itemCount: MatchHistory.loadedMatches.length + 1,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == MatchHistory.loadedMatches.length) {
          return Container(
            height: 50.0,
            margin: EdgeInsets.only(
              bottom: 20.0,
            ),
            child: _buildMatchHistoryLoader(),
          );
        } else {
          var match = MatchHistory.loadedMatches[index];
          return _buildMatchHistoryCard(match);
        }
      },
    );
  }

  void loadNextMatchHistory(int num) async {
    setState(() => isLoadingMatches = true);
    await MatchHistory.LoadNext(num);
    setState(() => isLoadingMatches = false);
  }

  Widget _buildMatchHistoryCard(Match match) {
    Faction userFaction;
    match.factions.forEach((faction) {
      faction.players.forEach((player) {
        if (userFaction != null) return;
        if (player.player_id == _user.userID) userFaction = faction;
      });
    });

    return Container(
      width: double.infinity,
      height: 120.0,
      color: Colors.white10.withOpacity(.05),
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 120.0,
              child: Image.asset(
                'assets/map_images/${match.map}.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          match.map.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                        Text(
                          match.game_mode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "SCORE ${match.score}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: "faction${userFaction.faction_num}" ==
                                match.winning_faction
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Text(
                      formatTime(match.finished_at * 1000),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHistoryPage() {
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
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    letterSpacing: .7),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(child: _buildMatchHistory()),
          ],
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Icon(
            Icons.chevron_left,
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetailsPage() {
    var currentELO = _user.getCsgoDetails().faceit_elo;
    var rank = Rank.eloToRank(currentELO);
    var neededELO = rank.neededELO;
    var maxELO = rank.maxELO;

    int currentGraphELOValue =
        (((currentELO - neededELO) * 100) / (maxELO - neededELO)).round();
    if (currentELO > 2000)
      currentGraphELOValue =
          100; // Fixes graph if player is > 2000 ELO (rank 10)

    int difference = 100 - currentGraphELOValue;

    var data = [
      new ELO('progress', currentGraphELOValue, rank.color),
      new ELO('missing', difference, Colors.white10.withOpacity(.1)),
    ];

    series = [
      new charts.Series(
        id: 'ELO',
        domainFn: (ELO clickData, _) => clickData.rank,
        measureFn: (ELO clickData, _) => clickData.playerELO,
        colorFn: (ELO clickData, _) => clickData.color,
        data: data,
      )
    ];

    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.only(
            bottom: 20.0,
          ),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Transform.translate(
              offset: Offset.fromDirection(
                  3, (currentPageValue * 200.0).clamp(0.0, 200.0)),
              child: Text(
                _user.nickname,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    letterSpacing: .7),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            recentResults(_user.getCsgoDetails().recent_results),
            SizedBox(
              height: 20.0,
            ),
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  child: charts.PieChart(
                    series,
                    animate: false,
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 30,
                        strokeWidthPx: 0.0,
                        startAngle: 4 / 5 * pi,
                        arcLength: 7 / 5 * pi),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 130,
                  child: Text(
                    neededELO.toString(),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          currentELO.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "Rank ${rank.rank}",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 130,
                  child: Text(
                    currentELO > 2000 ? "2001+" : maxELO.toString(),
                  ),
                ),
              ],
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
      stat(csgoDetails.current_win_streak, "Current Win Streak"),
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

class ELO {
  final String rank;
  final int playerELO;
  final charts.Color color;
  final strokeWidth = 0.0;

  ELO(this.rank, this.playerELO, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
