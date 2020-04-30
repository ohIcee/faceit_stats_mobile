import 'package:flutter/material.dart';

import 'package:faceit_stats/pages/home.dart';
import 'package:faceit_stats/pages/userDetails.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faceit Stats',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
        accentColor: Colors.deepOrangeAccent,
        textTheme: GoogleFonts.playTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        HomePage.routeName: (context) => HomePage(),
        UserDetailPage.routeName: (context) => UserDetailPage(),
      },
    );
  }
}
