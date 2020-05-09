import 'package:faceit_stats/models/GameDetails.dart';
import 'package:faceit_stats/models/MapStats.dart';

class CsgoDetails extends GameDetails {
  final String win_rate;
  final String current_win_streak;
  final List<dynamic> recent_results;
  final String average_kd;
  final String avg_headshot;
  final String longest_win_streak;
  final String match_count;
  final String win_count;
  final List<MapStats> map_stats;

  CsgoDetails({
    String game_id,
    String game_profile_id,
    String region,
    String skill_level_label,
    String game_player_id,
    int skill_level,
    int faceit_elo,
    String game_player_name,
    this.win_rate,
    this.current_win_streak,
    this.recent_results,
    this.average_kd,
    this.avg_headshot,
    this.longest_win_streak,
    this.match_count,
    this.win_count,
    this.map_stats,
  }) : super(game_profile_id, region, skill_level_label, game_player_id,
            skill_level, faceit_elo, game_player_name);

  factory CsgoDetails.fromJson(
      Map<String, dynamic> playerStats, Map<String, dynamic> playerGameStats) {
    List<dynamic> maps = playerGameStats["segments"];
    List<MapStats> MapsStats = new List<MapStats>();
    maps.forEach((stats) {
      Map<String, dynamic> _stats = stats;
      MapsStats.add(MapStats.fromJson(_stats));
    });

    return CsgoDetails(
        game_id: playerGameStats["lifetime"]["game_id"],
        game_profile_id: playerStats["game_profile_id"],
        region: playerStats["region"],
        skill_level_label: playerStats["skill_level_label"],
        game_player_id: playerStats["game_player_id"],
        skill_level: playerStats["skill_level"],
        faceit_elo: playerStats["faceit_elo"],
        game_player_name: playerStats["game_player_name"],
        win_rate: playerGameStats["lifetime"]["Win Rate %"],
        current_win_streak: playerGameStats["lifetime"]["Current Win Streak"],
        recent_results: playerGameStats["lifetime"]["Recent Results"],
        average_kd: playerGameStats["lifetime"]["Average K/D Ratio"],
        avg_headshot: playerGameStats["lifetime"]["Average Headshots %"],
        longest_win_streak: playerGameStats["lifetime"]["Longest Win Streak"],
        match_count: playerGameStats["lifetime"]["Matches"],
        win_count: playerGameStats["lifetime"]["Wins"],
        map_stats: MapsStats);
  }
}
