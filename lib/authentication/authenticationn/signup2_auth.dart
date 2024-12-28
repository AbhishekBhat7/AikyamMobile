// import 'dart:convert';
// import 'package:aikyamm/authentication/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
// import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:aikyamm/authentication/authenticationn/otp1.dart';
// import 'package:aikyamm/authentication/authenticationn/signin.dart';
// import 'package:aikyamm/authentication/authenticationn/auth4.dart';


// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   String email = "", password = "", name = "";
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isPasswordHidden = true;
//    bool _dialogShown = false;
//   // Handle registration
//   Future<void> registration() async {
//     if (_formKey.currentState!.validate()) {
//       // Additional validation before sending the request
//       if (name.isEmpty || email.isEmpty || password.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill in all fields')),
//         );
//         return;
//       }

//       try {
//         var response = await _signUpWithEmailPassword(name, email, password);

//         if (response != null && response['status'] == 'success') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: AppColors.Success,
//               content: Text(
//                 "Registered Successfully",
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//           );

//           // Store the email in DB along with login state
//           // await DBHelper().setLoginState(true, email: email);

//           // Proceed to OTP screen if registration is successful
//           if (response['email'] != null) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OTPScreen(
//                   name: name,
//                   password: password,
//                   email: email,
//                 ),
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Email is missing from the response')),
//             );
//           }
//         } else {
//           if (response['message'] == 'User already exists') {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('User already exists. Please try logging in.'),
//                 backgroundColor: MainColors.primaryColor,
//               ),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                   content: Text(response['message'] ?? 'Registration failed')),
//             );
//           }
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }
// Future<void> _showSuccessDialog(BuildContext context, String title, String message) async {
//   // Show the dialog and wait for it to be dismissed before proceeding
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return SuccessDialog(
//          source: "signUp",
//         title: title,
//         message: message,
//       );
//     },
//   );
// }
//   // SignUp method to interact with your Node.js server
//   Future<Map<String, dynamic>> _signUpWithEmailPassword(
//       String name, String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//             'https://demoaikyam.azurewebsites.net/api/register'), // Ensure the URL is correct
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'name': name,
//           'email': email, // Use email as the primary key
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         print("Error Response: ${response.body}");
//         throw Exception(
//             'Failed to register user: ${response.statusCode}. Message: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error during registration: $e');
//     }
//   }
  

// Future<void> _handleGoogleSignIn(BuildContext context) async {
//   try {
//     final registrationStatus = await AuthMethods().signInWithGoogle(context);

//     if (registrationStatus == 'success') {
//       if (!_dialogShown) {
//         await _showSuccessDialog(context, "SignUp Successfull!!", "You have successfully Signed Up");
//         setState(() {
//           _dialogShown = true;
//         });
//       }

//       final email = FirebaseAuth.instance.currentUser?.email ?? '';

//       await DBHelper().setLoginState(true, email: email);
      
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChoiceScreen(
//             userEmail: email,
//             userData: {},
//           ),
//         ),
//       );
//     } else if (registrationStatus == 'user_exists') {
//       if (!_dialogShown) {
//         await _showSuccessDialog(context, "Account exists!", "Please Login!");
//         setState(() {
//           _dialogShown = true;
//         });
//       }

//       // final email = FirebaseAuth.instance.currentUser?.email ?? '';
//       // await DBHelper().setLoginState(true, email: email);
      
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => ChoiceScreen(
//       //       userEmail: email,
//       //       userData: {},
//       //     ),
//       //   ),
//       // );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration failed. Please try again.")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Google sign-in failed. Please try again.")),
//     );
//   }
// }

// Future<void> _handleAppleSignIn(BuildContext context) async {
//   try {
//     final registrationStatus = await AuthMethods().signInWithApple(context);

//     if (registrationStatus == 'success') {
//       if (!_dialogShown) {
//         await _showSuccessDialog(context, "Sign-Up Successful!", "You have successfully Signed Up!");
//         setState(() {
//           _dialogShown = true;
//         });
//       }

//       final email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
//       await DBHelper().setLoginState(true, email: email);
      
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChoiceScreen(
//             userEmail: email,
//             userData: {},
//           ),
//         ),
//       );
//     } else if (registrationStatus == 'user_exists') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User already exists. Please log in.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration failed. Please try again.")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Apple sign-in failed. Please try again.")),
//     );
//   }
// }

//   // Build the social media login buttons
//   Widget _buildSocialButtons(Size screenSize) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//        onTap: () => _handleGoogleSignIn(context),  // Wrap in a closure
//         child: _socialButton('assets/images/Googles.png', screenSize),
// ),

//         const SizedBox(width: 20),
//         GestureDetector(
//        onTap: () => _handleAppleSignIn(context),  // Wrap in a closure
//       child: _socialButton('assets/images/Apples.png', screenSize),
// )

//       ],
//     );
//   }

//   // Helper method to create social media buttons
//   Widget _socialButton(String assetPath, Size screenSize) {
//     return Container(
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Image.asset(
//         assetPath,
//         height: 40,
//         width: 40,
//       ),
//     );
//   }

//   // Build toggle button for switching between Log In and Sign Up
//   Widget _buildToggleButton(BuildContext context,
//       {required String title,
//       required bool isSelected,
//       required VoidCallback onTap}) {
//     final screenSize = MediaQuery.of(context).size;

//     return Expanded(
//       child: TextButton(
//         onPressed: onTap,
//         style: TextButton.styleFrom(
//           backgroundColor: isSelected
//               ? MainColors.primaryColor
//               : MainColors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//             side: const BorderSide(color: MainColors.primaryColor),
//           ),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: screenSize.width * 0.05,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? MainColors.white : MainColors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: MainColors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   'assets/images/logoforsplash.svg',
//                   height: screenSize.height * 0.245,
//                   width: screenSize.width * 0.8,
//                   fit: BoxFit.contain,
//                 ),
            
//                 Text(
//                   'Create Your Account',
//                   style: TextStyle(
//                     fontSize: screenSize.width * 0.06,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Fill the form below to create an account',
//                   style: TextStyle(
//                     fontSize: screenSize.width * 0.04,
//                     color: hint.customGray,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildToggleButton(
//                       context,
//                       title: 'Log In',
//                       isSelected: false,
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LoginScreen()),
//                         );
//                       },
//                     ),
//                     const SizedBox(width: 10),
//                     _buildToggleButton(
//                       context,
//                       title: 'Sign Up',
//                       isSelected: true,
//                       onTap: () => setState(() {}),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     prefixIcon: const Icon(Icons.person),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onSaved: (value) => name = value!,
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter your name' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     prefixIcon: const Icon(Icons.email),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   onSaved: (value) => email = value!,
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter email' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordHidden
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                       onPressed: () => setState(() {
//                         _isPasswordHidden = !_isPasswordHidden;
//                       }),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   obscureText: _isPasswordHidden,
//                   onSaved: (value) => password = value!,
//                   validator: (value) => value!.length < 6
//                       ? 'Password must be at least 6 characters long'
//                       : null,
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _formKey.currentState!.save();
//                     registration();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: MainColors.primaryColor,
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(color: MainColors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Or continue with'),
//                 const SizedBox(height: 20),
//                 _buildSocialButtons(screenSize),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

