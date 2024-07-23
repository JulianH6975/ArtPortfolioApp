import 'package:flutter/material.dart';

class ArtworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/placeholder_image.png'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Artwork Title',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('By Artist Name',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  const Text(
                      'Description: A detailed description of the artwork...'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                      const Text('123 likes'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
