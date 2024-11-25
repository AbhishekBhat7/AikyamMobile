import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class OTPScreen extends StatefulWidget {
  final String email;
  final String userId;

  const OTPScreen({Key? key, required this.email, required this.userId}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  String? errorMessage;
  bool otpSent = false;
  bool isLoading = false;
  bool isOtpExpired = false;
  late Timer _timer;
  int _timerDuration = 180; // 3 minutes = 180 seconds

  @override
  void initState() {
    super.initState();
    sendOtp(); // Automatically send OTP on screen load
    startTimer();
  }

  // Start the OTP expiry countdown timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerDuration > 0) {
        setState(() {
          _timerDuration--;
        });
      } else {
        setState(() {
          isOtpExpired = true; // OTP has expired
        });
        _timer.cancel();
      }
    });
  }

  Future<void> sendOtp() async {
    final email = widget.email;
    setState(() {
      isLoading = true;
      otpSent = false;
      isOtpExpired = false; // Reset OTP expiration state
    });
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/sendOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          otpSent = responseBody['success'];
          errorMessage = responseBody['success'] ? null : responseBody['error'];
        });
      } else {
        setState(() {
          errorMessage = "Failed to send OTP. Status: ${response.statusCode}";
          otpSent = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error sending OTP: $e";
        otpSent = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((controller) => controller.text).join();
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/verifyOtp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': widget.email, 'userOtp': otp}),
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['verified']) {
        // Navigate to ChoiceScreen and pass the user data (e.g., userId)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChoiceScreen(userId: widget.userId), // Pass userId from OTP screen
          ),
        );
      } else {
        setState(() {
          errorMessage = "Invalid OTP. Please try again.";
        });
      }
    } else {
      setState(() {
        errorMessage = "Error verifying OTP.";
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onOtpEntered(int index, String value) {
    if (value.isNotEmpty && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (index == otpControllers.length - 1 && value.isNotEmpty) {
      // Automatically verify OTP once all fields are filled
      verifyOtp();
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/Vectors.svg',
              height: 270,
              width: 270,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              'assets/images/bottomsvgss.svg',
              height: 250,
              width: 250,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView( // Make the screen scrollable to avoid overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, size: 80, color: Color.fromRGBO(143, 0, 0, 1)),
                    SizedBox(height: 20),
                    Text("Check your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("We sent a code to your email address ${widget.email}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 40),
                    if (otpSent) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 9, // Dynamically adjust width
                            child: TextField(
                              controller: otpControllers[index],
                              onChanged: (value) => _onOtpEntered(index, value),
                              decoration: InputDecoration(
                                counterText: '', // Remove the counter text
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Color.fromRGBO(143, 0, 0, 1), width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                            ),
                          ),
                        )),
                      ),
                      SizedBox(height: 30),
                      // Use Flexible button to avoid overflow
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(143, 0, 0, 1),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading ? null : verifyOtp,
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Submit", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                    if (errorMessage != null) ...[
                      SizedBox(height: 20),
                      Text(
                        errorMessage!,
                        style: TextStyle(
                          color: errorMessage!.contains("Invalid") ? Color.fromRGBO(143, 0, 0, 1) : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: isLoading ? null : sendOtp,
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(fontSize: 16, color: Color.fromRGBO(143, 0, 0, 1), fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_timerDuration > 0)
                      Text(
                        "OTP expires in: $_timerDuration seconds",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    if (isOtpExpired)
                      Text(
                        "OTP Expired. Please resend.",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
