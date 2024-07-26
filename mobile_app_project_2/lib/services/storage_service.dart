import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String folder) async {
    try {
      String fileName = path.basename(image.path);
      Reference storageRef = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("StorageService: Uploaded image URL - $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("StorageService: Error uploading image - $e");
      return '';
    }
  }
}
