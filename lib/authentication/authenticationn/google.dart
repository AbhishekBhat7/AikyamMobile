// import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';

// class GoogleSignInPages extends StatelessWidget {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//   GoogleSignInPages({super.key});

//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       // Trigger the authentication flow directly
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       // If the user canceled the sign-in process, show a cancellation message
//       if (googleUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Sign-in was canceled')),
//         );
//         return;
//       }

//       // Obtain the authentication details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create a new credential for Firebase authentication
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the obtained credentials
//       UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

//       // Extract user's information (email and name)
//       String userEmail = userCredential.user?.email ?? 'No email available';
//       String userName = userCredential.user?.displayName ?? 'No name available';

//       // After successful login, navigate to the next screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChoiceScreen(userId: userCredential.user!.uid),
//         ),
//       );
//     } catch (e) {
//       // Show error message in case of failure
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error during Google Sign-In: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Google Sign In')),
//       body: Center(
//         child: GestureDetector(
//           onTap: () => signInWithGoogle(context), // Directly trigger Google sign-in
//           child: Image.asset(
//             'assets/images/Googles.png', // Google sign-in icon (ensure you have this image)
//             height: 60, // Adjust the size of the icon as needed
//           ),
//         ),
//       ),
//     );
//   }
// }
