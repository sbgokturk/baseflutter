import 'package:firebase_core/firebase_core.dart';

/// Firebase initialization service
class FirebaseService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    
    await Firebase.initializeApp();
    _initialized = true;
  }

  static bool get isInitialized => _initialized;
}
