import 'package:cloud_firestore/cloud_firestore.dart';

class ArtworkModel {
  final String id;
  final String artistId;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> likes;
  final DateTime createdAt;
  final String titleLowercase;

  ArtworkModel({
    required this.id,
    required this.artistId,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.likes = const [],
    required this.createdAt,
    required this.titleLowercase,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artistId': artistId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'likes': likes,
      'createdAt': createdAt,
      'title_lowercase': titleLowercase,
    };
  }

  factory ArtworkModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArtworkModel(
      id: doc.id,
      artistId: data['artistId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      titleLowercase: data['titleLowercase'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
