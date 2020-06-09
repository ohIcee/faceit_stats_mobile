class MapStats {
  final String label;
  final String matches;
  final String average_headshots_percentage;
  final String kills;
  final String deaths;
  final String mvp_count;
  final String win_count;
  final String win_percentage;
  final String quadro_kills;
  final String penta_kills;
  final String triple_kills;
  final String headshots;

  MapStats(
      {this.label,
      this.matches,
      this.average_headshots_percentage,
      this.kills,
      this.deaths,
      this.mvp_count,
      this.win_count,
      this.win_percentage,
      this.triple_kills,
      this.quadro_kills,
      this.penta_kills,
      this.headshots});

  factory MapStats.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> stats = map["stats"];

    return MapStats(
      label: map["label"],
      average_headshots_percentage: stats["Average Headshots %"],
      deaths: stats["Deaths"],
      kills: stats["Kills"],
      headshots: stats["Total Headshots %"],
      matches: stats["Matches"],
      mvp_count: stats["MVPs"],
      penta_kills: stats["Penta Kills"],
      quadro_kills: stats["Quadro Kills"],
      triple_kills: stats["Triple Kills"],
      win_count: stats["Wins"],
      win_percentage: stats["Win Rate %"],
    );
  }
}
