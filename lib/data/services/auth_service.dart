import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Auth service - Anonymous Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== GETTERS ====================

  /// Current user
  User? get currentUser => _auth.currentUser;

  /// Current user ID
  String? get userId => _auth.currentUser?.uid;

  /// Is user logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== ANONYMOUS AUTH ====================

  /// Sign in anonymously
  Future<User?> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return result.user;
  }

  // ==================== SIGN OUT ====================

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ==================== ACCOUNT ====================

  /// Delete account
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}
