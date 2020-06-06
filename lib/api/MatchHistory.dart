import 'dart:convert';
import 'dart:io';
import 'package:faceit_stats/helpers/enums.dart';
import 'package:faceit_stats/models/KDHistory.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';

class MatchHistory {
  static int _numMatchesLoaded = 0;
  static var currentUser = PlayerSearch.currentSearchedUser;
  static List<Match> loadedMatches = new List<Match>();
  static API_RESPONSES lastAPIResponse;

  static Match getMatchByID(String id) => loadedMatches.firstWhere((e) => e.match_id == id);

  static void ResetMatchHistory() {
    _numMatchesLoaded = 0;
    loadedMatches = new List<Match>();
    KDHistory.resetStats();
  }

  static Future<List<Match>> LoadNext() async {
    currentUser = PlayerSearch.currentSearchedUser;

    var queryParams = {
      "nickname": currentUser.userID.toString(),
      "game": "csgo",
      "offset": _numMatchesLoaded == 0 ? 20.toString() : (_numMatchesLoaded * 2).toString(),
      "limit": _numMatchesLoaded.toString(),
      "from": "1546300800"
    };

    var uri = Uri.https("open.faceit.com",
        "data/v4/players/${currentUser.userID}/history", queryParams);
    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var decodedJSON = jsonDecode(response.body);
    List<dynamic> matchesJSON = decodedJSON["items"];

    if (matchesJSON == null || matchesJSON.length <= 0) {
      if (response.statusCode == 200) lastAPIResponse = API_RESPONSES.NO_MORE_MATCHES;
      else lastAPIResponse = API_RESPONSES.FAIL_RETRIEVE;
      return null;
    }

    // call /matches/{match_id}/stats for each match
    // and save responses to list
    List<http.Response> matchStats = await Future.wait(
      matchesJSON.map(
        (match) async {
          var res = await http.get(
              Uri.https(
                  "open.faceit.com",
                  "data/v4/matches/${match["match_id"]}/stats",
                  {"match_id": match["match_id"]}),
              headers: {
                HttpHeaders.authorizationHeader:
                "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
                HttpHeaders.contentTypeHeader: "application/json",
              });
          return res;
        }
      ),
    );

    List<Map<String, dynamic>> matchesDetails =
        new List<Map<String, dynamic>>();

    matchStats.asMap().forEach((index, response) {
      Map<String, dynamic> matchJSON = jsonDecode(response.body);

      // If the match successfully retrieved,
      // add it to map, otherwise remove it from the
      // matches array
      if (matchJSON["rounds"] != null) {
        matchesDetails.add(matchJSON["rounds"][0]);
      } else matchesJSON.removeAt(index);
    });

    // TODO Convert this for loop into a loop that matches
    // match_id's together
    // (if matches don't get retrieved in order)
    var newMatches = List<Match>();
    for (var i = 0; i < matchesJSON.length; i++) {
      var match = Match.fromJson(matchesJSON[i], matchesDetails[i]);
      loadedMatches.add(match);
      newMatches.add(match);
    }

    lastAPIResponse = API_RESPONSES.SUCCESS_RETRIEVE;
    _numMatchesLoaded += matchesJSON.length;
    return newMatches;
  }
}
