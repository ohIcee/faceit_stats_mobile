import 'package:faceit_stats/helpers/FavouritesManager.dart';
import 'package:faceit_stats/helpers/enums.dart';
import 'package:faceit_stats/models/Favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/api/MatchHistory.dart';
import 'package:faceit_stats/helpers/RemoteConfigManager.dart';
import 'package:faceit_stats/appBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(20, 22, 22, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(backButton: false),
            searchSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      margin: EdgeInsets.only(
        top: 50.0,
        bottom: 20.0,
        left: 90.0,
        right: 90.0,
      ),
      child: SvgPicture.asset(
        "assets/faceit_logo.svg",
        semanticsLabel: "Faceit Logo",
        color: Colors.deepOrange,
      ),
    );
  }

  Widget searchSection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildImage(),
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
              SizedBox(height: 20.0),
              Text(
                "Favourites",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              favouritesLoaded
                  ? Container(
                      height: 250.0,
                      child: FavouritesManager.loadedFavourites.length > 0
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  FavouritesManager.loadedFavourites.length,
                              itemBuilder: (context, index) {
                                return _buildFavouriteTile(
                                    FavouritesManager.loadedFavourites[index]);
                              },
                            )
                          : Text("No favourites!"),
                    )
                  : Text("Loading favourites..."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteTile(Favourite fav) {
    return Card(
      color: Colors.white10.withOpacity(.05),
      elevation: 1.0,
      child: InkWell(
        onTap: () => searchUser(username: fav.nickname),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          height: 80.0,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                child: ClipOval(
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    child: Image.network(
                      fav.avatarUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                fav.nickname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => unFavourite(fav.nickname),
                icon: Icon(
                  Icons.favorite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void unFavourite(String nickname) async {
    await FavouritesManager.removeFavourite(nickname);
    setState(() {});
  }

  Future<void> searchUser({String username}) async {
    HapticFeedback.selectionClick();
    setState(() => isLoaded = false);
    MatchHistory.ResetMatchHistory();

    if (username == null) username = userSearchInputController.text;
    var response = await PlayerSearch.GetUserGameDetails(username, "csgo");
    if (response == null) {
      if (PlayerSearch.lastAPIResponse == API_RESPONSES.CSGO_NOT_FOUND)
        showSnackbar("User does not have any CSGO information");
      else if (PlayerSearch.lastAPIResponse == API_RESPONSES.FAIL_RETRIEVE)
        showSnackbar("User does not exist");

      setState(() {
        isLoaded = true;
      });
      return;
    }
    await MatchHistory.LoadNext(20);
    setState(() => isLoaded = true);
    HapticFeedback.vibrate();
    Navigator.pushNamed(context, '/userDetails');
  }

  void showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
