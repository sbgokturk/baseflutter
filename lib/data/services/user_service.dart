import '../models/user_model.dart';
import '../../config/collections.dart';
import 'firestore_service.dart';

/// User document in Firestore. Ensures anonymous user is written with createdAt/updatedAt.
class UserService {
  final FirestoreService _firestore = FirestoreService();

  /// Create user doc if it doesn't exist. Call after anonymous sign-in.
  Future<void> ensureUserDocument(String uid) async {
    final existing = await _firestore.get(Collections.users, uid);
    if (existing != null) return;

    final user = UserModel(
      id: uid,
      name: null,
      email: null,
      isAnonymous: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _firestore.set(Collections.users, uid, user.toJson());
  }

  /// Get user document from Firestore.
  Future<UserModel?> getUser(String uid) async {
    final data = await _firestore.get(Collections.users, uid);
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  /// Update user fields (updatedAt set by FirestoreService).
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.update(Collections.users, uid, data);
  }
}
