// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'auth_bloc.dart';  // Import your BLoC

// class AuthScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Authentication'),
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSuccess) {
//             // Handle success state (e.g., navigate to home screen)
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.status)));
//           } else if (state is AuthError) {
//             // Handle error state (e.g., show error message)
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
//           }
//         },
//         builder: (context, state) {
//           if (state is AuthInProgress) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<AuthBloc>().add(SignInWithGoogleEvent());
//                   },
//                   child: const Text('Sign in with Google'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<AuthBloc>().add(SignInWithAppleEvent());
//                   },
//                   child: const Text('Sign in with Apple'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aikyamm/model/database_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Auth BLoC Event
abstract class AuthEvent {}

class AuthSignInWithGoogleEvent extends AuthEvent {}

class AuthSignInWithAppleEvent extends AuthEvent {}

class AuthCheckCurrentUserEvent extends AuthEvent {}

// Auth BLoC State
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String message;
  AuthSuccessState(this.message);
}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}

// Auth BLoC Logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthSignInWithGoogleEvent) {
      yield AuthLoadingState();
      final result = await signInWithGoogle();
      if (result == "success") {
        yield AuthSuccessState("Google sign-in successful");
      } else {
        yield AuthErrorState("Error during Google sign-in");
      }
    } else if (event is AuthSignInWithAppleEvent) {
      yield AuthLoadingState();
      try {
        final result = await signInWithApple();
        yield AuthSuccessState("Apple sign-in successful");
      } catch (e) {
        yield AuthErrorState("Error during Apple sign-in");
      }
    } else if (event is AuthCheckCurrentUserEvent) {
      yield AuthLoadingState();
      final user = await getCurrentUser();
      if (user != null) {
        yield AuthSuccessState("User is logged in");
      } else {
        yield AuthErrorState("No user logged in");
      }
    }
  }

  // Auth Methods
  Future<User?> getCurrentUser() async {
    return await _auth.currentUser;
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        print("User cancelled the Google sign-in");
        return "error";
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
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
        final responseStatus = await sendUserDataToApi(user);
        return responseStatus;
      } else {
        print("User is null after sign-in.");
        return "error";
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
      return "error";
    }
  }

  Future<String> signInWithApple() async {
    try {
      final result = await TheAppleSignIn.performRequests(
          [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final AppleIdCredential appleIdCredential = result.credential!;
          final oAuthCredential = OAuthProvider('apple.com');
          final credential = oAuthCredential.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          );

          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;

          // Send the user data to Node.js backend and handle response
          final responseStatus = await sendUserDataToApi(firebaseUser);
          return responseStatus;

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

  Future<String> sendUserDataToApi(User user) async {
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

// UI to integrate with BLoC
class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoadingState) {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.pop(context); // Dismiss loading indicator
            }

            if (state is AuthSuccessState) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }

            if (state is AuthErrorState) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthSignInWithGoogleEvent());
                },
                child: Text('Sign In with Google'),
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthSignInWithAppleEvent());
                },
                child: Text('Sign In with Apple'),
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthCheckCurrentUserEvent());
                },
                child: Text('Check Current User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthScreen(),
  ));
}
