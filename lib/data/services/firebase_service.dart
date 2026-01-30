import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Firebase initialization service. Call from main() before runApp().
class FirebaseService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
  }

  static bool get isInitialized => _initialized;
}
