import 'package:faceit_stats/models/FactionPlayer.dart';
import 'package:faceit_stats/models/PlayerMatchStats.dart';
import 'package:flutter/material.dart';

class Faction {
  final int faction_num;
  final String team_id;
  final String nickname;
  final String avatar;
  final bool premade;
  final String second_half_score;
  final String final_score;
  final String team_headshot;
  final String overtime_score;
  final String first_half_score;

  final List<FactionPlayer> players;
  final List<PlayerMatchStats> player_stats;

  Faction(
      {this.premade,
      this.second_half_score,
      this.final_score,
      this.team_headshot,
      this.overtime_score,
      this.first_half_score,
      this.faction_num,
      this.team_id,
      this.nickname,
      this.avatar,
      this.players,
      this.player_stats});
}
