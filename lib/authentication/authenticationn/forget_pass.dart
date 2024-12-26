// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:aikyamm/authentication/Libraries/Colors.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({Key? key}) : super(key: key);

//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController emailController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> requestPasswordReset(BuildContext context) async {
//     String email = emailController.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your email address.')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Send password reset request to the API
//       final response = await http.post(
//         Uri.parse('https://demoaikyam.azurewebsites.net/api/request-password-reset'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({'email': email}),
//       );

//       final data = json.decode(response.body);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data['message'])),
//       );

//       if (response.statusCode == 200) {
//         // If password reset request is successful, notify the user
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Forgot Password'),
//         backgroundColor: MainColors.primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Reset your password',
//               style: TextStyle(
//                 fontSize: screenSize.width * 0.05,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Enter your email address to receive a link to reset your password.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: screenSize.width * 0.04,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 40),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: const Icon(Icons.email),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : () => requestPasswordReset(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: MainColors.primaryColor,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: _isLoading
//                   ? const CircularProgressIndicator(
//                       color: Colors.white,
//                     )
//                   : const Text(
//                       'Send Reset Link',
//                       style: TextStyle(color: MainColors.white),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


  // Future<void> requestPasswordReset(BuildContext context) async {
  //   String email = emailController.text.trim();

  //   // Email validation
  //   if (email.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter your email address.')),
  //     );
  //     return;
  //   } else if (!_isValidEmail(email)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter a valid email address.')),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // Send password reset request to the API
  //     final response = await http.post(
  //       Uri.parse('https://demoaikyam.azurewebsites.net/api/request-password-reset'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({'email': email}),
  //     );

  //     final data = json.decode(response.body);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(data['message'])),
  //     );

  //     if (response.statusCode == 200) {
  //       // If password reset request is successful, notify the user
  //       Navigator.pop(context);
  //     } else {
  //       // Handle non-200 status codes
  //       String errorMessage = 'Something went wrong. Please try again.';
  //       if (data['message'] != null) {
  //         errorMessage = data['message'];
  //       }
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(errorMessage)),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aikyamm/authentication/Libraries/Colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  // Regex for email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

Future<void> requestPasswordReset(BuildContext context) async {
  String email = emailController.text.trim();

  // Email validation
  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter your email address.')),
    );
    return;
  } else if (!_isValidEmail(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid email address.')),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    // Send request to server to generate and send reset link
    final response = await http.post(
      Uri.parse('https://demoaikyam.azurewebsites.net/api/request-password-reset'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    final data = json.decode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data['message'])),
    );

    if (response.statusCode == 200) {
      // If the email is sent successfully, notify the user
      Navigator.pop(context);
    } else {
      // Handle non-200 status codes
      String errorMessage = 'Something went wrong. Please try again.';
      if (data['message'] != null) {
        errorMessage = data['message'];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: MainColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Reset your password',
              style: TextStyle(
                fontSize: screenSize.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter your email address to receive a link to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenSize.width * 0.04,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => requestPasswordReset(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Send Reset Link',
                      style: TextStyle(color: MainColors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
