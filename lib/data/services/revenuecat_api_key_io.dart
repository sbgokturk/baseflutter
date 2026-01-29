import 'dart:io' show Platform;

import '../../config/env.dart';

String getRevenueCatApiKey() {
  return Platform.isIOS
      ? Env.revenueCatApiKeyApple
      : Env.revenueCatApiKeyGoogle;
}
