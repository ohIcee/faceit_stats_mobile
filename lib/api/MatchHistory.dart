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

  static Future<List<Match>> LoadNext(int num) async {
    var queryParams = {
      "nickname": currentUser.userID.toString(),
      "game": "csgo",
      "offset": _numMatchesLoaded.toString(),
      "limit": num.toString()
    };

    var uri = Uri.https("open.faceit.com", "data/v4/players/${currentUser.userID}/history", queryParams);
    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var decodedJSON = jsonDecode(response.body);
    List<dynamic> matchesJSON = decodedJSON["items"];

    // TODO GET MATCH DETAILS

    if (matchesJSON.length <= 0) return null;

    // Create List of Matches from the retrieved matches
    List<Match> matches = new List<Match>();
    matchesJSON.forEach((element) {
      var match = Match.fromJson(element);
      matches.add(match);
    });
    return matches;
  }
}
