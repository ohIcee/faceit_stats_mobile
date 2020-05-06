import 'dart:convert';
import 'dart:io';
import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/models/CsgoDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:faceit_stats/models/user.dart';

class PlayerSearch {

  static User currentSearchedUser;

  static Future<User> GetUserGameDetails(String name, String game) async {
    currentSearchedUser = null;

    var queryParams = {"nickname": name, "game": game};

    // < BASIC USER DETAILS >
    var uri = Uri.https("open.faceit.com", "/data/v4/players", queryParams);
    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var decodedJSON = jsonDecode(response.body);
    var _user = User.fromJson(decodedJSON);
    // </ BASIC USER DETAILS >

    currentSearchedUser = _user;

    // < CSGO DETAILS >
    uri = Uri.https("open.faceit.com", "/data/v4/players/${_user.userID}/stats/csgo");
    var CSGOresponse = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
      HttpHeaders.contentTypeHeader: "application/json",
    });
    var CSGOdecodedJSON = jsonDecode(CSGOresponse.body);
    var _csgoDetails = CsgoDetails.fromJson(
        decodedJSON["games"]["csgo"], CSGOdecodedJSON);
    // </ CSGO DETAILS >

    _user.setCsgoDetails(_csgoDetails);

    return _user;
  }
}
