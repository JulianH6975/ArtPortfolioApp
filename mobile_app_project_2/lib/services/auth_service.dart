import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'firestore_service.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await FirestoreService().createUser(UserModel(
        id: userCredential.user!.uid,
        name: '',
        email: email,
        nameLowercase: '', // Add this line
      ));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('SignUp error: ${e.code} - ${e.message}');
      throw e;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw Exception('No user is currently signed in.');
      }
    } on FirebaseAuthException catch (e) {
      print('Change password error: ${e.code} - ${e.message}');
      throw e;
    }
  }

  Future<bool> hasUserCompletedProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc.exists &&
          (userDoc.data() as Map<String, dynamic>?)?.containsKey('name') ==
              true;
    }
    return false;
  }

  Future<void> refreshUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
