/// Remote Config key'leri (kısa, Firebase'de bu isimlerle tanımlanır).
/// Anlamları uygulama içinde property isimleriyle açılıyor (appInReview, forceUpdate vb.).
class RemoteKeys {
  static const String appInReview = 'air';
  static const String forceUpdate = 'fu';
  static const String maintenanceMode = 'mm';
  static const String adEnabled = 'ae';
  static const String minVersion = 'mv';
  static const String privacyUrl = 'pu';
  static const String termsUrl = 'tu';

  // ==================== TIME-BASED SCHEDULING ====================
  // st = startTime (HHMM format, örn: 1100 = 11:00, 2300 = 23:00)
  // et = endTime (HHMM format, örn: 1200 = 12:00, 0600 = 06:00)
  // t = type (örn: st1t = startTime1Type)
  // p = package (örn: st1p = startTime1Package)
  //
  // Örnek: st1=1100, et1=1200, st1t="promo", st1p="banner1"
  //        → Saat 11:00-12:00 arası "promo" tipi ve "banner1" package aktif
  // Gece geçişi: st1=2300, et1=0600 → 23:00-06:00 arası aktif

  // Schedule 1: st1=startTime1, et1=endTime1, st1t=startTime1Type, st1p=startTime1Package
  static const String startTime1 = 'st1';
  static const String endTime1 = 'et1';
  static const String startTime1Type = 'st1t';
  static const String startTime1Package = 'st1p';

  // Schedule 2: st2=startTime2, et2=endTime2, st2t=startTime2Type, st2p=startTime2Package
  static const String startTime2 = 'st2';
  static const String endTime2 = 'et2';
  static const String startTime2Type = 'st2t';
  static const String startTime2Package = 'st2p';

  // Schedule 3
  static const String startTime3 = 'st3';
  static const String endTime3 = 'et3';
  static const String startTime3Type = 'st3t';
  static const String startTime3Package = 'st3p';

  // Schedule 4
  static const String startTime4 = 'st4';
  static const String endTime4 = 'et4';
  static const String startTime4Type = 'st4t';
  static const String startTime4Package = 'st4p';

  // Schedule 5
  static const String startTime5 = 'st5';
  static const String endTime5 = 'et5';
  static const String startTime5Type = 'st5t';
  static const String startTime5Package = 'st5p';

  // Schedule 6
  static const String startTime6 = 'st6';
  static const String endTime6 = 'et6';
  static const String startTime6Type = 'st6t';
  static const String startTime6Package = 'st6p';

  // Schedule 7
  static const String startTime7 = 'st7';
  static const String endTime7 = 'et7';
  static const String startTime7Type = 'st7t';
  static const String startTime7Package = 'st7p';

  // Schedule 8
  static const String startTime8 = 'st8';
  static const String endTime8 = 'et8';
  static const String startTime8Type = 'st8t';
  static const String startTime8Package = 'st8p';

  // Schedule 9
  static const String startTime9 = 'st9';
  static const String endTime9 = 'et9';
  static const String startTime9Type = 'st9t';
  static const String startTime9Package = 'st9p';

  static const Map<String, dynamic> defaults = {
    appInReview: false,
    forceUpdate: false,
    maintenanceMode: false,
    adEnabled: true,
    minVersion: '1.0.0',
    privacyUrl: 'https://example.com/privacy',
    termsUrl: 'https://example.com/terms',

    // Time-based scheduling defaults (0 = disabled)
    startTime1: 0,
    endTime1: 0,
    startTime1Type: '',
    startTime1Package: '',

    startTime2: 0,
    endTime2: 0,
    startTime2Type: '',
    startTime2Package: '',

    startTime3: 0,
    endTime3: 0,
    startTime3Type: '',
    startTime3Package: '',

    startTime4: 0,
    endTime4: 0,
    startTime4Type: '',
    startTime4Package: '',

    startTime5: 0,
    endTime5: 0,
    startTime5Type: '',
    startTime5Package: '',

    startTime6: 0,
    endTime6: 0,
    startTime6Type: '',
    startTime6Package: '',

    startTime7: 0,
    endTime7: 0,
    startTime7Type: '',
    startTime7Package: '',

    startTime8: 0,
    endTime8: 0,
    startTime8Type: '',
    startTime8Package: '',

    startTime9: 0,
    endTime9: 0,
    startTime9Type: '',
    startTime9Package: '',
  };
}
