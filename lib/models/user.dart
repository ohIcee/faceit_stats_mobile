import 'package:faceit_stats/models/CsgoDetails.dart';

class User {
  final String userID;
  final String nickname;
  final String avatarImgLink;
  final String country;
  final String coverImgLink;
  // ignore: non_constant_identifier_names
  CsgoDetails CSGODetails;

  User({
    this.userID,
    this.nickname,
    this.avatarImgLink,
    this.country,
    this.coverImgLink
  });

  void setCsgoDetails(CsgoDetails details) => CSGODetails = details;
  CsgoDetails getCsgoDetails() => CSGODetails;

  factory User.fromJson (Map<String, dynamic> parsedJSON) {
    return User(
        userID: parsedJSON["player_id"],
        nickname: parsedJSON["nickname"],
        avatarImgLink: parsedJSON["avatar"],
        country: parsedJSON["country"],
        coverImgLink: parsedJSON["cover_image"]
    );
  }
}
