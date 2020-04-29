import 'package:flutter/material.dart';

import 'package:faceit_stats/pages/home.dart';
import 'package:faceit_stats/pages/userDetails.dart';

import 'helpers/RemoteConfigManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
//  var isLoaded = false;
//
  @override
  void initState() {
    LoadApp();
    super.initState();
  }

  void LoadApp() async {
    await RemoteConfigManager.Init();
    // isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faceit Stats',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          brightness: Brightness.dark,
          accentColor: Colors.deepOrangeAccent),
      initialRoute: '/',
      routes: {
        HomePage.routeName: (context) => HomePage(),
        UserDetailPage.routeName: (context) => UserDetailPage(),
      },
    );
  }

//  Widget buildLoading() {
//    return Scaffold(
//      body: Center(
//        child: Text("Loading app..."),
//      ),
//    );
//  }
}
