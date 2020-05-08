import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:flutter/material.dart';

import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/models/user.dart';

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

  @override
  void initState() {
    LoadApp();
    super.initState();
  }

  @override
  void dispose() {
    userSearchInputController.dispose();
    super.dispose();
  }

  void LoadApp() async {
    await RemoteConfigManager.Init();
    setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          appBar(),
          searchSection(),
        ],
      )),
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
                onPressed: isLoaded ? SearchUser : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> SearchUser() async {
    setState(() => isLoaded = false);
    MatchHistory.ResetMatchHistory();

    print("Searching user " + userSearchInputController.text);
    var username = userSearchInputController.text;
    User user = await PlayerSearch.GetUserGameDetails(username, "csgo");
    await MatchHistory.LoadNext(2);
    setState(() => isLoaded = true);
    Navigator.pushNamed(context, '/userDetails',
        arguments: user);
  }

  Widget appBar() {
    return Container(
      alignment: Alignment.center,
      height: 75.0,
      child: Text(
        "Faceit Stats",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
