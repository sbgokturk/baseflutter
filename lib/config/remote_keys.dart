/// Remote Config keys and default values
class RemoteKeys {
  // Key isimleri (Firebase'deki key adları)
  static const String appInReview = 'app_in_review';
  static const String forceUpdate = 'force_update';
  static const String maintenanceMode = 'maintenance_mode';
  static const String adEnabled = 'ad_enabled';
  static const String minVersion = 'min_version';
  static const String privacyUrl = 'privacy_url';
  static const String termsUrl = 'terms_url';

  // Default değerler (Firebase'e ulaşılamazsa kullanılır)
  static const Map<String, dynamic> defaults = {
    appInReview: false,
    forceUpdate: false,
    maintenanceMode: false,
    adEnabled: true,
    minVersion: '1.0.0',
    privacyUrl: 'https://example.com/privacy',
    termsUrl: 'https://example.com/terms',
  };
}
