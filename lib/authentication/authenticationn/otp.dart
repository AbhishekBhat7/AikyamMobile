// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   String? errorMessage;
//   bool otpSent = false;

//   // Future<void> sendOtp() async {
//   //   final email = emailController.text;
//   //   final response = await http.post(
//   //     Uri.parse('http://10.0.2.2:3000/sendOtp'), // Change for emulator
//   //     headers: {'Content-Type': 'application/json'},
//   //     body: json.encode({'email': email}),
//   //   );

//   //   if (response.statusCode == 200) {
//   //     final responseBody = json.decode(response.body);
//   //     if (responseBody['success']) {
//   //       setState(() {
//   //         otpSent = true;
//   //         errorMessage = null;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         errorMessage = responseBody['error'];
//   //       });
//   //     }
//   //   } else {
//   //     setState(() {
//   //       errorMessage = "Failed to send OTP.";
//   //     });
//   //   }
//   // }
// Future<void> sendOtp() async {
//   final email = emailController.text;

//   // Log email input before making the request
//   print("Sending OTP to email: $email");

//   try {
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/sendOtp'), // Change for emulator
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': email}),
//     );

//     print("Response Status: ${response.statusCode}");
//     print("Response Body: ${response.body}");

//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       if (responseBody['success']) {
//         setState(() {
//           otpSent = true;
//           errorMessage = null;
//         });
//       } else {
//         setState(() {
//           errorMessage = responseBody['error'];
//         });
//       }
//     } else {
//       setState(() {
//         errorMessage = "Failed to send OTP. Status: ${response.statusCode}";
//       });
//     }
//   } catch (e) {
//     print("Error sending OTP: $e");
//     setState(() {
//       errorMessage = "Error sending OTP: $e";
//     });
//   }
// }

//   Future<void> verifyOtp() async {
//     final email = emailController.text;
//     final otp = otpController.text;

//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/verifyOtp'), // Change for emulator
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': email, 'userOtp': otp}),
//     );

//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       if (responseBody['verified']) {
//         // Navigate to success screen or show success message
//         print("OTP verified successfully");
//         setState(() {
//           errorMessage = "OTP verified successfully!";
//         });
//       } else {
//         setState(() {
//           errorMessage = "Invalid OTP. Please try again.";
//         });
//       }
//     } else {
//       setState(() {
//         errorMessage = "Error verifying OTP.";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("OTP Verification")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendOtp,
//               child: Text("Send OTP"),
//             ),
//             SizedBox(height: 20),
//             if (otpSent) ...[
//               TextField(
//                 controller: otpController,
//                 decoration: InputDecoration(labelText: "Enter OTP"),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: verifyOtp,
//                 child: Text("Verify OTP"),
//               ),
//             ],
//             if (errorMessage != null) ...[
//               SizedBox(height: 20),
//               Text(
//                 errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
 
//  import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Add flutter_svg package to pubspec.yaml
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
//   String? errorMessage;
//   bool otpSent = false;
//   bool isLoading = false;

//   Future<void> sendOtp() async {
//     final email = emailController.text;
//     setState(() { isLoading = true; });
//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:3000/sendOtp'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'email': email}),
//       );
//       if (response.statusCode == 200) {
//         final responseBody = json.decode(response.body);
//         setState(() {
//           otpSent = responseBody['success'];
//           errorMessage = responseBody['success'] ? null : responseBody['error'];
//         });
//       } else {
//         setState(() { errorMessage = "Failed to send OTP. Status: ${response.statusCode}"; });
//       }
//     } catch (e) {
//       setState(() { errorMessage = "Error sending OTP: $e"; });
//     } finally {
//       setState(() { isLoading = false; });
//     }
//   }

//   Future<void> verifyOtp() async {
//     final otp = otpControllers.map((controller) => controller.text).join();
//     setState(() { isLoading = true; });
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/verifyOtp'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': emailController.text, 'userOtp': otp}),
//     );
//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       if (responseBody['verified']) {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
//       } else {
//         setState(() { errorMessage = "Invalid OTP. Please try again."; });
//       }
//     } else {
//       setState(() { errorMessage = "Error verifying OTP."; });
//     }
//     setState(() { isLoading = false; });
//   }

