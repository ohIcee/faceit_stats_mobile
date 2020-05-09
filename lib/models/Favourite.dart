class Favourite {
  final String nickname;

  Favourite({this.nickname});

  factory Favourite.fromJson(String nickname) {
    return Favourite(
      nickname: nickname,
    );
  }

  Map<String, dynamic> toJson() => {
    '"nickname"': '"$nickname"',
  };
}