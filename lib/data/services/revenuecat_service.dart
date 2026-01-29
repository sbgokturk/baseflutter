import 'package:purchases_flutter/purchases_flutter.dart';

import 'revenuecat_api_key_io.dart'
    if (dart.library.html) 'revenuecat_api_key_stub.dart'
    as rc_key;

/// RevenueCat SDK wrapper. appUserID is always set to our app user id (Firebase Auth uid).
class RevenueCatService {
  static bool _configured = false;

  /// Configure RevenueCat once with [appUserID] = our user id (Firebase uid).
  /// Call after auth so RevenueCat ID matches app user id.
  static Future<void> configure(String appUserID) async {
    if (_configured) {
      await Purchases.logIn(appUserID);
      return;
    }

    final apiKey = rc_key.getRevenueCatApiKey();
    if (apiKey.isEmpty) return;

    final configuration = PurchasesConfiguration(apiKey)..appUserID = appUserID;

    await Purchases.configure(configuration);
    _configured = true;
  }
}
