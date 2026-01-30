import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/remote_keys.dart';
import '../../data/services/remote_config_service.dart';

/// Remote Config state - tüm değerler burada
class RemoteConfig {
  // Bool değerler
  final bool appInReview;
  final bool forceUpdate;
  final bool maintenanceMode;
  final bool adEnabled;

  // String değerler
  final String minVersion;
  final String privacyUrl;
  final String termsUrl;

  RemoteConfig({
    required this.appInReview,
    required this.forceUpdate,
    required this.maintenanceMode,
    required this.adEnabled,
    required this.minVersion,
    required this.privacyUrl,
    required this.termsUrl,
  });

  /// Default constructor
  factory RemoteConfig.defaults() {
    final d = RemoteKeys.defaults;
    return RemoteConfig(
      appInReview: d[RemoteKeys.appInReview] as bool,
      forceUpdate: d[RemoteKeys.forceUpdate] as bool,
      maintenanceMode: d[RemoteKeys.maintenanceMode] as bool,
      adEnabled: d[RemoteKeys.adEnabled] as bool,
      minVersion: d[RemoteKeys.minVersion] as String,
      privacyUrl: d[RemoteKeys.privacyUrl] as String,
      termsUrl: d[RemoteKeys.termsUrl] as String,
    );
  }

  /// Load from service
  factory RemoteConfig.fromService() {
    return RemoteConfig(
      appInReview: RemoteConfigService.getBool(RemoteKeys.appInReview),
      forceUpdate: RemoteConfigService.getBool(RemoteKeys.forceUpdate),
      maintenanceMode: RemoteConfigService.getBool(RemoteKeys.maintenanceMode),
      adEnabled: RemoteConfigService.getBool(RemoteKeys.adEnabled),
      minVersion: RemoteConfigService.getString(RemoteKeys.minVersion),
      privacyUrl: RemoteConfigService.getString(RemoteKeys.privacyUrl),
      termsUrl: RemoteConfigService.getString(RemoteKeys.termsUrl),
    );
  }

  // ==================== COMPUTED ====================

  /// Reklam gösterilsin mi? (review'da değilse ve ad aktifse)
  bool get showAds => adEnabled && !appInReview;
}

/// Remote Config Notifier
class RemoteConfigNotifier extends Notifier<RemoteConfig> {
  @override
  RemoteConfig build() => RemoteConfig.defaults();

  /// Load from Firebase
  void load() {
    state = RemoteConfig.fromService();
  }

  /// Refresh from Firebase
  Future<void> refresh() async {
    await RemoteConfigService.refresh();
    state = RemoteConfig.fromService();
  }
}

/// Remote Config Provider
final remoteConfigProvider = NotifierProvider<RemoteConfigNotifier, RemoteConfig>(
  RemoteConfigNotifier.new,
);
