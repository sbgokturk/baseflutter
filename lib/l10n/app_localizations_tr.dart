// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Base';

  @override
  String get welcomeMessage => 'Base\'e Hoş Geldiniz';

  @override
  String userIdLabel(String id) {
    return 'Kullanıcı ID: $id';
  }

  @override
  String get notLoggedIn => 'Giriş yapılmadı';

  @override
  String get remoteConfigTitle => 'Remote Config';

  @override
  String routeNotFound(String route) {
    return 'Sayfa bulunamadı: $route';
  }

  @override
  String get errorTitle => 'Bir şeyler ters gitti';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get language => 'Dil';

  @override
  String get systemLanguage => 'Sistem';

  @override
  String get english => 'İngilizce';

  @override
  String get turkish => 'Türkçe';

  @override
  String get initStarting => 'Başlatılıyor...';

  @override
  String get initConnectingFirebase => 'Firebase\'e bağlanılıyor...';

  @override
  String get initLoadingLocalData => 'Yerel veriler yükleniyor...';

  @override
  String get initFetchingRemoteConfig => 'Remote config çekiliyor...';

  @override
  String get initLoadingTimeSlots => 'Zaman çizelgeleri yükleniyor...';

  @override
  String get initCheckingAuthentication => 'Kimlik doğrulama kontrol ediliyor...';

  @override
  String get initReady => 'Hazır!';

  @override
  String get initRetrying => 'Tekrar deneniyor...';

  @override
  String get timeSlotTestTitle => 'Zaman Slotu Test';

  @override
  String get timeSlotServerTime => 'Sunucu Zamanı';

  @override
  String get timeSlotCurrentTime => 'Şuanki Zaman (HHMM)';

  @override
  String get timeSlotRefresh => 'Yenile';

  @override
  String get timeSlotLoading => 'Yükleniyor...';

  @override
  String timeSlotSlotNumber(int number) {
    return 'Slot $number';
  }

  @override
  String get timeSlotStartTime => 'Başlangıç';

  @override
  String get timeSlotEndTime => 'Bitiş';

  @override
  String get timeSlotType => 'Tip';

  @override
  String get timeSlotPackage => 'Paket';

  @override
  String get timeSlotStatus => 'Durum';

  @override
  String get timeSlotActive => 'AKTİF';

  @override
  String get timeSlotInactive => 'Pasif';

  @override
  String get timeSlotDisabled => 'Devre Dışı';

  @override
  String get timeSlotActiveSlots => 'Aktif Slotlar';

  @override
  String get timeSlotAllSlots => 'Tüm Slotlar';

  @override
  String get timeSlotNoActiveSlots => 'Şu an aktif slot yok';

  @override
  String timeSlotError(String error) {
    return 'Hata: $error';
  }

  @override
  String get openTimeSlotTest => 'Zaman Slotu Testini Aç';
}
