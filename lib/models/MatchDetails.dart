class MatchDetails {

  final String match_id;
  final String game_mode;
  final Map map;
  final String score;

  MatchDetails(this.match_id, this.game_mode, this.map, this.score);

  factory MatchDetails.fromJson (Map<String, dynamic> parsedJSON) {
    return MatchDetails(

    );
  }

}

class Map {

  final String name;
  final String image_small;
  final String image_large;

  Map(this.name, this.image_small, this.image_large);

}