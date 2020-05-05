import 'package:faceit_stats/models/user.dart';

class Match {
  final String match_id;
  final String game_id;
  final String region;
  final int max_players;
  final int teams_size;

  List<Team> teams;

  Match({this.match_id, this.game_id, this.region, this.max_players, this.teams_size});

  factory Match.fromJson (Map<String, dynamic> parsedJSON) {

    //var team_1 = parsedJSON["faction1"];
    //var team_2 = parsedJSON["faction2"];

    return Match(
      match_id: parsedJSON["match_id"],
      game_id: parsedJSON["game_id"],
      region: parsedJSON["region"],
      teams_size: parsedJSON["teams_size"],
    );
  }
}

class Team {
  final String team_id;
  final String nickname;
  final String avatar;

  List<User> users;

  Team({this.team_id, this.nickname, this.avatar});

  factory Team.fromJson (Map<String, dynamic> parsedJSON) {
    return Team(
      team_id: parsedJSON["team_id"],
      nickname: parsedJSON["nickname"],
      avatar: parsedJSON["avatar"],
    );
  }
}
