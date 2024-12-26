import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Update user role in Firestore
  Future<void> updateUserRole(String userId, String role) async {
    try {
      await _db.collection('users').doc(userId).update({
        'role': role,
      });
    } catch (e) {
      rethrow; // Propagate the error
    }
  }

  // Get user data
  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      rethrow; // Propagate the error
    }
  }
}
