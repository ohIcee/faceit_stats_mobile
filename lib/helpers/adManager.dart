import 'dart:math';

import 'package:flutter_native_admob/native_admob_controller.dart';

class adManager {

  static int _controllersToCreate = 4;
  static var _random = new Random();

  static var controllers = new List<NativeAdmobController>();

  static void Init() {
    regenerateAds();
  }

  static void regenerateAds() {
    reset();
    for(var i = 0; i < _controllersToCreate; i++) {
      controllers.add(new NativeAdmobController());
    }
  }

  static Future<void> reset() {
    controllers.forEach((element) => element.dispose());
    controllers.clear();
  }

  static get randomController => controllers[_random.nextInt(_controllersToCreate)];

}