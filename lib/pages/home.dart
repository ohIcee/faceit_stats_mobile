import 'package:faceit_stats/helpers/FavouritesManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:faceit_stats/appBar.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userSearchInputController = TextEditingController();

  var isLoaded = false;
  var favouritesLoaded = false;

  @override
  void initState() {
    loadApp();
    super.initState();
  }

  @override
  void dispose() {
    userSearchInputController.dispose();
    super.dispose();
  }

  void loadApp() async {
    await RemoteConfigManager.Init();
    await FavouritesManager.Init();
    setState(() {
      isLoaded = true;
      favouritesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 22, 22, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(),
            searchSection(),
          ],
        ),
      ),
    );
  }

  Widget searchSection() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: userSearchInputController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: "User ID",
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  "Search",
                ),
                onPressed: isLoaded ? searchUser : null,
              ),
            ),
            Text("bruh"),
            favouritesLoaded ? Container(
              height: 250.0,
              child: ListView.builder(
                itemCount: FavouritesManager.loadedFavourites.length,
                itemBuilder: (context, index) {
                  return Text(
                    FavouritesManager.loadedFavourites[index].nickname
                  );
                },
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> searchUser() async {
    HapticFeedback.selectionClick();
    setState(() => isLoaded = false);
    MatchHistory.ResetMatchHistory();

    var username = userSearchInputController.text;
    await PlayerSearch.GetUserGameDetails(username, "csgo");
    await MatchHistory.LoadNext(20);
    setState(() => isLoaded = true);
    HapticFeedback.vibrate();
    Navigator.pushNamed(context, '/userDetails');
  }
}
