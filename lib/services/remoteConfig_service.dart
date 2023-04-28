import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  Future<FirebaseRemoteConfig> initialize() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 0),
    ));
    RemoteConfigValue(null, ValueSource.valueStatic);
    remoteConfig.ensureInitialized();
    await remoteConfig.fetchAndActivate();
    return remoteConfig;
  }
}
