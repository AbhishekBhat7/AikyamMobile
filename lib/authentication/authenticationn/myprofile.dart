import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  final String userEmail;

  const MyProfile({super.key, required this.userEmail});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfile> {
  // User data
  String? name;
  String? gender;
  String? email;
  String? dob;
  double? weight;
  double? height;
  
  // Text controllers for editable fields
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  // API URL
  final String apiUrl = "https://demoaikyam.azurewebsites.net/api";
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final url = 'https://demoaikyam.azurewebsites.net/api/details/${widget.userEmail}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['user'] != null) {
          setState(() {
            name = data['user']['name'];
            gender = data['user']['gender'];
            email = data['user']['email'];

            dob = data['user']['date_of_birth'];
            if (dob != null) {
              DateTime parsedDate = DateTime.parse(dob!);
              dobController.text = DateFormat('yyyy-MM-dd').format(parsedDate);
            }

            weight = double.tryParse(data['user']['weight'].toString()) ?? 0.0;
            height = double.tryParse(data['user']['height'].toString()) ?? 0.0;

            nameController.text = name ?? '';
            genderController.text = gender ?? '';
            weightController.text = weight?.toStringAsFixed(2) ?? '';
            heightController.text = height?.toStringAsFixed(2) ?? '';
            emailController.text = email ?? '';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching user data: $e")));
    }
  }

  Future<void> _updateUserData() async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/updateprofile/details/${widget.userEmail}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': 'athlete',
          'name': nameController.text,
          'gender': genderController.text,
          'date_of_birth': dobController.text,
          'email': emailController.text,
          'weight': double.tryParse(weightController.text) ?? weight,
          'height': double.tryParse(heightController.text) ?? height,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
        setState(() {
          isEditing = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating profile")));
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  // Handle Email click
  void _showEmailMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Email is not editable",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "You cannot change the email. If you need to update it, please contact support.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Build editable or non-editable text fields
  Widget _buildTextField(String label, TextEditingController controller, bool isEditable, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromRGBO(143, 0, 0, 1), width: 2),
          ),
        ),
        readOnly: !isEditable,
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(143, 0, 0, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editable fields
              _buildTextField("Name", nameController, isEditing),
              _buildTextField("Gender", genderController, isEditing),
              
              // Email: Non-editable, when clicked it shows a dialog
              GestureDetector(
                onTap: _showEmailMessage,
                child: AbsorbPointer(
                  child: _buildTextField("Email", emailController, false),
                ),
              ),

              _buildTextField("Date of Birth", dobController, isEditing),
              _buildTextField("Weight (kg)", weightController, isEditing, keyboardType: TextInputType.number),
              _buildTextField("Height (cm)", heightController, isEditing, keyboardType: TextInputType.number),

              const SizedBox(height: 20),

              // Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Edit/Save Button
                  ElevatedButton(
                    onPressed: _toggleEditMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(143, 0, 0, 1),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(isEditing ? "Cancel" : "Edit"),
                  ),
                  if (isEditing) const SizedBox(width: 20),
                  // Save Changes Button
                  if (isEditing)
                    ElevatedButton(
                      onPressed: _updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(143, 0, 0, 1),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("Save Changes"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