//   void _onOtpEntered(int index, String value) {
//     if (value.isNotEmpty && index < otpControllers.length - 1) {
//       FocusScope.of(context).nextFocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             right: 20,
//             child: SvgPicture.asset(
//               'assets/images/Vectors.svg', // Replace with your SVG file path
//               height: 270,
//               width: 270,
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: SvgPicture.asset(
//               'assets/images/bottomsvgss.svg', // Replace with your SVG file path
//               height: 250,
//               width: 250,
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.email_outlined, size: 80, color: Color.fromRGBO(143, 0, 0, 1)),
//                     SizedBox(height: 20),
//                     Text("Check your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     Text("We sent a code to your email address", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
//                     SizedBox(height: 40),
//                     if (!otpSent)
//                       TextField(
//                         controller: emailController,
//                         decoration: InputDecoration(
//                           labelText: "Email",
//                           prefixIcon: Icon(Icons.email, color: Color.fromRGBO(143, 0, 0, 1)),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                     if (!otpSent) SizedBox(height: 20),
//                     if (!otpSent)
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromRGBO(143, 0, 0, 1),
//                           padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: isLoading ? null : sendOtp,
//                         child: isLoading
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : Text("Send OTP", style: TextStyle(fontSize: 16)),
//                       ),
//                     if (otpSent) ...[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(6, (index) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: SizedBox(
//                             width: 40,
//                             child: TextField(
//                               controller: otpControllers[index],
//                               onChanged: (value) => _onOtpEntered(index, value),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                               ),
//                               keyboardType: TextInputType.number,
//                               textAlign: TextAlign.center,
//                               maxLength: 1,
//                             ),
//                           ),
//                         )),
//                       ),
//                       SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromRGBO(143, 0, 0, 1),
//                           padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: isLoading ? null : verifyOtp,
//                         child: isLoading
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : Text("Submit", style: TextStyle(fontSize: 16)),
//                       ),
//                     ],
//                     if (errorMessage != null) ...[
//                       SizedBox(height: 20),
//                       Text(
//                         errorMessage!,
//                         style: TextStyle(
//                           color: errorMessage!.contains("success") ? Colors.green : Color.fromRGBO(143, 0, 0, 1),
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NextScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("Welcome to the Next Screen!", style: TextStyle(fontSize: 24))),
//     );
//   }
// }

import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OTPScreen extends StatefulWidget {
  final String email;

  OTPScreen({required this.email});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  String? errorMessage;
  bool otpSent = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sendOtp(); // Automatically send OTP when the screen loads
  }

  Future<void> sendOtp() async {
    setState(() { isLoading = true; });
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/sendOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': widget.email}),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          otpSent = responseBody['success'];
          errorMessage = responseBody['success'] ? null : responseBody['error'];
        });
      } else {
        setState(() { errorMessage = "Failed to send OTP. Status: ${response.statusCode}"; });
      }
    } catch (e) {
      setState(() { errorMessage = "Error sending OTP: $e"; });
    } finally {
      setState(() { isLoading = false; });
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((controller) => controller.text).join();
    setState(() { isLoading = true; });
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/verifyOtp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': widget.email, 'userOtp': otp}),
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['verified']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        setState(() { errorMessage = "Invalid OTP. Please try again."; });
      }
    } else {
      setState(() { errorMessage = "Error verifying OTP."; });
    }
    setState(() { isLoading = false; });
  }

  void _onOtpEntered(int index, String value) {
    if (value.isNotEmpty && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    }
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
            right: 20,
            child: SvgPicture.asset(
              'assets/images/Vectors.svg',
              height: 270,
              width: 270,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: SvgPicture.asset(
              'assets/images/bottomsvgss.svg',
              height: 250,
              width: 250,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, size: 80, color: Color.fromRGBO(143, 0, 0, 1)),
                    SizedBox(height: 20),
                    Text("Check your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("We sent a code to your email address", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 40),
                    if (otpSent) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 40,
                            child: TextField(
                              controller: otpControllers[index],
                              onChanged: (value) => _onOtpEntered(index, value),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                            ),
                          ),
                        )),
                      ),
                      SizedBox(height: 30),
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
                          color: errorMessage!.contains("success") ? Colors.green : Color.fromRGBO(143, 0, 0, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
