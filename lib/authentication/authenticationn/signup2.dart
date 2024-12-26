// import 'package:aikyamm/authentication/authenticationn/otpscreen.dart';
// import 'package:aikyamm/authentication/authenticationn/signin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:aikyamm/authentication/authenticationn/applesignin.dart';
// import 'package:aikyamm/authentication/authenticationn/google.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _auth = FirebaseAuth.instance;
//   String email = "", password = "", name = "";
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isPasswordHidden = true;
//   bool isLogin = false;

//   registration() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         UserCredential userCredential = await _auth
//             .createUserWithEmailAndPassword(email: email, password: password);
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           backgroundColor: Colors.green,
//           content: Text(
//             "Registered Successfully",
//             style: TextStyle(fontSize: 20.0),
//           ),
//         ));

//         // Wait for a short duration before navigating
//         await Future.delayed(const Duration(seconds: 2));

//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => OTPScreen(email: email)));
//       } on FirebaseAuthException catch (e) {
//         String errorMessage;
//         if (e.code == 'weak-password') {
//           errorMessage = 'Password provided is too weak';
//         } else if (e.code == "email-already-in-use") {
//           errorMessage = 'Account already exists';
//         } else {
//           errorMessage = 'Failed to register: ${e.message}';
//         }
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(errorMessage)));
//       }
//     }
//   }

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
//               ? const Color.fromRGBO(143, 0, 0, 1)
//               : Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//             side: const BorderSide(color: Color.fromRGBO(143, 0, 0, 1)),
//           ),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: screenSize.width * 0.05,
//             fontWeight: FontWeight.bold,
//             color: isSelected ? Colors.white : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
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
//                   height: screenSize.height * 0.2,
//                   width: screenSize.width * 0.5,
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
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildToggleButton(
//                       context,
//                       title: 'Log In',
//                       isSelected: isLogin,
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
//                       isSelected: !isLogin,
//                       onTap: () => setState(() {
//                         isLogin = false;
//                       }),
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
//                     backgroundColor: const Color(0xFF8F0000),
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Or continue with'),
//                 const SizedBox(height: 20),
//                 _buildSocialButtons(screenSize),
//                 const SizedBox(height: 5),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Already have an account? Log In"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialButtons(Size screenSize) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GoogleSignInPages()),
//           ),
//           child: _socialButton('assets/images/Googles.png', screenSize),
//         ),
//         const SizedBox(width: 20),
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AppleSignInPage()),
//           ),
//           child: _socialButton('assets/images/Apples.png', screenSize),
//         ),
//       ],
//     );
//   }

//   Widget _socialButton(String assetPath, Size screenSize) {
//     return Container(
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         // border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Image.asset(
//         assetPath,
//         height: 40,
//         width: 40,
//       ),
//     );
//   }
// }
