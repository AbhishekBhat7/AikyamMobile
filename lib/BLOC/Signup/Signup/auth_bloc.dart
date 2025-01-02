// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:aikyamm/authentication/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'auth_event.dart';
// import 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   AuthBloc() : super(AuthInitial());

//   @override
//   Stream<AuthState> mapEventToState(AuthEvent event) async* {
//     if (event is SignUpEvent) {
//       yield* _mapSignUpEventToState(event);
//     } else if (event is GoogleSignInEvent) {
//       yield* _mapGoogleSignInEventToState();
//     } else if (event is AppleSignInEvent) {
//       yield* _mapAppleSignInEventToState();
//     }
//   }

//   // Handle sign up
//   Stream<AuthState> _mapSignUpEventToState(SignUpEvent event) async* {
//     try {
//       yield AuthInProgress();

//       // Simulate server interaction (replace with your actual method)
//       final response = await _signUpWithEmailPassword(event.name, event.email, event.password);

//       if (response != null && response['status'] == 'success') {
//         // Handle success response
//         yield AuthSuccess("Registered Successfully");
//         // Store the email in DB along with login state
//         await DBHelper().setLoginState(true, email: event.email);
//       } else {
//         yield AuthError(response['message'] ?? 'Registration failed');
//       }
//     } catch (e) {
//       yield AuthError("Error during registration: $e");
//     }
//   }

//   // Simulate the sign-up process with email and password
//   Future<Map<String, dynamic>> _signUpWithEmailPassword(String name, String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://demoaikyam.azurewebsites.net/api/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'name': name,
//           'email': email,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to register user');
//       }
//     } catch (e) {
//       throw Exception('Error during registration: $e');
//     }
//   }

//   // Handle Google Sign-In
//   Stream<AuthState> _mapGoogleSignInEventToState() async* {
//     try {
//       yield AuthInProgress();
//       final registrationStatus = await _signInWithGoogle();

//       if (registrationStatus == 'success') {
//         yield AuthSuccess("Google Sign-In Successful");
//       } else if (registrationStatus == 'user_exists') {
//         yield AuthError("Account exists. Please Log In.");
//       } else {
//         yield AuthError("Google Sign-In failed.");
//       }
//     } catch (e) {
//       yield AuthError("Google Sign-In failed: $e");
//     }
//   }

//   // Handle Apple Sign-In
//   Stream<AuthState> _mapAppleSignInEventToState() async* {
//     try {
//       yield AuthInProgress();
//       final registrationStatus = await _signInWithApple();

//       if (registrationStatus == 'success') {
//         yield AuthSuccess("Apple Sign-In Successful");
//       } else if (registrationStatus == 'user_exists') {
//         yield AuthError("Account exists. Please Log In.");
//       } else {
//         yield AuthError("Apple Sign-In failed.");
//       }
//     } catch (e) {
//       yield AuthError("Apple Sign-In failed: $e");
//     }
//   }

//   // Simulate Google Sign-In
//   Future<String> _signInWithGoogle() async {
//     try {
//       // Simulate the Google Sign-In logic
//       // Replace with actual logic
//       return 'success';
//     } catch (e) {
//       return 'error';
//     }
//   }

//   // Simulate Apple Sign-In
//   Future<String> _signInWithApple() async {
//     try {
//       // Simulate the Apple Sign-In logic
//       // Replace with actual logic
//       return 'success';
//     } catch (e) {
//       return 'error';
//     }
//   }
// }
