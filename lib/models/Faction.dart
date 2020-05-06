import 'package:faceit_stats/models/FactionPlayer.dart';

class Faction {
  final int faction_num;
  final String team_id;
  final String nickname;
  final String avatar;

  final List<FactionPlayer> players;

  Faction(
      {this.faction_num,
        this.team_id,
        this.nickname,
        this.avatar,
        this.players});

  factory Faction.fromJson(Map<String, dynamic> parsedJSON) {
    return Faction(
      team_id: parsedJSON["team_id"],
      nickname: parsedJSON["nickname"],
      avatar: parsedJSON["avatar"],
      players: parsedJSON["players"],
    );
  }
}