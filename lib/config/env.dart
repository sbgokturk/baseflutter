class Env {
  static const String appName = 'Base';
  static const String baseUrl = 'https://api.example.com';
  static const bool isProduction = false;

  /// RevenueCat public API keys (from RevenueCat dashboard → API keys).
  static const String revenueCatApiKeyApple = '';
  static const String revenueCatApiKeyGoogle = '';

  /// Dual Analytics: app id for custom backend events.
  static const String analyticsAppId = 'base';

  /// Custom analytics API (e.g. Cloud Function) – empty = skip custom logging.
  static const String analyticsCustomApiUrl = '';
}
