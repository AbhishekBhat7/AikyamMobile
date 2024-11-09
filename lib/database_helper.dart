import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user
  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred during registration';
    }
  }

  // Store user data in Firestore
  Future<void> storeUserData(String userId, String name, String email) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'role': '', // Will be updated later
        'created_at': Timestamp.now(),
      });
    } catch (e) {
      throw 'Failed to store user data: $e';
    }
  }

  // Update user role (for example, after user selects Athlete or Trainer)
  Future<void> updateUserRole(String userId, String role) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': role,
      });
    } catch (e) {
      throw 'Failed to update role: $e';
    }
  }

  // Get user data from Firestore
  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      throw 'Failed to retrieve user data: $e';
    }
  }
}
