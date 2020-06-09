import 'package:cached_network_image/cached_network_image.dart';
import 'package:faceit_stats/appBar.dart';
import 'package:faceit_stats/helpers/FavouritesManager.dart';
import 'package:faceit_stats/helpers/adManager.dart';
import 'package:faceit_stats/helpers/analytics.dart';
import 'package:faceit_stats/helpers/enums.dart';
import 'package:faceit_stats/models/Favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:faceit_stats/api/PlayerSearch.dart';
import 'package:faceit_stats/api/MatchHistory.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userSearchInputController = TextEditingController();

  var isLoaded = true;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    analytics.requestConsent();
    super.initState();
  }

  @override
  void dispose() {
    userSearchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainAppBar(
        appBar: AppBar(),
        leading: Container(),
        widgets: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
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
      child: Image.asset(
        "assets/FS_ICON.png",
      ),
    );
  }

  Widget searchSection() {
    var favList = <Widget>[];

    if (FavouritesManager.loadedFavourites.length > 0) {
      var favourites = List<Favourite>();
      FavouritesManager.loadedFavourites.forEach((e) => favourites
          .add(Favourite(nickname: e.nickname, avatarUrl: e.avatarUrl)));
      favourites.forEach((e) => favList.add(_buildFavouriteTile(e)));
    }

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
                decoration: InputDecoration(hintText: "Enter username here.."),
              ),
              SizedBox(height: 15.0),
              SizedBox(
                width: double.infinity,
                height: 45.0,
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
              SizedBox(height: 10.0),
              Container(
                child: FavouritesManager.loadedFavourites.length > 0
                    ? Column(
                        children: favList,
                      )
                    : Text("No favourites!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteTile(Favourite fav) {
    return Card(
      //color: Colors.white10.withOpacity(.05),
      color: Colors.transparent,
      elevation: 0.0,
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
                    child: CachedNetworkImage(
                      imageUrl: fav.avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => LinearProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                  color: Theme.of(context).accentColor,
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
    debugPrint(isLoaded.toString());
    if (isLoaded == false) return;

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
    adManager.InitBannerAd();

    await MatchHistory.LoadNext();
    setState(() => isLoaded = true);
    HapticFeedback.vibrate();

    await Navigator.pushNamed(context, '/userDetails');

    adManager.disposeAds();

    // If we need to refresh the favourites, set state
    // to refresh page data
    // (Executes after coming back from userDetails page)
    if (FavouritesManager.refreshNeeded) setState(() {});
  }

  void showSnackbar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
