import 'package:flutter/material.dart';

class UploadArtScreen extends StatefulWidget {
  @override
  _UploadArtScreenState createState() => _UploadArtScreenState();
}

class _UploadArtScreenState extends State<UploadArtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
            ElevatedButton(
              child: Text('Select Image'),
              onPressed: () {
                // TODO: Implement image selection
              },
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
              child: Text('Upload'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Implement upload functionality
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
