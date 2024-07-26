// lib/screens/artist_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/artwork_model.dart';
import '../services/firestore_service.dart';
import '../widgets/artwork_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'upload_art_screen.dart';

class ArtistProfileScreen extends StatelessWidget {
  final String? userId;
  final FirestoreService _firestoreService = FirestoreService();

  ArtistProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final currentUserId = authSnapshot.data?.uid;
        final bool isCurrentUser = true;

        return Scaffold(
          appBar: AppBar(
            title: Text('My Profile'),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
              ),
            ],
          ),
          body: currentUserId == null
              ? Center(child: Text('Please log in to view your profile'))
              : StreamBuilder<UserModel?>(
                  stream: _firestoreService.getUserStream(currentUserId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('User not found'));
                    }

                    UserModel artist = snapshot.data!;
                    return _buildArtistProfile(context, artist, isCurrentUser);
                  },
                ),
          floatingActionButton: isCurrentUser
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadArtScreen()),
                    );
                  },
                  child: Icon(Icons.add),
                  tooltip: 'Upload Artwork',
                )
              : null,
        );
      },
    );
  }

  Widget _buildArtistProfile(
      BuildContext context, UserModel artist, bool isCurrentUser) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    CachedNetworkImageProvider(artist.profileImageUrl),
              ),
              SizedBox(height: 16),
              Text(
                artist.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Text(
                artist.bio,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${artist.followers.length} Followers'),
                  SizedBox(width: 16),
                  Text('${artist.following.length} Following'),
                ],
              ),
              if (!isCurrentUser)
                ElevatedButton(
                  child: Text('Follow'),
                  onPressed: () {
                    // TODO: Implement follow functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Follow feature coming soon!')),
                    );
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<ArtworkModel>>(
            stream: _firestoreService.getUserArtworksStream(artist.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No artworks found'));
              }
              return ArtworkGrid(artworks: snapshot.data!);
            },
          ),
        ),
      ],
    );
  }
}
