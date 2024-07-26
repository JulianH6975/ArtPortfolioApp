// lib/screens/artwork_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/artwork_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArtworkScreen extends StatelessWidget {
  final String artworkId;
  final FirestoreService _firestoreService = FirestoreService();

  ArtworkScreen({Key? key, required this.artworkId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Details'),
      ),
      body: FutureBuilder<ArtworkModel?>(
        future: _firestoreService.getArtwork(artworkId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Artwork not found'));
          }

          ArtworkModel artwork = snapshot.data!;
          return _buildArtworkDetails(context, artwork);
        },
      ),
    );
  }

  Widget _buildArtworkDetails(BuildContext context, ArtworkModel artwork) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isCurrentUserArtwork =
        currentUser != null && currentUser.uid == artwork.artistId;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Artwork Image
          CachedNetworkImage(
            imageUrl: artwork.imageUrl,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  artwork.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 8),
                // Artist Info
                FutureBuilder<UserModel?>(
                  future: _firestoreService.getUser(artwork.artistId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Text('Artist not found');
                    }
                    UserModel artist = snapshot.data!;
                    return InkWell(
                      onTap: () {
                        // Navigate to artist profile
                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: artist.id,
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(artist.profileImageUrl),
                            radius: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            artist.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                // Description
                Text(
                  'Description:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Text(artwork.description),
                SizedBox(height: 16),
                // Likes
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(width: 8),
                    Text('${artwork.likes.length} likes'),
                  ],
                ),
                SizedBox(height: 16),
                // Created At
                Text(
                  'Created on: ${_formatDate(artwork.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (isCurrentUserArtwork) ...[
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Delete Artwork'),
                    onPressed: () => _showDeleteConfirmation(context, artwork),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context, ArtworkModel artwork) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Artwork'),
          content: Text(
              'Are you sure you want to delete this artwork? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                try {
                  await _firestoreService.deleteArtwork(artwork.id);
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Go back to the previous screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Artwork deleted successfully')),
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete artwork: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
