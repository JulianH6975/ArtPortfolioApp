import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/artwork_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set({
      ...user.toMap(),
      'name_lowercase': user.name.toLowerCase(),
    });
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromDocument(doc) : null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromDocument(doc) : null);
  }

  // Artwork operations
  Future<String> createArtwork(ArtworkModel artwork) async {
    final docRef = await _firestore.collection('artworks').add({
      ...artwork.toMap(),
      'title_lowercase': artwork.title.toLowerCase(),
    });
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

  Stream<List<ArtworkModel>> getUserArtworksStream(String userId) {
    print(
        "Fetching artworks for user: $userId"); // This line is already present
    return _firestore
        .collection('artworks')
        .where('artistId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print(
          "Snapshot size: ${snapshot.docs.length}"); // This line is already present
      if (snapshot.docs.isEmpty) {
        print("No artworks found for user $userId");
      } else {
        print(
            "Artworks found: ${snapshot.docs.map((doc) => doc.id).join(', ')}");
      }
      return snapshot.docs
          .map((doc) => ArtworkModel.fromDocument(doc))
          .toList();
    });
  }

  Future<List<UserModel>> getFeaturedArtists({int limit = 5}) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('followers', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting featured artists: $e');
      return [];
    }
  }

  Future<List<ArtworkModel>> getFeaturedArtworks({int limit = 5}) async {
    try {
      final querySnapshot = await _firestore
          .collection('artworks')
          .orderBy('likes', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => ArtworkModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting featured artworks: $e');
      return [];
    }
  }

  Future<List<dynamic>> search(String query,
      {DocumentSnapshot? startAfter, int limit = 10}) async {
    query = query.toLowerCase();
    List<dynamic> results = [];

    // Search for users
    Query userQuery = _firestore
        .collection('users')
        .where('name_lowercase', isGreaterThanOrEqualTo: query)
        .where('name_lowercase', isLessThan: query + 'z')
        .limit(limit);

    // Search for artworks
    Query artworkQuery = _firestore
        .collection('artworks')
        .where('title_lowercase', isGreaterThanOrEqualTo: query)
        .where('title_lowercase', isLessThan: query + 'z')
        .limit(limit);

    if (startAfter != null) {
      userQuery = userQuery.startAfterDocument(startAfter);
      artworkQuery = artworkQuery.startAfterDocument(startAfter);
    }

    final userSnapshots = await userQuery.get();
    final artworkSnapshots = await artworkQuery.get();

    results
        .addAll(userSnapshots.docs.map((doc) => UserModel.fromDocument(doc)));
    results.addAll(
        artworkSnapshots.docs.map((doc) => ArtworkModel.fromDocument(doc)));

    return results;
  }
}
