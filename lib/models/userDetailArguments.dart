import 'package:faceit_stats/models/user.dart';
import 'package:faceit_stats/models/Match.dart';

class UserDetailArguments {
  final User user;
  final List<Match> matchHistory;

  UserDetailArguments(this.user, this.matchHistory);
}