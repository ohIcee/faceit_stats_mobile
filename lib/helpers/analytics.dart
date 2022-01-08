import 'package:faceit_stats/helpers/adManager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

class analytics {
  static FirebaseAnalytics fb_analytics;

  static Future<bool> requestConsent() async {
    var consented = false;

    // ask for advertisement consent
    await GdprDialog.instance
        .showDialog()
        .then((onValue) {
      if (onValue) {
        analytics.fb_analytics.setAnalyticsCollectionEnabled(onValue);
        consented = onValue;
      }
    });

    return consented;
  }

  static Future<void> resetConsent() async {
    await GdprDialog.instance.resetDecision();
    adManager.updateTargetingInfo();
  }

}