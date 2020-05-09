import 'package:faceit_stats/models/CsgoDetails.dart';

class User {
  final String userID;
  final String nickname;
  final String avatarImgLink;
  final String country;
  final String coverImgLink;
  final String steam_id_64;
  final String faceit_url;

  // ignore: non_constant_identifier_names
  CsgoDetails CSGODetails;

  User({
    this.userID,
    this.nickname,
    this.avatarImgLink,
    this.country,
    this.coverImgLink,
    this.steam_id_64,
    this.faceit_url,
  });

  set setCsgoDetails(CsgoDetails details) => CSGODetails = details;

  CsgoDetails get getCsgoDetails => CSGODetails;

  String get getSteamURL =>
      "http://steamcommunity.com/profiles/${this.steam_id_64}";

  String get getFaceItURL => faceit_url.replaceAll("{lang}", "en");

  factory User.fromJson(Map<String, dynamic> parsedJSON) {
    return User(
      userID: parsedJSON["player_id"],
      nickname: parsedJSON["nickname"],
      avatarImgLink: parsedJSON["avatar"],
      country: parsedJSON["country"],
      coverImgLink: parsedJSON["cover_image"],
      steam_id_64: parsedJSON["steam_id_64"],
      faceit_url: parsedJSON["faceit_url"],
    );
  }
}
