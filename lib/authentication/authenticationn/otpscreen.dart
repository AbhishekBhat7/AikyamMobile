import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  void verifyOTP() {
    String otp = otpControllers.map((controller) => controller.text).join();
    // Send this OTP along with the email to the backend for verification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: verifyOTP,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
