class GameDetails {
  final String game;
  // ignore: non_constant_identifier_names
  final String game_profile_id;
  final String region;
  // ignore: non_constant_identifier_names
  final String skill_level_label;
  // ignore: non_constant_identifier_names
  final String game_player_id;
  // ignore: non_constant_identifier_names
  final int skill_level;
  // ignore: non_constant_identifier_names
  final int faceit_elo;
  // ignore: non_constant_identifier_names
  final String game_player_name;

  GameDetails({
      this.game,
      // ignore: non_constant_identifier_names
      this.game_profile_id,
      this.region,
      // ignore: non_constant_identifier_names
      this.skill_level_label,
      // ignore: non_constant_identifier_names
      this.game_player_id,
      // ignore: non_constant_identifier_names
      this.skill_level,
      // ignore: non_constant_identifier_names
      this.faceit_elo,
      // ignore: non_constant_identifier_names
      this.game_player_name});

  factory GameDetails.fromJson (Map<String, dynamic> parsedJSON, String game) {
    return GameDetails(
      game: game,
      game_profile_id: parsedJSON["game_profile_id"],
      region: parsedJSON["region"],
      skill_level_label: parsedJSON["skill_level_label"],
      game_player_id: parsedJSON["game_player_id"],
      skill_level: parsedJSON["skill_level"],
      faceit_elo: parsedJSON["faceit_elo"],
      game_player_name: parsedJSON["game_player_name"]
    );
  }
}
