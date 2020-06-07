import 'dart:math';

import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/helpers/FavouritesManager.dart';
import 'package:faceit_stats/helpers/Rank.dart';
import 'package:faceit_stats/models/CsgoDetails.dart';
import 'package:faceit_stats/models/KDHistory.dart';
import 'package:faceit_stats/models/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailsTab extends StatefulWidget {
  final currentPageValue;

  UserDetailsTab(this.currentPageValue, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserDetailsTabState();
}

class UserDetailsTabState extends State<UserDetailsTab> {
  User _user;
  var currentPageValue;
  bool isFavourited = false;
  var chartAnimationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    _user = MatchHistory.currentUser;
    setState(() {
      isFavourited = FavouritesManager.favouriteExists(_user.nickname);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentPageValue = widget.currentPageValue;

    return _buildUserDetails();
  }

  Widget _buildUserDetails() {
    var currentELO = _user.getCsgoDetails.faceit_elo;
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

    var series = [
      new charts.Series(
        id: 'ELO',
        domainFn: (ELO clickData, _) => clickData.rank,
        measureFn: (ELO clickData, _) => clickData.playerELO,
        colorFn: (ELO clickData, _) => clickData.color,
        data: data,
      )
    ];

    List<Color> gradientColors = [
      Colors.deepOrange,
      Colors.orangeAccent,
    ];
    List<FlSpot> KDFlSpots = new List<FlSpot>();
    KDHistory.kdr.reversed.toList().asMap().forEach((index, value) {
      KDFlSpots.add(FlSpot(index.toDouble(), value));
    });

    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.only(
            bottom: 20.0,
          ),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 20.0),
            Transform.translate(
              offset: Offset.fromDirection(
                  3, (currentPageValue * 200.0).clamp(0.0, 200.0)),
              child: ShowUpAnimation(
                animationDuration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                direction: Direction.vertical,
                offset: 0.5,
                child: Text(
                  _user.nickname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      letterSpacing: .7),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ShowUpAnimation(
              delayStart: Duration(milliseconds: 100),
              animationDuration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              direction: Direction.vertical,
              offset: 0.5,
              child: recentResults(_user.getCsgoDetails.recent_results),
            ),
            SizedBox(height: 20.0),
            ShowUpAnimation(
              delayStart: Duration(milliseconds: 100),
              animationDuration: Duration(milliseconds: 800),
              curve: Curves.fastOutSlowIn,
              direction: Direction.vertical,
              offset: 0.5,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 200.0,
                    child: charts.PieChart(
                      series,
                      animate: false,
                      animationDuration: chartAnimationDuration,
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 30,
                        strokeWidthPx: 0.0,
                        startAngle: 4 / 5 * pi,
                        arcLength: 7 / 5 * pi,
                      ),
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
            ),
            SizedBox(height: 20.0),

            // If there is no entries in KDHistory, don't
            // show the graph
            ShowUpAnimation(
              delayStart: Duration(milliseconds: 250),
              animationDuration: Duration(milliseconds: 800),
              curve: Curves.fastOutSlowIn,
              direction: Direction.vertical,
              offset: 0.5,
              child: KDHistory.kdr.length > 0
                  ? Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            "K/D History - Last ${KDHistory.maxNumMatches} matches",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          height: 150.0,
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  showTitles: false,
                                ),
                                leftTitles: SideTitles(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  showTitles: true,
                                ),
                              ),
                              gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  drawHorizontalLine: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.deepOrange,
                                      strokeWidth: 2.0,
                                    );
                                  }),
                              lineBarsData: <LineChartBarData>[
                                LineChartBarData(
                                    isCurved: true,
                                    isStrokeCapRound: true,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map(
                                              (color) => color.withOpacity(0.3))
                                          .toList(),
                                    ),
                                    spots: KDFlSpots),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        "Not enough data for K/D History",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            SizedBox(height: 40.0),
            ShowUpAnimation(
              delayStart: Duration(milliseconds: 250),
              animationDuration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              direction: Direction.vertical,
              offset: 0.5,
              child: csgoInfo(),
            ),
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
    CsgoDetails csgoDetails = _user.getCsgoDetails;

    var stats = <Widget>[
      stat(csgoDetails.match_count, "Matches"),
      stat(csgoDetails.win_rate, "Win rate %"),
      stat(csgoDetails.longest_win_streak, "Longest Win Streak"),
      stat(csgoDetails.current_win_streak, "Current Win Streak"),
      stat(csgoDetails.average_kd, "Average K/D Ratio"),
      stat(csgoDetails.avg_headshot, "Average Headshots %"),
      SizedBox(height: 30.0),
      InkWell(
        onTap: () => ToggleFavourite(),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          width: 150.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                isFavourited ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(width: 10.0),
              Text(
                isFavourited ? "Unfavourite" : "Favourite",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 30.0),
      Text(
        "User Links",
        style: TextStyle(
          color: Colors.white70,
        ),
      ),
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildUrlIcon("assets/faceit_logo.svg", OpenFaceItURL),
          _buildUrlIcon("assets/steam.svg", OpenSteamURL),
        ],
      ),
      SizedBox(height: 20.0),
    ];

    return SizedBox(
      child: Container(
        child: Column(
          children: stats,
        ),
      ),
    );
  }

  void ToggleFavourite() async {
    HapticFeedback.selectionClick();
    isFavourited
        ? await FavouritesManager.removeFavourite(_user.nickname)
        : await FavouritesManager.addFavourite(
            _user.nickname, _user.avatarImgLink);
    setState(() {
      isFavourited = !isFavourited;
    });
  }

  Widget _buildUrlIcon(String svgIconPath, openFunction) {
    return InkWell(
      onTap: () => openFunction(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        child: SvgPicture.asset(
          svgIconPath,
          height: 30.0,
          width: 30.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  void OpenSteamURL() async {
    HapticFeedback.selectionClick();
    var url = _user.getSteamURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void OpenFaceItURL() async {
    HapticFeedback.selectionClick();
    var url = _user.getFaceItURL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      SizedBox(width: 10.0),
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
          SizedBox(width: 5.0),
        );
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
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
