import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class AppleSignInPage extends StatelessWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AppleSignInPage({super.key});

  Future<void> signInWithApple(BuildContext context) async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apple Sign-In is only supported on iOS and macOS.')),
      );
      return;
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await firebaseAuth.signInWithCredential(credential);

      // Navigate to HomePage after successful login
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apple Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => signInWithApple(context),
          child: const Text('Sign in with Apple'),
        ),
      ),
    );
  }
}
