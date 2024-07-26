import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../models/artwork_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadArtScreen extends StatefulWidget {
  @override
  _UploadArtScreenState createState() => _UploadArtScreenState();
}

class _UploadArtScreenState extends State<UploadArtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();
  File? _image;
  bool _isUploading = false;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadArtwork() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        // Upload image to Firebase Storage
        String imageUrl =
            await _storageService.uploadImage(_image!, 'artworks');

        // Create artwork document in Firestore
        String userId = FirebaseAuth.instance.currentUser!.uid;
        ArtworkModel artwork = ArtworkModel(
          id: '', // Firestore will generate this
          artistId: userId,
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrl: imageUrl,
          createdAt: DateTime.now(),
          titleLowercase: _titleController.text.toLowerCase(), // Add this line
        );

        await _firestoreService.createArtwork(artwork);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artwork uploaded successfully!')),
        );

        // Clear form and image
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _image = null;
        });

        Navigator.pop(context); // Return to previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload artwork: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Artwork'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            if (_image != null)
              Image.file(_image!, height: 200, fit: BoxFit.cover)
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Select Image'),
              onPressed: _getImage,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Upload'),
              onPressed: _isUploading ? null : _uploadArtwork,
            ),
          ],
        ),
      ),
    );
  }
}
