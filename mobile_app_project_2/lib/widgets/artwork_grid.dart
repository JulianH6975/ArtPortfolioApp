import 'package:flutter/material.dart';
import '../models/artwork_model.dart';
import 'artwork_thumbnail.dart';

class ArtworkGrid extends StatelessWidget {
  final List<ArtworkModel> artworks;

  const ArtworkGrid({Key? key, required this.artworks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: artworks.length,
      itemBuilder: (context, index) {
        return ArtworkThumbnail(artwork: artworks[index]);
      },
    );
  }
}
