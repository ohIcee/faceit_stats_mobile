import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'package:faceit_stats/models/Favourite.dart';

class FavouritesManager {
  static final String _fileName = "favourites.json";
  static String filePath;
  static File file;

  static List<Favourite> loadedFavourites;

  static Future<void> Init() async {
    loadedFavourites = new List<Favourite>();
    filePath = await _localPath;
    file = await _localFile;

    var favourites = await readFavouriteRaw();
    if (favourites == null) {
      file.writeAsString('');
    }

    await loadFavourites();
    debugPrint("Loaded favourites!");
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    return File('$filePath/$_fileName');
  }

  static Future<File> addFavourite(String nickname) async {
    List<dynamic> nicknames = new List<dynamic>();

    // READ FAVOURITES AND DECODE THEM IF AVAILABLE
    var content = await readFavouriteRaw();
    if (content != "" && content != null) {
      var decoded = jsonDecode(content);
      nicknames = decoded["favourites"];
    }

    // store previous stored into list
    List<Map<String, dynamic>> previousFavs = new List<Map<String, dynamic>>();
    nicknames.forEach((nick) =>
        previousFavs.add(Favourite(nickname: nick["nickname"]).toJson()));

    // WRITE FAVOURITE TO FILE
    var newFav = Favourite(nickname: nickname);
    previousFavs.add(newFav.toJson());
    Map<String, dynamic> temp = {'"favourites"': previousFavs};

    await file.writeAsString('$temp');
  }

  static Future<void> Clear() async {
    await file.writeAsString('');
    debugPrint("CLEARED");
  }

  static Future<void> loadFavourites() async {
    // READ FAVOURITES AND DECODE THEM
    var content = await readFavouriteRaw();
    if (content == "" || content == null) {
      debugPrint("Nothing to load.");
      return;
    }
    var decoded = jsonDecode(content);
    debugPrint(decoded.toString());
    List<dynamic> nicknames = decoded["favourites"];

    // store stored into list
    List<Favourite> favs = new List<Favourite>();
    nicknames
        .forEach((nick) => favs.add(Favourite(nickname: nick["nickname"])));

    loadedFavourites = favs;
  }

  static Future<void> removeFavourite(String nickname) async {
    // READ FAVOURITES AND DECODE THEM
    var content = await readFavouriteRaw();
    if (content == "" || content == null) {
      debugPrint("Nothing to remove.");
      return;
    }
    var decoded = jsonDecode(content);
    List<dynamic> nicknames = decoded["favourites"];

    // store previous stored into list
    List<Favourite> previousFavs = new List<Favourite>();
    nicknames.forEach(
        (nick) => previousFavs.add(Favourite(nickname: nick["nickname"])));

    // Remove favourite
    previousFavs.removeWhere((e) => e.nickname == nickname);

    List<Map<String, dynamic>> newFavs = new List<Map<String, dynamic>>();
    previousFavs.forEach((e) => newFavs.add(e.toJson()));

    Map<String, dynamic> temp = {'"favourites"': newFavs};

    await file.writeAsString('$temp');
  }

  static Future<bool> favouriteExists(String nickname) async {
    // READ FAVOURITES AND DECODE THEM
    var content = await readFavouriteRaw();
    if (content == "" || content == null) {
      debugPrint("Nothing to search.");
      return false;
    }
    var decoded = jsonDecode(content);
    List<dynamic> nicknames = decoded["favourites"];

    return nicknames.any((nick) => nick["nickname"] == nickname);
  }

  static Future<String> readFavouriteRaw() async {
    try {
      // Read the file.
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }
}