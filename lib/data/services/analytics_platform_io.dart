import 'dart:io' show Platform;

String getAnalyticsPlatform() {
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  return 'other';
}

String getAnalyticsLocaleCountry() {
  return Platform.localeName.split('_').last;
}
