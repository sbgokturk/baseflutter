import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void useSystem() => state = null;

  void setEnglish() => state = const Locale('en');

  void setTurkish() => state = const Locale('tr');
}

/// UI bu provider üzerinden mevcut dili/locale'i okur ve değiştirir.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
