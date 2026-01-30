import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../../config/remote_keys.dart';

/// Remote Config service
class RemoteConfigService {
  static final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;
  static bool _initialized = false;

  /// Initialize Remote Config
  static Future<void> init() async {
    if (_initialized) return;

    // Default değerleri ayarla
    await _config.setDefaults(RemoteKeys.defaults);

    // Fetch ayarları
    // Debug modda hemen çek, production'da 1 saat bekle
    await _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(minutes: 2),
      ),
    );

    // Firebase'den çek
    try {
      await _config.fetchAndActivate();
    } catch (_) {}

    _initialized = true;
  }

  /// Refresh values
  static Future<void> refresh() async {
    try {
      await _config.fetchAndActivate();
    } catch (_) {}
  }

  // ==================== GETTERS ====================

  static bool getBool(String key) => _config.getBool(key);
  static String getString(String key) => _config.getString(key);
  static int getInt(String key) => _config.getInt(key);
  static double getDouble(String key) => _config.getDouble(key);
}
