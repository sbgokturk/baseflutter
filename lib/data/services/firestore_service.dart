import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore service for CRUD operations
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== CREATE ====================
  
  /// Add document with auto-generated ID
  Future<String> add(String collection, Map<String, dynamic> data) async {
    final doc = await _db.collection(collection).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Set document with custom ID
  Future<void> set(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== READ ====================

  /// Get single document by ID
  Future<Map<String, dynamic>?> get(String collection, String docId) async {
    final doc = await _db.collection(collection).doc(docId).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  /// Get all documents in collection
  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    final snapshot = await _db.collection(collection).get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  /// Get documents with query
  Future<List<Map<String, dynamic>>> query(
    String collection, {
    String? field,
    dynamic isEqualTo,
    dynamic isGreaterThan,
    dynamic isLessThan,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _db.collection(collection);

    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    if (field != null && isGreaterThan != null) {
      query = query.where(field, isGreaterThan: isGreaterThan);
    }
    if (field != null && isLessThan != null) {
      query = query.where(field, isLessThan: isLessThan);
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  // ==================== UPDATE ====================

  /// Update document fields
  Future<void> update(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== DELETE ====================

  /// Delete document
  Future<void> delete(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }

  // ==================== STREAMS ====================

  /// Stream single document
  Stream<Map<String, dynamic>?> streamDoc(String collection, String docId) {
    return _db.collection(collection).doc(docId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return {'id': doc.id, ...doc.data()!};
    });
  }

  /// Stream collection
  Stream<List<Map<String, dynamic>>> streamCollection(String collection) {
    return _db.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  /// Stream query
  Stream<List<Map<String, dynamic>>> streamQuery(
    String collection, {
    String? field,
    dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(collection);

    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  // ==================== BATCH ====================

  /// Batch write multiple operations
  Future<void> batchWrite(List<BatchOperation> operations) async {
    final batch = _db.batch();

    for (final op in operations) {
      final ref = _db.collection(op.collection).doc(op.docId);
      switch (op.type) {
        case BatchType.set:
          batch.set(ref, op.data!);
          break;
        case BatchType.update:
          batch.update(ref, op.data!);
          break;
        case BatchType.delete:
          batch.delete(ref);
          break;
      }
    }

    await batch.commit();
  }
}

// ==================== BATCH HELPERS ====================

enum BatchType { set, update, delete }

class BatchOperation {
  final BatchType type;
  final String collection;
  final String docId;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collection,
    required this.docId,
    this.data,
  });

  factory BatchOperation.set(String collection, String docId, Map<String, dynamic> data) {
    return BatchOperation(type: BatchType.set, collection: collection, docId: docId, data: data);
  }

  factory BatchOperation.update(String collection, String docId, Map<String, dynamic> data) {
    return BatchOperation(type: BatchType.update, collection: collection, docId: docId, data: data);
  }

  factory BatchOperation.delete(String collection, String docId) {
    return BatchOperation(type: BatchType.delete, collection: collection, docId: docId);
  }
}
