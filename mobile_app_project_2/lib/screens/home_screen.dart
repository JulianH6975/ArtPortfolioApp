// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/artwork_model.dart';
import '../services/firestore_service.dart';
import '../widgets/artwork_grid.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: StreamBuilder<List<ArtworkModel>>(
        stream: _firestoreService.getArtworksStream(),
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
    );
  }
}
