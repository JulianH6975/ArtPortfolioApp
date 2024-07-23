import 'package:flutter/material.dart';

class ArtistProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Profile'),
      ),
      body: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/placeholder_profile.png'),
          ),
          const SizedBox(height: 16),
          Text('Artist Name', style: Theme.of(context).textTheme.titleLarge),
          const Text('Bio: A short description about the artist'),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Follow'),
            onPressed: () {},
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return Image.asset('assets/placeholder_image.png',
                    fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }
}
