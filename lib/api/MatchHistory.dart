import 'dart:convert';
import 'dart:io';

import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MatchHistory {
  static int _numMatchesLoaded = 0;
  static var currentUser = PlayerSearch.currentSearchedUser;
  static List<Match> loadedMatches = new List<Match>();

  static void ResetMatchHistory() {
    _numMatchesLoaded = 0;
    loadedMatches = new List<Match>();
//    currentUser = PlayerSearch.currentSearchedUser;
    debugPrint("RESET MATCH HISTORY");
  }

  static Future<bool> LoadNext(int num) async {
    currentUser = PlayerSearch.currentSearchedUser;

    var queryParams = {
      "nickname": currentUser.userID.toString(),
      "game": "csgo",
      "offset": _numMatchesLoaded.toString(),
      "limit": num.toString()
    };
    _numMatchesLoaded += num;

    var uri = Uri.https("open.faceit.com",
        "data/v4/players/${currentUser.userID}/history", queryParams);
    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var decodedJSON = jsonDecode(response.body);
    List<dynamic> matchesJSON = decodedJSON["items"];

    if (matchesJSON.length <= 0) return null;

    // call /matches/{match_id}/stats for each match
    // and save responses to list
    List<http.Response> matchStats = await Future.wait(
      matchesJSON.map(
        (match) => http.get(
            Uri.https(
                "open.faceit.com",
                "data/v4/matches/${match["match_id"]}/stats",
                {"match_id": match["match_id"]}),
            headers: {
              HttpHeaders.authorizationHeader:
                  "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
              HttpHeaders.contentTypeHeader: "application/json",
            }),
      ),
    );

    List<Map<String, dynamic>> matchesDetails =
        new List<Map<String, dynamic>>();
    matchStats.forEach((response) {
      Map<String, dynamic> matchJSON = jsonDecode(response.body);
      matchesDetails.add(matchJSON["rounds"][0]);
    });

    // Create List of Matches from the retrieved matches
    List<Match> matches = new List<Match>();

    // TODO Convert this for loop into a loop that matches
    // match_id's together
    // (if matches don't get retrieved in order)
    for (var i = 0; i < matchesJSON.length; i++) {
      var match = Match.fromJson(matchesJSON[i], matchesDetails[i]);
//      matches.add(match);
      loadedMatches.add(match);
    }

//    return matches;
    return true;
  }
}
