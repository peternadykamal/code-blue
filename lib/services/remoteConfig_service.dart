import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  void initialize() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    RemoteConfigValue(null, ValueSource.valueStatic);
    await remoteConfig.fetchAndActivate();
  }
}
