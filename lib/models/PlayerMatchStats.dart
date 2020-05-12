import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/models/KDHistory.dart';
import 'package:flutter/material.dart';

class PlayerMatchStats {
  final String player_id;
  final String nickname;
  final String result;
  final String kills;
  final String quadro_kills;
  final String assists;
  final String kd_ratio;
  final String deaths;
  final String kr_ratio;
  final String headshot_percentage;
  final String mvp_count;
  final String triple_kills;
  final String headshots;
  final String penta_kills;

  PlayerMatchStats(
      {this.player_id,
      this.nickname,
      this.result,
      this.kills,
      this.quadro_kills,
      this.assists,
      this.kd_ratio,
      this.deaths,
      this.kr_ratio,
      this.headshot_percentage,
      this.mvp_count,
      this.triple_kills,
      this.headshots,
      this.penta_kills});

  factory PlayerMatchStats.fromJson(Map<String, dynamic> parsedJSON) {
    Map<String, dynamic> stats = parsedJSON["player_stats"];

    // Add match KDR to KD History for graph
    if (MatchHistory.currentUser.nickname == parsedJSON["nickname"] &&
        !KDHistory.maxReached)
      KDHistory.addKDR(double.parse(stats["K/D Ratio"]));

    return PlayerMatchStats(
      player_id: parsedJSON["player_id"],
      nickname: parsedJSON["nickname"],
      result: stats["Result"],
      kills: stats["Kills"],
      quadro_kills: stats["Quadro Kills"],
      assists: stats["Assists"],
      kd_ratio: stats["K/D Ratio"],
      deaths: stats["Deaths"],
      kr_ratio: stats["K/R Ratio"],
      headshots: stats["Headshots %"],
      mvp_count: stats["MVPs"],
      triple_kills: stats["Triple Kills"],
      headshot_percentage: stats["Headshots %"],
      penta_kills: stats["Penta Kills"],
    );
  }
}
