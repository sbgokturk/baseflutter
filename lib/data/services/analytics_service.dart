import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../config/env.dart';
import 'analytics_platform_io.dart'
    if (dart.library.html) 'analytics_platform_stub.dart'
    as platform;

/// Dual analytics: Firebase Analytics + Custom REST API.
/// Every event carries context: time (local, timezone, hour), identity (userId, is_pro), device (platform, appVersion, country).
/// Platform is also sent in metadata.
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  final http.Client _httpClient = http.Client();

  String? _appVersion;
  String? _platform;
  String? _userId;
  bool _isPremium = false;
  bool _initialized = false;

  /// Call once at app start (after Firebase init).
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
      _platform = platform.getAnalyticsPlatform();
      _initialized = true;
      debugPrint('✅ [Analytics] Service initialized');
    } catch (e) {
      debugPrint('❌ [Analytics] Init failed: $e');
    }
  }

  /// Call when login state or premium status changes.
  void updateUserData({String? userId, bool? isPremium}) {
    if (userId != null) _userId = userId;
    if (isPremium != null) _isPremium = isPremium;
    debugPrint('📊 [Analytics] User context: ID=$_userId, Pro=$_isPremium');
  }

  /// Logs to both Firebase and Custom API with full context. Platform included in metadata.
  Future<void> log(String name, [Map<String, dynamic>? parameters]) async {
    if (!_initialized) await initialize();

    final now = DateTime.now();
    final timezoneOffset = now.timeZoneOffset;
    final timezoneHours = timezoneOffset.inMinutes / 60;
    final timezoneString = timezoneOffset.isNegative
        ? 'UTC${timezoneHours.toStringAsFixed(1)}'
        : 'UTC+${timezoneHours.toStringAsFixed(1)}';

    final enrichedParams = Map<String, dynamic>.from(parameters ?? {});
    enrichedParams['is_pro'] = _isPremium;
    enrichedParams['timezone'] = timezoneString;
    enrichedParams['local_hour'] =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    await Future.wait([
      _logToFirebase(name, enrichedParams),
      _logToCustomApi(name, enrichedParams, now, timezoneString),
    ]);
  }

  Future<void> _logToFirebase(String name, Map<String, dynamic> params) async {
    try {
      const eventPrefix = 'app_';
      final eventName = '$eventPrefix$name';
      final converted = <String, Object>{};
      params.forEach((key, value) {
        if (value is String || value is num) {
          converted[key] = value as Object;
        } else {
          converted[key] = value.toString();
        }
      });
      await _firebaseAnalytics.logEvent(name: eventName, parameters: converted);
    } catch (e) {
      debugPrint('⚠️ [Analytics] Firebase failed: $e');
    }
  }

  Future<void> _logToCustomApi(
    String name,
    Map<String, dynamic> params,
    DateTime now,
    String timezoneString,
  ) async {
    if (Env.analyticsCustomApiUrl.isEmpty) return;
    try {
      final userId =
          _userId ?? FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final country = platform.getAnalyticsLocaleCountry();

      final body = {
        'appId': Env.analyticsAppId,
        'userId': userId,
        'eventName': name,
        'platform': _platform ?? 'unknown',
        'appVersion': _appVersion ?? 'unknown',
        'eventData': params,
        'country': country,
        'timestamp': now.toUtc().toIso8601String(),
        'localTime': now.toIso8601String(),
        'timezone': timezoneString,
        'localHour': now.hour,
        'metadata': {
          'platform': _platform ?? 'unknown',
          'appVersion': _appVersion ?? 'unknown',
          'country': country,
        },
      };

      await _httpClient.post(
        Uri.parse(Env.analyticsCustomApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
    } catch (e) {
      debugPrint('⚠️ [Analytics] Custom API failed: $e');
    }
  }

  Future<void> logButtonClick(
    String buttonName, {
    String? pageName,
    Map<String, dynamic>? extras,
  }) async {
    await log('button_click', {
      'button_name': buttonName,
      if (pageName != null) 'page_name': pageName,
      ...?extras,
    });
  }

  Future<void> logPageView(String pageName) async {
    await _firebaseAnalytics.logScreenView(screenName: pageName);
    await log('screen_view', {'screen_name': pageName});
  }
}
