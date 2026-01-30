import 'package:flutter/material.dart';
import 'package:base/l10n/app_localizations.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/time_slot_test_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String timeSlotTest = '/time-slot-test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case timeSlotTest:
        return MaterialPageRoute(builder: (_) => const TimeSlotTestScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.routeNotFound(settings.name ?? ''),
              ),
            ),
          ),
        );
    }
  }
}
