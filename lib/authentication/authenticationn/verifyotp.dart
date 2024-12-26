import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({super.key, required this.email});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  Future<void> verifyOtp(String otp) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': widget.email, 'otp': otp}),
    );
    if (response.statusCode == 200) {
      print('OTP verified');
      // Navigate to next screen (e.g., HomeScreen) on successful OTP verification
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('Invalid OTP');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  void submitOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();
    verifyOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 50, color: Colors.red),
            const SizedBox(height: 20),
            const Text("Check your Email"),
            Text("We sent a code to ${widget.email}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 40,
                    child: TextField(
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: submitOtp,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
