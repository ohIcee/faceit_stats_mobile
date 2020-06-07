import 'package:firebase_analytics/firebase_analytics.dart';

class analytics {
  static FirebaseAnalytics fb_analytics;

  static void Init() {
    fb_analytics = FirebaseAnalytics();
  }
}