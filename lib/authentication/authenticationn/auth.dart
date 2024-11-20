import 'package:aikyamm/authentication/authenticationn/dash1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aikyamm/model/database_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthMethods{
  final FirebaseAuth auth= FirebaseAuth.instance;

  getCurrentUser()async{
    return await auth.currentUser;
  }


  signInWithGoogle(BuildContext context) async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Start Google Sign-In
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  // Get Google Sign-In Authentication credentials
  final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount?.authentication;

  if (googleSignInAuthentication == null) {
    return; // If authentication fails, exit early.
  }

  final AuthCredential credential = GoogleAuthProvider.credential(
    idToken: googleSignInAuthentication.idToken,
    accessToken: googleSignInAuthentication.accessToken,
  );

  // Sign in with the credential
  UserCredential result = await firebaseAuth.signInWithCredential(credential);
  User? userdetails = result.user;

  if (userdetails != null) {
    Map<String, dynamic> userInfoMap = {
      "email": userdetails.email,
      "name": userdetails.displayName,
      "imgUrl": userdetails.photoURL,
      "id": userdetails.uid,
    };

    // Add user to database
    await DatabaseMethods().addUser(userdetails.uid, userInfoMap);

    // After successful sign-in and database update, navigate to the Dash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dash()),
    );
  }
}

   Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential = result.credential!;
        final oAuthCredential = OAuthProvider('apple.com');
        final credential = oAuthCredential.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
        final UserCredential = await auth.signInWithCredential(credential);
        final firebaseUser = UserCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = AppleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName}${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      default:
        throw UnimplementedError();
    }
  }
}

