import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/artwork_model.dart';
import 'dart:io';

class ArtworkThumbnail extends StatelessWidget {
  final ArtworkModel artwork;

  const ArtworkThumbnail({Key? key, required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (artwork.imageUrl.startsWith('http://') ||
        artwork.imageUrl.startsWith('https://')) {
      imageWidget = CachedNetworkImage(
        imageUrl: artwork.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else if (artwork.imageUrl.startsWith('file://')) {
      imageWidget = Image.file(
        File(artwork.imageUrl.replaceFirst('file://', '')),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    } else {
      imageWidget = const Icon(Icons.error);
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/artwork',
          arguments: artwork.id,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: artwork.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Text(
                  artwork.title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
