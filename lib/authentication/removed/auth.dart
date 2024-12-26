// signup codes auth 

// Future<void> _handleGoogleSignIn(BuildContext context) async {
//   try {
//     UserCredential? userCredential =
//         await AuthMethods().signInWithGoogle(context);

//     if (userCredential != null) {
//       final email = userCredential.user?.email ?? '';

//       // Check if the user is new or already exists
//       final registrationStatus = await AuthMethods()
//           .sendUserDataToApi(userCredential.user!, context);

//       if (registrationStatus == 'success') {

//         // DIALOG BOX
//          if (!_dialogShown) {
//            {
//            await _showSuccessDialog(context, "Sign-Up Successful!", "You have successfully Signed Up!");
//             setState(() {
//               _dialogShown = true;  // Set the flag to true after showing the dialog
//             });
//           }
//           }
//         // Navigate to the next screen, passing the email
//           await DBHelper().setLoginState(true, email: email );    
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ChoiceScreen(
//                   userEmail: email,
//                   userData: {}) // Pass email to the next screen
//               ),
//         );
//       } else if (registrationStatus == 'user_exists') {
//         // Directly navigate the user to the next screen without re-sending the data
//          // DIALOG BOX
//          if (!_dialogShown) {
//            {
//            await _showSuccessDialog(context, "Sign-Up exists!", "You have successfully Signed Up!");
//             setState(() {
//               _dialogShown = true;  // Set the flag to true after showing the dialog
//             });
//           }
//           }
//         await DBHelper().setLoginState(true, email: email );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ChoiceScreen(
//                   userEmail: email,
//                   userData: {}) // Pass email to the next screen
//               ),
//         );
//       } else {
//         // Handle unexpected errors
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Registration failed. Please try again.")),
//         );
//       }
//     }
//   } catch (e) {
//     // Show error message for sign-in failure
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//           content: Text("Google sign-in failed. Please try again.")),
//     );
//   }
// }

// Future<void> _handleAppleSignIn(BuildContext context) async {
//   try {
//     // Attempt to sign in with Apple
//     User? user = await AuthMethods().signInWithApple(context);

//     if (user != null) {
//       // Fetch the email from the user, if available
//       final email = user.email ?? 'Unknown'; // Use 'Unknown' if email is not available

//       // Send user data to the API
//       final registrationStatus = await AuthMethods().sendUserDataToApi(user, context);

//       if (registrationStatus == 'success') {
//         // If registration is successful, navigate to the next screen

//         // DIALOG BOX
//          if (!_dialogShown) {
//            {
//            await _showSuccessDialog(context, "Sign-Up Successful!", "You have successfully Signed Up!");
//             setState(() {
//               _dialogShown = true;  // Set the flag to true after showing the dialog
//             });
//           }
//           }
//    await DBHelper().setLoginState(true, email: email );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChoiceScreen(
//               userEmail: email,
//               userData: {}, // Pass the user's data if required
//             ),
//           ),
//         );
//       } else if (registrationStatus == 'user_exists') {
//         // Handle the case where the user already exists
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User already exists. Please log in.")),
//         );
//       } else {
//         // Handle any unexpected errors during registration
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration failed. Please try again.")),
//         );
//       }
//     }
//   } catch (e) {
//     // Handle any errors during Apple sign-in
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Apple sign-in failed. Please try again.")),
//     );
//     print("Error during Apple sign-in: $e");
//   }
// }

  // and this is the auth's code 

    // Sign-in with Google and send data to your Node.js server
//   Future<UserCredential?> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       await googleSignIn.signOut();
//       final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

//       if (googleSignInAccount == null) {
//         print("User cancelled the Google sign-in");
//         return null; // User cancelled sign-in
//       }

//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken,
//       );

//       UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
//       User? user = result.user;

//       if (user != null) {
//         Map<String, dynamic> userInfoMap = {
//           "email": user.email,
//           "name": user.displayName,
//           "imgUrl": user.photoURL,
//           "id": user.uid,
//         };

//         // Add user data to the database
//         await DatabaseMethods().addUser(user.uid, userInfoMap);

//         // Send the user data to Node.js backend and handle response
//         final responseStatus = await sendUserDataToApi(user, context);

//         if (responseStatus == "user_exists") {
//           // Show a SnackBar if the user already exists
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("User already exists. Please log in.")),
//           );
//         } else if (responseStatus == "success") {
//           print("Google sign-in and registration successful");
//           return result;
//         } else {
//           print("Failed to register user via API");
//         }
//       } else {
//         print("User is null after sign-in.");
//         return null; // Return null if the user is null
//       }
//     } catch (e) {
//       print("Error during Google sign-in: $e");
//       return null; // Return null in case of any error
//     }
//     return null; /// remove if there is any error
//   }

// Future<User> signInWithApple(BuildContext context, {List<Scope> scopes = const []}) async {
//   try {
//     final result = await TheAppleSignIn.performRequests(
//         [AppleIdRequest(requestedScopes: scopes)]);

//     switch (result.status) {
//       case AuthorizationStatus.authorized:
//         final AppleIdCredential appleIdCredential = result.credential!;
//         final oAuthCredential = OAuthProvider('apple.com');
//         final credential = oAuthCredential.credential(
//           idToken: String.fromCharCodes(appleIdCredential.identityToken!),
//         );

//         final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//         final firebaseUser = userCredential.user!;

//         // Send the user data to Node.js backend and handle response
//         final responseStatus = await sendUserDataToApi(firebaseUser, context);

//         if (responseStatus == "user_exists") {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("User already exists. Please log in.")),
//           );
//         } else if (responseStatus == "success") {
//           print("Apple sign-in and registration successful");
//           return firebaseUser;
//         } else {
//           print("Failed to register user via API");
//         }

//         return firebaseUser;

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
//     rethrow;
//   }
// }
