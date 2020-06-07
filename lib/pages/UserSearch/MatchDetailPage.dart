import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/models/Faction.dart';
import 'package:faceit_stats/models/PlayerMatchStats.dart';
import 'package:faceit_stats/models/user.dart';
import 'package:faceit_stats/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_up_animation/show_up_animation.dart';

class MatchDetailPage extends StatefulWidget {
  static const routeName = '/matchDetails';

  MatchDetailPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  String _matchID;
  Match _match;
  User _user;
  int playersShowupDelay = 0;

  @override
  Widget build(BuildContext context) {
    _matchID = ModalRoute.of(context).settings.arguments;
    if (_user == null) _user = MatchHistory.currentUser;
    if (_match == null) _match = MatchHistory.getMatchByID(_matchID);

    Faction _userFaction;
    _match.factions.forEach((faction) {
      faction.players.forEach((player) {
        if (_userFaction != null) return;
        if (player.player_id == _user.userID) _userFaction = faction;
      });
    });

    var matchTime =
        DateTime.fromMillisecondsSinceEpoch(_match.finished_at * 1000);
    var formattedMatchTime = new DateFormat("dd MMM - HH:mm").format(matchTime);
    return Scaffold(
      appBar: MainAppBar(appBar: AppBar()),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
//              CustomAppBar(backButton: true),
              Hero(
                tag: _match.match_id,
                child: Container(
                  height: 120.0,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/map_images/${_match.map}.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ShowUpAnimation(
                animationDuration: Duration(milliseconds: 0),
                curve: Curves.fastOutSlowIn,
                direction: Direction.vertical,
                offset: 0.5,
                child: Text(
                  "Match Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      letterSpacing: .7),
                ),
              ),
              Text(
                "SCORE ${_match.score}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: "faction${_userFaction.faction_num}" ==
                          _match.winning_faction
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              SizedBox(height: 10.0),
              ShowUpAnimation(
                animationDuration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                direction: Direction.vertical,
                offset: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 18.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      formattedMatchTime,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Divider(thickness: 1.5),
              SizedBox(height: 10.0),
              _buildFactionInfo(_match.factions[0]),
              SizedBox(height: 10.0),
              _buildFactionInfo(_match.factions[1]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactionInfo(Faction faction) {
    var isWinningFaction =
        "faction${faction.faction_num}" == _match.winning_faction
            ? true
            : false;

    return Column(
      children: <Widget>[
        _buildFactionHeader(faction, isWinningFaction),
        _buildFactionPlayers(faction),
      ],
    );
  }

  Widget _buildFactionPlayers(Faction faction) {
    var players = <Widget>[];
    faction.player_stats.forEach((e) {
      players.add(_buildPlayerTile(e, playersShowupDelay));
      playersShowupDelay += 80;
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  "PLAYER",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.5),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "K",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Text(
                      "A",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Text(
                      "D",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.white.withOpacity(.5),
                      size: 15.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: players,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTile(PlayerMatchStats stats, int delay) {
    return ShowUpAnimation(
      delayStart: Duration(milliseconds: delay),
      animationDuration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      direction: Direction.vertical,
      offset: 0.5,
      child: Container(
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                stats.nickname,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    stats.kills,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(stats.assists),
                  Text(
                    stats.deaths,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(stats.mvp_count),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactionHeader(Faction faction, bool winner) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          faction.nickname,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        SizedBox(width: 10.0),
        Text(
          "${faction.final_score} rounds",
          style: TextStyle(
            fontSize: 15.0,
            color: winner
                ? Colors.green.withOpacity(.6)
                : Colors.red.withOpacity(.6),
          ),
        ),
      ],
    );
  }
}
