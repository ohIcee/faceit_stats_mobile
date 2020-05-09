import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/models/MapStats.dart';
import 'package:faceit_stats/models/user.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class UserMapStatsTab extends StatefulWidget {
  UserMapStatsTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserMapStatsTabState();
}

class UserMapStatsTabState extends State<UserMapStatsTab> {
  final mapStatsListKey = PageStorageKey('MapStatsList');
  User _user;

  @override
  Widget build(BuildContext context) {
    if (_user == null) _user = MatchHistory.currentUser;
    return _buildMapStatsPage();
  }

  Widget _buildMapStatsPage() {
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
                "Map Stats",
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
            Expanded(child: _buildMapStats()),
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

  Widget _buildMapStats() {
    return ListView.builder(
      key: mapStatsListKey,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      itemCount: _user.getCsgoDetails.map_stats.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var map = _user.getCsgoDetails.map_stats[index];
        return _buildMapStatsCard(map);
      },
    );
  }

  Widget _buildMapStatsCard(MapStats map) {
    return Container(
      width: double.infinity,
      height: 200.0,
      color: Colors.white10.withOpacity(.05),
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: IntrinsicHeight(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100.0,
              child: Image.asset(
                'assets/map_images/${map.label}.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              map.label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Matches"),
                    Text(
                      "${map.matches}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Win Rate"),
                    Text(
                      "${map.win_percentage} %",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
