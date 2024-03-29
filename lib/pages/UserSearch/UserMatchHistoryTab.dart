import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/helpers/enums.dart';
import 'package:faceit_stats/helpers/page_transition.dart';
import 'package:faceit_stats/models/Faction.dart';
import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/models/user.dart';
import 'package:faceit_stats/pages/UserSearch/MatchDetailPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:intl/intl.dart';

class UserMatchHistoryTab extends StatefulWidget {
  final listKey;

  UserMatchHistoryTab({Key key, this.listKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserMatchHistoryTabState();
}

class UserMatchHistoryTabState extends State<UserMatchHistoryTab> {
  final matchHistoryListKey = PageStorageKey('MatchHistoryList');
  User _user;
  bool isLoadingMatches = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) _user = MatchHistory.currentUser;
    return _buildMatchHistoryPage();
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
            SizedBox(height: 20.0),
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
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Icon(
            Icons.chevron_right,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchHistoryCard(Match match) {
    Faction userFaction;
    match.factions.forEach((faction) {
      faction.players.forEach((player) {
        if (userFaction != null) return;
        if (player.player_id == _user.userID) userFaction = faction;
      });
    });

    var matchTime =
        DateTime.fromMillisecondsSinceEpoch(match.finished_at * 1000);
    var formattedMatchTime = new DateFormat("dd MMM - HH:mm").format(matchTime);

    return Container(
      width: double.infinity,
      height: 120.0,
      color: Colors.white10.withOpacity(.05),
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: InkWell(
        onTap: () => showMatchDetails(match.match_id),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 120.0,
                child: Hero(
                  tag: match.match_id,
                  child: Image.asset(
                    'assets/map_images/${match.map}.jpg',
                    fit: BoxFit.cover,
                  ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            formatTime(match.finished_at * 1000),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            formattedMatchTime,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.withOpacity(.5),
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMatchDetails(String matchID) {
    HapticFeedback.vibrate();

    //Navigator.pushNamed(context, '/matchDetails', arguments: matchID);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 400),
        child: MatchDetailPage(matchID: matchID),
      ),
    );
  }

  Widget _buildMatchHistory() {
    // TODO ANIMATED LIST VIEW
    // animate list items into view on load
    return ListView.builder(
      addAutomaticKeepAlives: true,
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
              bottom: 70.0,
            ),
            child: _buildMatchHistoryLoader(),
          );
        } else {
          var match = MatchHistory.loadedMatches[index];

          if (index != 0 && index % 4 == 0) {

            // show ad
            return Column(
              children: <Widget>[
//                Container(
//                  height: 200.0,
//                  color: Colors.white10.withOpacity(.05),
//                  child: _buildAd(),
//                ),
//                SizedBox(height: 10.0),
                _buildMatchHistoryCard(match),
              ],
            );
          } else {
            return _buildMatchHistoryCard(match);
          }
        }
      },
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
                onPressed: () => loadNextMatchHistory(),
                child: Text(
                  "Load more...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text("No more matches to retrieve...");
  }

  void loadNextMatchHistory() async {
    setState(() => isLoadingMatches = true);
    HapticFeedback.vibrate();
    await MatchHistory.LoadNext();

    setState(() => isLoadingMatches = false);
  }
}
