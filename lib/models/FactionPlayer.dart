class FactionPlayer {
  final String player_id;
  final String nickname;
  final String avatar;
  final int skill_level;
  final String game_player_id;
  final String game_player_name;
  final String faceit_url;

  FactionPlayer(this.player_id, this.nickname, this.avatar, this.skill_level,
      this.game_player_id, this.game_player_name, this.faceit_url);
}