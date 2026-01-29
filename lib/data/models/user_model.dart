import 'package:cloud_firestore/cloud_firestore.dart';

/// App user model. Anonymous users are written to Firestore with createdAt/updatedAt.
class UserModel {
  final String id;
  final String? name;
  final String? email;
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    this.name,
    this.email,
    required this.isAnonymous,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? json['id']?.toString() ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? true,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  /// For Firestore write: id, name, email, isAnonymous. createdAt/updatedAt are set by service.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null && name!.isNotEmpty) 'name': name,
      if (email != null && email!.isNotEmpty) 'email': email,
      'isAnonymous': isAnonymous,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
