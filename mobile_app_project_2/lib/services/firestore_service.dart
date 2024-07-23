import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/artwork_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromDocument(doc) : null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  // Artwork operations
  Future<String> createArtwork(ArtworkModel artwork) async {
    final docRef = await _firestore.collection('artworks').add(artwork.toMap());
    return docRef.id;
  }

  Future<ArtworkModel?> getArtwork(String artworkId) async {
    final doc = await _firestore.collection('artworks').doc(artworkId).get();
    return doc.exists ? ArtworkModel.fromDocument(doc) : null;
  }

  Future<void> updateArtwork(ArtworkModel artwork) async {
    await _firestore
        .collection('artworks')
        .doc(artwork.id)
        .update(artwork.toMap());
  }

  Future<void> deleteArtwork(String artworkId) async {
    await _firestore.collection('artworks').doc(artworkId).delete();
  }

  // Get artworks for home feed
  Stream<List<ArtworkModel>> getArtworksStream() {
    return _firestore
        .collection('artworks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ArtworkModel.fromDocument(doc))
            .toList());
  }

  // Get artworks for a specific user
  Stream<List<ArtworkModel>> getUserArtworksStream(String userId) {
    return _firestore
        .collection('artworks')
        .where('artistId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ArtworkModel.fromDocument(doc))
            .toList());
  }
}
