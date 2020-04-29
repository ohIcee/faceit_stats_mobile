import 'package:faceit_stats/models/GameDetails.dart';

class User {
  final String userID;
  final String nickname;
  final String avatarImgLink;
  final String country;
  final String coverImgLink;
  final List<GameDetails> games = <GameDetails>[];

  User({
    this.userID,
    this.nickname,
    this.avatarImgLink,
    this.country,
    this.coverImgLink
  });

  void addGameDetails(GameDetails details) => games.add(details);
  GameDetails getGameDetails(String game) => games.firstWhere((x) => x.game == "csgo");

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
