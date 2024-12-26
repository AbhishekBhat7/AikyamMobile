import 'package:firebase_auth/firebase_auth.dart';
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

  // Sign-in with Google and send data to your Node.js server
// Method for Google Sign-In (Login)
// Future<UserCredential?> signInWithGoogleLogin(BuildContext context) async {
//   try {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     await googleSignIn.signOut();
//     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

//     if (googleSignInAccount == null) {
//       print("User cancelled the Google sign-in");
//       return null; // User cancelled sign-in
//     }

//     final GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     final AuthCredential credential = GoogleAuthProvider.credential(
//       idToken: googleSignInAuthentication.idToken,
//       accessToken: googleSignInAuthentication.accessToken,
//     );

//     UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
//     User? user = result.user;

//     if (user != null) {
//       // Send user data to server for login validation
//       String response = await sendUserDataToApiForLogin(user, context); // This will return "success", "user_not_found", or "error"
      
//       if (response == "success") {
//         return result; // User successfully logged in
//       } else {
//         return null; // User not found or error occurred
//       }
//     } else {
//       print("User is null after sign-in.");
//       return null;
//     }
//   } catch (e) {
//     print("Error during Google sign-in: $e");
//     throw Exception("Google sign-in failed: $e"); // Propagate error
//   }
// }

// Future<User?> signInWithAppleLogin(BuildContext context, {List<Scope> scopes = const []}) async {
//   try {
//     final result = await TheAppleSignIn.performRequests(
//       [AppleIdRequest(requestedScopes: scopes)]
//     );

//     switch (result.status) {
//       case AuthorizationStatus.authorized:
//         final AppleIdCredential appleIdCredential = result.credential!;
//         final oAuthCredential = OAuthProvider('apple.com');
//         final credential = oAuthCredential.credential(
//           idToken: String.fromCharCodes(appleIdCredential.identityToken!),
//         );

//         final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//         final firebaseUser = userCredential.user!;

//         // Send user data to server for login validation
//         String response = await sendUserDataToApiForLogin(firebaseUser, context); // This will return "success", "user_not_found", or "error"
        
//         if (response == "success") {
//           return firebaseUser; // User successfully logged in
//         } else {
//           return null; // User not found or error occurred
//         }

//       case AuthorizationStatus.error:
//         throw PlatformException(
//           code: 'ERROR_AUTHORIZATION_DENIED',
//           message: result.error.toString(),
//         );

//       case AuthorizationStatus.cancelled:
//         throw PlatformException(
//           code: 'ERROR_ABORTED_BY_USER',
//           message: 'Sign in aborted by user',
//         );

//       default:
//         throw UnimplementedError();
//     }
//   } catch (e) {
//     print("Error during Apple sign-in: $e");
//     rethrow; // Propagate error
//   }
// }
Future<UserCredential?> signInWithGoogleLogin(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      print("User cancelled the Google sign-in");
      return null; // User cancelled sign-in
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
      String response = await sendUserDataToApiForLogin(user, context); // This will return "success", "user_not_found", or "error"
      if (response == "success") {
        return result; // User successfully logged in
      } else {
        // Show proper message for a new user or error response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google login failed. Please try again.")),
        );
        return null; 
      }
    } else {
      print("User is null after sign-in.");
      return null;
    }
  } catch (e) {
    print("Error during Google sign-in: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google login failed. Please try again.")),
    );
    return null;
  }
}

Future<User?> signInWithAppleLogin(BuildContext context, {List<Scope> scopes = const []}) async {
  try {
    final result = await TheAppleSignIn.performRequests(
      [AppleIdRequest(requestedScopes: scopes)]
    );

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential!;
        final oAuthCredential = OAuthProvider('apple.com');
        final credential = oAuthCredential.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;

        // Send user data to server for login validation
        String response = await sendUserDataToApiForLogin(firebaseUser, context); // This will return "success", "user_not_found", or "error"
        
        if (response == "success") {
          return firebaseUser; // User successfully logged in
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Apple login failed. Please try again.")),
          );
          return null;
        }

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Apple login failed. Please try again.")),
    );
    return null; // Return null in case of error
  }
}


// Future<void> sendUserDataToApiForLogin(User user, BuildContext context) async {
//   try {
//     final url = 'https://demoaikyam.azurewebsites.net/api/authlogin'; // Your Node.js login endpoint

//     final Map<String, dynamic> userData = {
//       'email': user.email,
//       'name': user.displayName,
//       'firebase_uid': user.uid,
//     };

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(userData),
//     );

//     if (response.statusCode == 200) {
//       print("User data successfully validated for login");
//       return; // Successful login
//     } else if (response.statusCode == 404) {
//       throw Exception("User not found"); // User not found on the server
//     } else {
//       throw Exception("Failed to validate user data: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error sending user data to API for login: $e");
//     throw Exception("Error during login: $e"); // Propagate error
//   }
// }
// Future<String> sendUserDataToApiForLogin(User user, BuildContext context) async {
//   try {
//     final url = 'https://demoaikyam.azurewebsites.net/api/authlogin'; // Your Node.js login endpoint

//     final Map<String, dynamic> userData = {
//       'email': user.email,
//       'name': user.displayName,
//       'firebase_uid': user.uid,
//     };

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(userData),
//     );

//     if (response.statusCode == 200) {
//       print("User data successfully validated for login");
//       return "success"; // User found, login successful
//     } else if (response.statusCode == 404) {
//       print("User not found in the server");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("User not found. Please register first.")),
//       );
//       return "user_not_found"; // Handle the case where the user is not found
//     } else {
//       print("Failed to validate user data: ${response.statusCode}");
//       return "error";
//     }
//   } catch (e) {
//     print("Error sending user data to API for login: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error during login. Please try again.")),
//     );
//     return "error";
//   }
// }
Future<String> sendUserDataToApiForLogin(User user, BuildContext context) async {
  try {
    final url = 'https://demoaikyam.azurewebsites.net/api/authlogin'; // Your Node.js login endpoint

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

    if (response.statusCode == 200) {
      print("User data successfully validated for login");
      return "success"; // User found, login successful
    } else if (response.statusCode == 404) {
      print("User not found in the server");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found. Please register first.")),
      );
      return "user_not_found"; // Handle the case where the user is not found
    } else {
      print("Failed to validate user data: ${response.statusCode}");
      return "error";
    }
  } catch (e) {
    print("Error sending user data to API for login: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error during login. Please try again.")),
    );
    return "error";
  }
}

}
