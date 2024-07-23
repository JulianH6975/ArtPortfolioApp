import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio = '',
    this.profileImageUrl = '',
    this.followers = const [],
    this.following = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
    );
  }
}
