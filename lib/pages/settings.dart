import 'package:faceit_stats/helpers/adManager.dart';
import 'package:flutter/material.dart';
import 'package:faceit_stats/appBar.dart';
import 'package:package_info/package_info.dart';
import 'package:faceit_stats/helpers/analytics.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion;

  bool analyticsConsented = false;

  @override
  void initState() {
    _getAppVersion();
    analyticsConsented = !adManager.targetingInfo.nonPersonalizedAds;
    super.initState();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildAdsSection(),
            Spacer(),
            Container(
                child: Text(
              "Version $appVersion",
              textAlign: TextAlign.center,
            )),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionHeader("Ad settings"),
        SizedBox(height: 5.0),
        Text(
          analyticsConsented
              ? "Ads ARE personalized."
              : "Ads are NOT personalized.",
          style: TextStyle(
            color: analyticsConsented
                ? Colors.green.withOpacity(.75)
                : Colors.red.withOpacity(.75),
          ),
        ),
        RaisedButton(
          child: Text("Change ad personalization settings"),
          onPressed: () {
            setState(() {
              requestAndRetrieveConsent();
            });
          },
          color: Colors.white10,
        ),
        Text(
          "We ONLY use your data for personalized advertisements and basic non-personally identifying statistics for the app.",
          style: TextStyle(
            color: Colors.orange,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  void requestAndRetrieveConsent() async {
    var consent = await analytics.requestConsent();

    adManager.updateTargetingInfo();

    setState(() {
      analyticsConsented = consent;
    });
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
