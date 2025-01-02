import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// **BLoC State**
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// **BLoC Event**
abstract class AuthEvent {}

class GoogleSignInEvent extends AuthEvent {
  final BuildContext context;
  GoogleSignInEvent(this.context);
}

class AppleSignInEvent extends AuthEvent {
  final BuildContext context;
  AppleSignInEvent(this.context);
}

// **BLoC Logic**
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is GoogleSignInEvent) {
      yield AuthLoading();
      try {
        final result = await signInWithGoogleLogin(event.context);
        if (result != null) {
          yield AuthSuccess(result);
        } else {
          yield AuthFailure("Google login failed. Please try again.");
        }
      } catch (e) {
        yield AuthFailure("Error during Google login: $e");
      }
    } else if (event is AppleSignInEvent) {
      yield AuthLoading();
      try {
        final result = await signInWithAppleLogin(event.context);
        if (result != null) {
          yield AuthSuccess(result);
        } else {
          yield AuthFailure("Apple login failed. Please try again.");
        }
      } catch (e) {
        yield AuthFailure("Error during Apple login: $e");
      }
    }
  }
// **Updated signInWithGoogleLogin method**
Future<User?> signInWithGoogleLogin(BuildContext context) async {
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
    User? user = result.user;  // Get the User object from the UserCredential

    if (user != null) {
      String response = await sendUserDataToApiForLogin(user, context); // Pass the User object
      if (response == "success") {
        return user;  // Return the User object instead of UserCredential
      } else {
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

// **Updated signInWithAppleLogin method**
Future<User?> signInWithAppleLogin(BuildContext context) async {
  try {
    final result = await TheAppleSignIn.performRequests([AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential!;
        final oAuthCredential = OAuthProvider('apple.com');
        final credential = oAuthCredential.credential(idToken: String.fromCharCodes(appleIdCredential.identityToken!));

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user;  // Get the User object from UserCredential

        // Send user data to server for login validation
        String response = await sendUserDataToApiForLogin(firebaseUser!, context);  // Pass the User object
        if (response == "success") {
          return firebaseUser;  // Return the User object
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Apple login failed. Please try again.")),
          );
          return null;
        }

      case AuthorizationStatus.error:
        throw PlatformException(code: 'ERROR_AUTHORIZATION_DENIED', message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

      default:
        throw UnimplementedError();
    }
  } catch (e) {
    print("Error during Apple sign-in: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Apple login failed. Please try again.")),
    );
    return null;
  }
}


  Future<String> sendUserDataToApiForLogin(User user, BuildContext context) async {
    try {
      final url = 'https://demoaikyam.azurewebsites.net/api/authlogin'; // Your Node.js login endpoint

      final Map<String, dynamic> userData = {
        'email': user.email,
        'name': user.displayName,
        'firebase_uid': user.uid,
      };

      final response = await http.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: json.encode(userData));

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

// **UI**
class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Authentication")),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthSuccess) {
              // Handle success (e.g., navigate to another screen)
              return Center(child: Text('Welcome, ${state.user.displayName}'));
            } else if (state is AuthFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInEvent(context));
                    },
                    child: const Text("Sign in with Google"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AppleSignInEvent(context));
                    },
                    child: const Text("Sign in with Apple"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: const AuthPage(),
//   ));
// }
