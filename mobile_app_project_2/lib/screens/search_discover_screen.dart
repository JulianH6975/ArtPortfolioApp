// lib/screens/search_discover_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/artwork_model.dart';
import '../widgets/artwork_thumbnail.dart';

class SearchDiscoverScreen extends StatefulWidget {
  @override
  _SearchDiscoverScreenState createState() => _SearchDiscoverScreenState();
}

class _SearchDiscoverScreenState extends State<SearchDiscoverScreen> {
  final _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  Timer? _debounce;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreResults();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _searchResults = [];
      _hasMore = true;
      _lastDocument = null;
    });

    try {
      final results = await _firestoreService.search(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
        _hasMore = results.length == 10;
      });
      if (results.isNotEmpty) {
        _lastDocument = await _getLastDocument(results.last);
      }
    } catch (e) {
      print('Error performing search: $e');
      setState(() {
        _isSearching = false;
        _hasMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('An error occurred while searching. Please try again.')),
      );
    }
  }

  void _loadMoreResults() async {
    if (!_hasMore || _isSearching) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _firestoreService.search(
        _searchController.text,
        startAfter: _lastDocument,
      );

      setState(() {
        _searchResults.addAll(results);
        _isSearching = false;
        _hasMore = results.length == 10;
      });

      if (results.isNotEmpty) {
        _lastDocument = await _getLastDocument(results.last);
      }
    } catch (e) {
      print('Error loading more results: $e');
      setState(() {
        _isSearching = false;
        _hasMore = false;
      });
    }
  }

  Future<DocumentSnapshot?> _getLastDocument(dynamic lastResult) async {
    if (lastResult is UserModel) {
      return await _firestore.collection('users').doc(lastResult.id).get();
    } else if (lastResult is ArtworkModel) {
      return await _firestore.collection('artworks').doc(lastResult.id).get();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for artists or artworks',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _searchResults.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _searchResults.length) {
                  return _isSearching
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }

                final result = _searchResults[index];
                if (result is UserModel) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(result.profileImageUrl),
                    ),
                    title: Text(result.name),
                    subtitle: Text('Artist'),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile',
                          arguments: result.id);
                    },
                  );
                } else if (result is ArtworkModel) {
                  return ArtworkThumbnail(artwork: result);
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
