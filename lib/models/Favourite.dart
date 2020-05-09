class Favourite {
  final String nickname;
  final String avatarUrl;

  Favourite({this.avatarUrl, this.nickname});

  factory Favourite.fromJson(String nickname, String avatarUrl) {
    return Favourite(
      nickname: nickname,
      avatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        '"nickname"': '"$nickname"',
        '"avatarUrl"': '"$avatarUrl"',
      };
}
