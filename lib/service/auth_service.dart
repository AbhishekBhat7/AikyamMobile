import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user with email and password
  Future<UserCredential> signUpWithEmailPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': '',
        'created_at': Timestamp.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase authentication exceptions
  String _handleAuthException(FirebaseAuthException e) {
    String errorMessage;
    if (e.code == 'weak-password') {
      errorMessage = 'Password provided is too weak';
    } else if (e.code == "email-already-in-use") {
      errorMessage = 'Account already exists';
    } else {
      errorMessage = 'Failed to register: ${e.message}';
    }
    return errorMessage;
  }
}
