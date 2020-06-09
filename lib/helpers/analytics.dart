import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

class analytics {
  static FirebaseAnalytics fb_analytics;

  static void Init() {
    fb_analytics = FirebaseAnalytics();
  }

  static Future<bool> requestConsent() async {
    var consented = false;

    debugPrint("REQUESTING");

    // ask for advertisement consent
    GdprDialog.instance.setConsentToUnknown();
    await GdprDialog.instance
        .showDialog(
      'pub-2111344032223404',
      'https://ohicee.github.io/faceit_stats_privacy'
    )
        .then((onValue) {
      if (onValue) {
        analytics.fb_analytics.setAnalyticsCollectionEnabled(onValue);
        consented = onValue;
      }
    });

    return consented;
  }

}