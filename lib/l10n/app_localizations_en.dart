// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Base';

  @override
  String get welcomeMessage => 'Welcome to Base';

  @override
  String userIdLabel(String id) {
    return 'User ID: $id';
  }

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get remoteConfigTitle => 'Remote Config';

  @override
  String routeNotFound(String route) {
    return 'Route not found: $route';
  }

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Turkish';

  @override
  String get initStarting => 'Starting...';

  @override
  String get initConnectingFirebase => 'Connecting to Firebase...';

  @override
  String get initLoadingLocalData => 'Loading local data...';

  @override
  String get initFetchingRemoteConfig => 'Fetching remote config...';

  @override
  String get initCheckingAuthentication => 'Checking authentication...';

  @override
  String get initReady => 'Ready!';

  @override
  String get initRetrying => 'Retrying...';
}
