import 'dart:convert';

import 'package:flutter/cupertino.dart';

class User {
  final String userID;
  final String nickname;
  final String avatarImgLink;
  final String country;
  final String coverImgLink;

  User({
    @required this.userID,
    @required this.nickname,
    @required this.avatarImgLink,
    @required this.country,
    @required this.coverImgLink
  });

  factory User.fromJson (Map<String, dynamic> parsedJSON) {
    return User(
        userID: parsedJSON["player_id"],
        nickname: parsedJSON["nickname"],
        avatarImgLink: parsedJSON["avatar"],
        country: parsedJSON["country"],
        coverImgLink: parsedJSON["cover_image"]
    );
  }

//  static User createUserFromJSON(String JSON) {
//    var user = jsonDecode(JSON);
//
//    return User(
//      userID: user["player_id"],
//      nickname: user["nickname"],
//      avatarImgLink: user["avatar"],
//      country: user["country"],
//      coverImgLink: user["cover_image"]
//    );
//  }
}
