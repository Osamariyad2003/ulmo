import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? phoneNumber;
  final String country;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.phoneNumber,
    required this.country,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      phoneNumber: data['phoneNumber'] ?? '',
      country: data['country'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'country': country,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
