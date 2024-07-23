import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/artwork_model.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ArtworkModel>>(
        stream: _firestoreService.getArtworksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No artworks found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final artwork = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/artwork',
                      arguments: artwork.id);
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(artwork.imageUrl),
                      ListTile(
                        title: Text(artwork.title),
                        subtitle: Text(artwork.artistId),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/upload');
        },
      ),
    );
  }
}
