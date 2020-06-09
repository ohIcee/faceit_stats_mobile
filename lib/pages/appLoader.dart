import 'package:faceit_stats/helpers/FavouritesManager.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:faceit_stats/helpers/adManager.dart';
import 'package:faceit_stats/helpers/page_transition.dart';
import 'package:faceit_stats/pages/home.dart';
import 'package:flutter/material.dart';

class AppLoaderPage extends StatefulWidget {
  static const routeName = '/appLoader';

  AppLoaderPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppLoaderPageState createState() => _AppLoaderPageState();
}

class _AppLoaderPageState extends State<AppLoaderPage> {
  void loadApp() async {
    await RemoteConfigManager.Init();
    await FavouritesManager.Init();
    await adManager.Init();
    adManager.InitBannerAd();

    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 500),
        child: HomePage(),
      ),
    );
  }

  @override
  void initState() {
    loadApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
