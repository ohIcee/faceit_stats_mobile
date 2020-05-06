import 'package:faceit_stats/models/Faction.dart';
import 'package:faceit_stats/models/FactionPlayer.dart';

class Match {
  final String match_id;
  final String game_id;
  final String region;
  final int max_players;
  final int teams_size;
  final String competition_name;
  final String game_mode;
  final int finished_at;
  final String winning_faction;
  final String faceit_url;
  final String score;
  final String map;
  final String rounds;

  final List<Faction> factions;
  final List<String> playing_players;

  Match(
      {this.competition_name,
      this.finished_at,
      this.winning_faction,
      this.faceit_url,
      this.match_id,
      this.game_id,
      this.region,
      this.max_players,
      this.teams_size,
      this.game_mode,
      this.playing_players,
      this.factions,
      this.score,
      this.map,
      this.rounds});

  factory Match.fromJson(
      Map<String, dynamic> parsedJSON, Map<String, dynamic> matchDetailsJSON) {
    Map<String, dynamic> round_stats = matchDetailsJSON["round_stats"];

    // Parse playing players list from JSON
    List<String> playing_players = new List<String>();
    List<dynamic> playing_players_list = parsedJSON["playing_players"];
    if (playing_players_list.length > 0)
      playing_players_list.forEach((element) => playing_players.add(element));

    // Parse results from JSON
    Map<String, dynamic> results_json = parsedJSON["results"];

    // Parse teams from JSON
    Map<String, dynamic> factions_json = parsedJSON["teams"];
    Map<String, dynamic> faction1_json = factions_json["faction1"];
    Map<String, dynamic> faction2_json = factions_json["faction2"];

    List<FactionPlayer> faction1_players = new List<FactionPlayer>();
    List<FactionPlayer> faction2_players = new List<FactionPlayer>();

    List<dynamic> faction1_players_json = faction1_json["players"];
    List<dynamic> faction2_players_json = faction2_json["players"];

    faction1_players_json.forEach((element) {
      faction1_players.add(new FactionPlayer(
          element["player_id"],
          element["nickname"],
          element["avatar"],
          element["skill_level"],
          element["game_player_id"],
          element["game_player_name"],
          element["faceit_url"]));
    });

    faction2_players_json.forEach((element) {
      faction2_players.add(new FactionPlayer(
          element["player_id"],
          element["nickname"],
          element["avatar"],
          element["skill_level"],
          element["game_player_id"],
          element["game_player_name"],
          element["faceit_url"]));
    });

    var faction1 = new Faction(
        faction_num: 1,
        team_id: faction1_json["team_id"],
        avatar: faction1_json["avatar"],
        nickname: faction1_json["nickname"],
        players: faction1_players);

    var faction2 = new Faction(
        faction_num: 2,
        team_id: faction2_json["team_id"],
        avatar: faction2_json["avatar"],
        nickname: faction2_json["nickname"],
        players: faction2_players);

    return Match(
        match_id: parsedJSON["match_id"],
        region: parsedJSON["region"],
        game_id: "csgo",
        game_mode: parsedJSON["game_mode"],
        max_players: parsedJSON["max_players"],
        teams_size: parsedJSON["teams_size"],
        competition_name: parsedJSON["competition_name"],
        finished_at: parsedJSON["finished_at"],
        faceit_url: parsedJSON["faceit_url"],
        playing_players: playing_players,
        winning_faction: results_json["winner"],
        factions: [faction1, faction2],
        score: round_stats["Score"],
        map: round_stats["Map"],
        rounds: round_stats["Rounds"]);
  }
}