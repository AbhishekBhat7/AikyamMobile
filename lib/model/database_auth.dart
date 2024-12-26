import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  Future addUser(String userId, Map<String, dynamic> userInfoMap){
    return FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);

  }

   final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> checkUserExists(String userId) async {
    try {
      // Check if the user document exists in the 'users' collection
      var doc = await _db.collection('users').doc(userId).get();
      return doc.exists;  // Returns true if the user exists
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }
}
