import 'dart:convert';
import 'package:aikyamm/authentication/authenticationn/otpscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = ''; // Add other fields as required

  Future<void> registration() async {
    // Your registration logic here
    // After successful registration, send OTP
    await sendOtp(email);
  }

  Future<void> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    if (response.statusCode == 200) {
      print('OTP sent');
    } else {
      print('Failed to send OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Your form fields here
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await registration();

                  // Navigate to OTP Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPScreen(email: email),
                    ),
                  );
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
