import 'package:firebase_admob/firebase_admob.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

class adManager {
  static MobileAdTargetingInfo targetingInfo;

  static BannerAd _bannerAd;

  static Future<void> Init() async {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-5167276366193403~3958343265");

    await updateTargetingInfo();
  }

  static Future<void> updateTargetingInfo() async {
    bool consent = await GdprDialog.instance.getConsentStatus() == "PERSONALIZED" ? true : false;

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      nonPersonalizedAds: !consent,
    );
  }

  static void InitBannerAd() {
    _bannerAd = _createBannerAd();
    loadBannerAd();
  }

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-5167276366193403/4740660051',
      size: AdSize.banner,
      targetingInfo: adManager.targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static void loadBannerAd() {
    _bannerAd..load();
  }

  static void disposeAds() {
    _bannerAd.dispose();
    _bannerAd = null;
  }

  static void SetBannerAd(BannerAd ad) => _bannerAd = ad;
  static get bannerAd => _bannerAd;

}