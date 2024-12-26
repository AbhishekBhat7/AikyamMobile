import 'dart:convert';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';  // Import the intl package for date formatting

class Myprofile extends StatefulWidget {
  final String userEmail; // Accept email as a parameter

  const Myprofile({super.key, required this.userEmail});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Myprofile> {
  // User data
  String? name;
  String? gender;
  String? email;
  String? dob;  // Date of birth
  double? weight;
  double? height;

  // Text controllers for editable fields
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();  // Date of birth controller
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  // API URL
  final String apiUrl = "https://demoaikyam.azurewebsites.net/api";  // Replace with your actual API URL

  bool isEditing = false;  // Track if we are in edit mode

  @override
  void initState() {
    super.initState();
    print('User Email: ${widget.userEmail}'); // Debugging line to check email value
    _fetchUserData();  // Fetch user data when the page is loaded
  }
  
Future<void> _fetchUserData() async {
  try {
    final url = 'https://demoaikyam.azurewebsites.net/api/details/${widget.userEmail}';
    print("Fetching data from URL: $url");

    final response = await http.get(Uri.parse(url));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['user'] != null) {
        setState(() {
          name = data['user']['name'];
          gender = data['user']['gender'];
          email = data['user']['email'];

          // Format Date of Birth using intl
          dob = data['user']['date_of_birth']; // Raw value from API
          if (dob != null) {
            DateTime parsedDate = DateTime.parse(dob!); // Parse ISO 8601 string to DateTime
            dobController.text = DateFormat('yyyy-MM-dd').format(parsedDate); // Format to yyyy-MM-dd
          }

          // Safely parse weight and height to double
          weight = double.tryParse(data['user']['weight'].toString()) ?? 0.0;
          height = double.tryParse(data['user']['height'].toString()) ?? 0.0;

          // Set initial values to controllers
          nameController.text = name ?? '';
          genderController.text = gender ?? '';
          weightController.text = weight?.toStringAsFixed(2) ?? '';
          heightController.text = height?.toStringAsFixed(2) ?? '';
          emailController.text = email ?? '';
        });
      } else {
        print("No user data found for email: ${widget.userEmail}");
      }
    } else {
      print("Failed to load user data. Status code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load user data")),
      );
    }
  } catch (e) {
    print("Error fetching data: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error fetching user data: $e")),
    );
  }
}

  // Update user data in the API (PUT request)
  Future<void> _updateUserData() async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/updateprofile/details/${widget.userEmail}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': 'athlete',  // You should set role here or make it editable as well
          'name': nameController.text,
          'gender': genderController.text,
          'date_of_birth': dobController.text,  // Pass the Date of Birth
          'email': emailController.text,
          'weight': double.tryParse(weightController.text) ?? weight,  // Convert to double
          'height': double.tryParse(heightController.text) ?? height,  // Convert to double
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
        setState(() {
          isEditing = false;  // Exit edit mode after a successful update
        });
      } else {
        print("Failed to update user data. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile")),
        );
      }
    } catch (e) {
      print("Error updating data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile")),
      );
    }
  }

  // Toggle between view and edit mode
  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  // Build editable or read-only text fields based on isEditing flag
  Widget _buildTextField(String label, TextEditingController controller, bool isEditable, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: !isEditable,  // Make the field read-only if not in edit mode
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: AppColors.Failure,
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
            _buildTextField("Name", nameController, isEditing),
            const SizedBox(height: 10),
            _buildTextField("Gender", genderController, isEditing),
            const SizedBox(height: 10),
            _buildTextField("Email", emailController, isEditing),
            const SizedBox(height: 10),
            _buildTextField("Date of Birth", dobController, isEditing),  // Date of Birth field added here
            const SizedBox(height: 10),
            _buildTextField("Weight (kg)", weightController, isEditing, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField("Height (cm)", heightController, isEditing, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            // Toggle Edit button
            if (!isEditing)
              ElevatedButton(
                onPressed: _toggleEditMode,
                child: Text("Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Failure,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (isEditing)
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Failure,
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

