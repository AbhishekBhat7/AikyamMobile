import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User data
  String? name;
  String? gender;
  String? dob;
  int? weight;
  int? height;

  // Text controllers for editable fields
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'];
          gender = userDoc['gender'];
          dob = userDoc['dob'];
          weight = userDoc['weight'];
          height = userDoc['height'];

          // Set initial values to controllers
          nameController.text = name ?? '';
          genderController.text = gender ?? '';
          dobController.text = dob ?? '';
          weightController.text = weight?.toString() ?? '';
          heightController.text = height?.toString() ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Update user data in Firestore
  Future<void> _updateUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': nameController.text,
        'gender': genderController.text,
        'dob': dobController.text,
        'weight': int.tryParse(weightController.text) ?? weight,
        'height': int.tryParse(heightController.text) ?? height,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              "Profile Information",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Editable fields
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: genderController,
              decoration: InputDecoration(labelText: "Gender"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: "Date of Birth"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: "Weight (kg)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: "Height (cm)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Save button to update data
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
