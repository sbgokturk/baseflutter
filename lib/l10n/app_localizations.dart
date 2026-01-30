import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Base'**
  String get welcomeMessage;

  /// Label for current user id.
  ///
  /// In en, this message translates to:
  /// **'User ID: {id}'**
  String userIdLabel(String id);

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @remoteConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Remote Config'**
  String get remoteConfigTitle;

  /// Shown when a route is not found.
  ///
  /// In en, this message translates to:
  /// **'Route not found: {route}'**
  String routeNotFound(String route);

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @initStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get initStarting;

  /// No description provided for @initConnectingFirebase.
  ///
  /// In en, this message translates to:
  /// **'Connecting to Firebase...'**
  String get initConnectingFirebase;

  /// No description provided for @initLoadingLocalData.
  ///
  /// In en, this message translates to:
  /// **'Loading local data...'**
  String get initLoadingLocalData;

  /// No description provided for @initFetchingRemoteConfig.
  ///
  /// In en, this message translates to:
  /// **'Fetching remote config...'**
  String get initFetchingRemoteConfig;

  /// No description provided for @initLoadingTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Loading time schedules...'**
  String get initLoadingTimeSlots;

  /// No description provided for @initCheckingAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get initCheckingAuthentication;

  /// No description provided for @initReady.
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get initReady;

  /// No description provided for @initRetrying.
  ///
  /// In en, this message translates to:
  /// **'Retrying...'**
  String get initRetrying;

  /// No description provided for @timeSlotTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Slot Test'**
  String get timeSlotTestTitle;

  /// No description provided for @timeSlotServerTime.
  ///
  /// In en, this message translates to:
  /// **'Server Time'**
  String get timeSlotServerTime;

  /// No description provided for @timeSlotCurrentTime.
  ///
  /// In en, this message translates to:
  /// **'Current Time (HHMM)'**
  String get timeSlotCurrentTime;

  /// No description provided for @timeSlotRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get timeSlotRefresh;

  /// No description provided for @timeSlotLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get timeSlotLoading;

  /// Time slot number label.
  ///
  /// In en, this message translates to:
  /// **'Slot {number}'**
  String timeSlotSlotNumber(int number);

  /// No description provided for @timeSlotStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timeSlotStartTime;

  /// No description provided for @timeSlotEndTime.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get timeSlotEndTime;

  /// No description provided for @timeSlotType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get timeSlotType;

  /// No description provided for @timeSlotPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get timeSlotPackage;

  /// No description provided for @timeSlotStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get timeSlotStatus;

  /// No description provided for @timeSlotActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get timeSlotActive;

  /// No description provided for @timeSlotInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get timeSlotInactive;

  /// No description provided for @timeSlotDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get timeSlotDisabled;

  /// No description provided for @timeSlotActiveSlots.
  ///
  /// In en, this message translates to:
  /// **'Active Slots'**
  String get timeSlotActiveSlots;

  /// No description provided for @timeSlotAllSlots.
  ///
  /// In en, this message translates to:
  /// **'All Slots'**
  String get timeSlotAllSlots;

  /// No description provided for @timeSlotNoActiveSlots.
  ///
  /// In en, this message translates to:
  /// **'No active slots at this time'**
  String get timeSlotNoActiveSlots;

  /// Error message for time slot.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String timeSlotError(String error);

  /// No description provided for @openTimeSlotTest.
  ///
  /// In en, this message translates to:
  /// **'Open Time Slot Test'**
  String get openTimeSlotTest;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
