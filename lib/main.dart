import 'package:faceit_stats/helpers/analytics.dart';
import 'package:faceit_stats/pages/UserSearch/MatchDetailPage.dart';
import 'package:faceit_stats/pages/appLoader.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:faceit_stats/pages/home.dart';
import 'package:faceit_stats/pages/UserSearch/userDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {

  @override
  void initState() {
    analytics.Init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(255, 85, 0, 1),
      systemNavigationBarColor: Color.fromRGBO(20, 22, 22, 1),
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Faceit Stats',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
        accentColor: Colors.deepOrangeAccent,
        textTheme: GoogleFonts.playTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 37, 37, 1),
      ),
      initialRoute: '/appLoader',
      routes: {
        AppLoaderPage.routeName: (context) => AppLoaderPage(),
        HomePage.routeName: (context) => HomePage(),
        UserDetailPage.routeName: (context) => UserDetailPage(),
        MatchDetailPage.routeName: (context) => MatchDetailPage(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics.fb_analytics),
      ],
    );
  }
}
