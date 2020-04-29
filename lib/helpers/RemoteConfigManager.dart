import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigManager {

  static RemoteConfig _remoteConfig;

  static Future<bool> Init() async {
    _remoteConfig = await RemoteConfig.instance;
    await _remoteConfig.fetch(expiration: Duration(hours: 1));
    await _remoteConfig.activateFetched();
    print("Loaded remote config!");
    return true;
  }

  static dynamic getConfigValue(String key) {
    return _remoteConfig.getValue(key).asString();
  }

}