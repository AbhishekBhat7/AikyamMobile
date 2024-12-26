import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String userId,
    required String name,
    required String gender,
    required DateTime dob,
    required int weight,
    required int height,
  }) async {
    try {
      await _db.collection('userss').doc(userId).set({
        'name': name,
        'gender': gender,
        'dob': dob,
        'weight': weight,
        'height': height,
      });
    } catch (e) {
      print("Error saving user data: $e");
    }
  }
}
