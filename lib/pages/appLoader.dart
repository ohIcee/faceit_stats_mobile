import 'package:faceit_stats/helpers/FavouritesManager.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:faceit_stats/helpers/adManager.dart';
import 'package:faceit_stats/helpers/page_transition.dart';
import 'package:faceit_stats/pages/home.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';

class AppLoaderPage extends StatefulWidget {
  static const routeName = '/appLoader';

  AppLoaderPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppLoaderPageState createState() => _AppLoaderPageState();
}

class _AppLoaderPageState extends State<AppLoaderPage> {
  var isLoaded = false;

  void loadApp() async {
    await RemoteConfigManager.Init();
    await FavouritesManager.Init();
    await adManager.Init();

    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    loadApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashScreen.callback(
        name: 'assets/faceit_splash.flr',
        startAnimation: 'play_test',
        endAnimation: 'idle',
        backgroundColor: Colors.black,
        onSuccess: (a) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: HomePage(),
            ),
          );
        },
        onError: (a, b) => {},
        isLoading: !isLoaded,
      ),
    );
  }
}
