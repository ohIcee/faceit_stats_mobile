import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FavouritesManager {


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/favourites.json');
  }

  Future<File> writeFavourite(int username) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$username');
  }

  Future<int> readFavourite() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0.
      return 0;
    }
  }

}