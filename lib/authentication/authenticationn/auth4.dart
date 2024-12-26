import 'package:firebase_auth/firebase_auth.dart';
import 'package:aikyamm/model/database_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return await auth.currentUser;
  }

Future<String> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      print("User cancelled the Google sign-in");
      return "error"; // User cancelled sign-in
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = result.user;

    if (user != null) {
      Map<String, dynamic> userInfoMap = {
        "email": user.email,
        "name": user.displayName,
        "imgUrl": user.photoURL,
        "id": user.uid,
      };

      // Add user data to the database
      await DatabaseMethods().addUser(user.uid, userInfoMap);

      // Send the user data to Node.js backend and handle response
      final responseStatus = await sendUserDataToApi(user, context);

      return responseStatus; // Return the API status
    } else {
      print("User is null after sign-in.");
      return "error"; // Return "error" if the user is null
    }
  } catch (e) {
    print("Error during Google sign-in: $e");
    return "error"; // Return "error" in case of any exception
  }
}

Future<String> signInWithApple(BuildContext context, {List<Scope> scopes = const []}) async {
  try {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential!;
        final oAuthCredential = OAuthProvider('apple.com');
        final credential = oAuthCredential.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;

        // Send the user data to Node.js backend and handle response
        final responseStatus = await sendUserDataToApi(firebaseUser, context);

        return responseStatus; // Return the API status

      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );

      default:
        throw UnimplementedError();
    }
  } catch (e) {
    print("Error during Apple sign-in: $e");
    rethrow;
  }
}

  Future<String> sendUserDataToApi(User user, BuildContext context) async {
  try {
    final url = 'https://demoaikyam.azurewebsites.net/api/authregister'; // Your Node.js server URL

    final Map<String, dynamic> userData = {
      'email': user.email,
      'name': user.displayName,
      'firebase_uid': user.uid,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(userData),
    );
 print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 201) {
      print("User data successfully sent to the server");
      return "success";
    } else if (response.statusCode == 409) {
      print("User already exists in the server");
      return "user_exists";
    } else {
      print("Failed to send user data: ${response.statusCode}");
      return "error";
    }
  } catch (e) {
    print("Error sending user data to API: $e");
    return "error";
  } 
}

}
