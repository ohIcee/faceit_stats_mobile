import 'package:flutter/material.dart';

class Rank {
  static Color whiteColor = Colors.white70;
  static Color greenColor = Colors.lightGreenAccent;
  static Color yellowColor = Colors.orangeAccent;
  static Color orangeColor = Colors.deepOrange;
  static Color redColor = Colors.red;

  final int rank;
  final int neededELO;
  final int maxELO;
  final Color color;

  Rank(this.rank, this.neededELO, this.maxELO, this.color);

  static Rank eloToRank(int ELO) {
    if (isBetween(ELO, 1, 800)) return new Rank(1, 1, 800, whiteColor);
    else if (isBetween(ELO, 801, 950)) return new Rank(2, 801, 950, greenColor);
    else if (isBetween(ELO, 951, 1100)) return new Rank(3, 951, 1100, greenColor);
    else if (isBetween(ELO, 1101, 1250)) return new Rank(4, 1101, 1250, yellowColor);
    else if (isBetween(ELO, 1251, 1400)) return new Rank(5, 1251, 1400, yellowColor);
    else if (isBetween(ELO, 1401, 1550)) return new Rank(6, 1401, 1550, yellowColor);
    else if (isBetween(ELO, 1551, 1700)) return new Rank(7, 1551, 1700, yellowColor);
    else if (isBetween(ELO, 1701, 1850)) return new Rank(8, 1701, 1850, orangeColor);
    else if (isBetween(ELO, 1851, 2000)) return new Rank(9, 1851, 2000, orangeColor);
    else if (ELO >= 2001) return new Rank(10, 2001, -1, redColor);
  }

  static bool isBetween(int num, int min, int max) {
    return min <= num && num <= max;
  }
}
