import 'dart:convert';
import 'dart:io';
import 'package:faceit_stats/helpers/enums.dart';
import 'package:http/http.dart' as http;

import 'package:faceit_stats/models/Match.dart';
import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';

class MatchHistory {
  static int _numMatchesLoaded = 0;
  static var currentUser = PlayerSearch.currentSearchedUser;
  static List<Match> loadedMatches = new List<Match>();
  static API_RESPONSES lastAPIResponse;

  static void ResetMatchHistory() {
    _numMatchesLoaded = 0;
    loadedMatches = new List<Match>();
  }

  static Future<bool> LoadNext(int num) async {
    currentUser = PlayerSearch.currentSearchedUser;

    var queryParams = {
      "nickname": currentUser.userID.toString(),
      "game": "csgo",
      "offset": _numMatchesLoaded.toString(),
      "limit": num.toString()
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

    // TODO Convert this for loop into a loop that matches
    // match_id's together
    // (if matches don't get retrieved in order)
    for (var i = 0; i < matchesJSON.length; i++) {
      var match = Match.fromJson(matchesJSON[i], matchesDetails[i]);
      loadedMatches.add(match);
    }

    lastAPIResponse = API_RESPONSES.SUCCESS_RETRIEVE;
    _numMatchesLoaded += num;
    return true;
  }
}
