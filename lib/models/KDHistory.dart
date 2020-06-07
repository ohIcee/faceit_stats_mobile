class KDHistory {
  // From how many matches KDR should be shown (max)
  static int maxNumMatches = 8;
  static List<double> _kdr = new List<double>();

  static List<double> get kdr => _kdr;
  static void addKDR(double kdr) => _kdr.add(double.parse(kdr.toStringAsFixed(2)));
  static bool get maxReached => _kdr.length >= maxNumMatches;
  static void resetStats() => _kdr = new List<double>();
}