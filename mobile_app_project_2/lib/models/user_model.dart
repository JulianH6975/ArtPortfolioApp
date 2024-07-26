import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;
  final String nameLowercase;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      this.bio = '',
      this.profileImageUrl = '',
      this.followers = const [],
      this.following = const [],
      required this.nameLowercase});

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
    List<String>? followers,
    List<String>? following,
    String? nameLowercase,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      nameLowercase: nameLowercase ?? this.nameLowercase,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'name_lowercase': nameLowercase,
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
      nameLowercase: data['name_lowercase'] ?? '',
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
    );
  }
}
