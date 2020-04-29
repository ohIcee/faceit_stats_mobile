import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:faceit_stats/models/user.dart';

class PlayerSearch {

  static Future<User> GetUserGameDetails(String name, String game) async {
    var queryParams = {
      "nickname": name,
      "game": game
    };

    var uri = Uri.https("open.faceit.com", "/data/v4/players", queryParams);
    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + RemoteConfigManager.getConfigValue("faceit_api"),
      HttpHeaders.contentTypeHeader: "application/json",
    });

    var _user = User.fromJson(jsonDecode(response.body));
    return _user;
  }

}