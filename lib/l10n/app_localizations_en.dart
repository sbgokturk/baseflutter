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
  String get initLoadingTimeSlots => 'Loading time schedules...';

  @override
  String get initCheckingAuthentication => 'Checking authentication...';

  @override
  String get initReady => 'Ready!';

  @override
  String get initRetrying => 'Retrying...';

  @override
  String get timeSlotTestTitle => 'Time Slot Test';

  @override
  String get timeSlotServerTime => 'Server Time';

  @override
  String get timeSlotCurrentTime => 'Current Time (HHMM)';

  @override
  String get timeSlotRefresh => 'Refresh';

  @override
  String get timeSlotLoading => 'Loading...';

  @override
  String timeSlotSlotNumber(int number) {
    return 'Slot $number';
  }

  @override
  String get timeSlotStartTime => 'Start';

  @override
  String get timeSlotEndTime => 'End';

  @override
  String get timeSlotType => 'Type';

  @override
  String get timeSlotPackage => 'Package';

  @override
  String get timeSlotStatus => 'Status';

  @override
  String get timeSlotActive => 'ACTIVE';

  @override
  String get timeSlotInactive => 'Inactive';

  @override
  String get timeSlotDisabled => 'Disabled';

  @override
  String get timeSlotActiveSlots => 'Active Slots';

  @override
  String get timeSlotAllSlots => 'All Slots';

  @override
  String get timeSlotNoActiveSlots => 'No active slots at this time';

  @override
  String timeSlotError(String error) {
    return 'Error: $error';
  }

  @override
  String get openTimeSlotTest => 'Open Time Slot Test';
}
