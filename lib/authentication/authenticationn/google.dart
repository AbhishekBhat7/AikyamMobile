import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignInPages extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  GoogleSignInPages({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      // Extract the user's information from the Firebase user object
      String userEmail = userCredential.user?.email ?? '';
      String userName = userCredential.user?.displayName ??
          'User'; // Default to 'User' if no name is set

      // Navigate to the SelectionScreen and pass the user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChoiceScreen(userId: userCredential.user!.uid),
        ),
      );
    } catch (e) {
      // Show error message if sign-in fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during Google Sign-In: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              signInWithGoogle(context), // Trigger sign-in on button press
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
