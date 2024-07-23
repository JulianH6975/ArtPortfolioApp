import 'package:flutter/material.dart';

class SearchDiscoverScreen extends StatefulWidget {
  @override
  _SearchDiscoverScreenState createState() => _SearchDiscoverScreenState();
}

class _SearchDiscoverScreenState extends State<SearchDiscoverScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search & Discover'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for artists or artworks',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const ListTile(
                  title: Text('Popular Artists'),
                ),
                Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10, // Replace with actual data
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage('assets/placeholder_profile.png'),
                            ),
                            SizedBox(height: 8),
                            Text('Artist Name'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const ListTile(
                  title: const Text('Trending Artworks'),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10, // Replace with actual data
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Image.asset('assets/placeholder_image.png',
                                width: 150, height: 150, fit: BoxFit.cover),
                            const SizedBox(height: 8),
                            const Text('Artwork Title'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
