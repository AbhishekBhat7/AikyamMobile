import 'dart:async';
import 'dart:io';
import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
import 'package:aikyamm/authentication/Libraries/button.dart';
import 'package:aikyamm/authentication/authenticationn/auth5.dart';
import 'package:aikyamm/authentication/authenticationn/dash.dart';
import 'package:aikyamm/authentication/authenticationn/forget_pass.dart';
import 'package:aikyamm/authentication/authenticationn/home.dart';
import 'package:aikyamm/authentication/authenticationn/signup_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aikyamm/authentication/Libraries/Colors.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: AuthWrapper(),
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Use FirebaseAuth or a custom stream for authentication state
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),  // Stream of user authentication state
//       builder: (context, snapshot) {
//         // Show a loading indicator while waiting for the stream
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // Check if the user is authenticated
//         if (snapshot.hasData) {
//           // User is logged in, navigate to dashboard
//           return const ChoiceScreens(); // Replace with your main screen (e.g., Dash or Home screen)
//         } else {
//           // No user, navigate to login screen
//           return const LoginScreen();
//         }
//       },
//     );
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool isLogin = true;
  bool _dialogShown = false;
  Future<void> signIn(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Make HTTP POST request to the custom API
      final response = await http.post(
        Uri.parse('https://demoaikyam.azurewebsites.net/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Assuming the token is returned upon successful login
        String token = data['token'];
        
        // Save login state in local database or preferences
        // await DBHelper().setLoginState(true);
        await DBHelper().setLoginState(true, email: email);        
        // Optionally save the token for future use
        // await DBHelper().setUserToken(token);
          if (!_dialogShown) {
           {
           await _showSuccessDialog(context, "Sign-In Successful!", "You have successfully Signed In!");
            setState(() {
              _dialogShown = true;  // Set the flag to true after showing the dialog
            });
          }
          }
        // Navigate to the Dashboard screen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userEmail: email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

// handle the dialog box 
Future<void> _showSuccessDialog(BuildContext context, String title, String message) async {
  // Show the dialog and wait for it to be dismissed before proceeding
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SuccessDialog(
         source: "signIn",
        title: title,
        message: message,
      );
    },
  );
}

Future<void> _handleGoogleLogin(BuildContext context) async {
  try {
    // Attempt Google login
    UserCredential? userCredential = await AuthMethods().signInWithGoogleLogin(context);

    if (userCredential != null) {
      final email = userCredential.user?.email ?? '';
      
      // Check if the user email is not empty
      if (email.isNotEmpty) {
        // Successfully logged in, navigate to the Dash screen
        // DIALOG BOX
         if (!_dialogShown) {
           {
           await _showSuccessDialog(context, "Sign-In Successful!", "You have successfully Signed In!");
            setState(() {
              _dialogShown = true;  // Set the flag to true after showing the dialog
            });
          }
          }
          await DBHelper().setLoginState(true, email: email );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userEmail: email),
          ),
        );
      } else {
        // Show an error if email is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google login failed. Email not found.")),
        );
      }
    } else {
      // Show error if userCredential is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google login failed. Please try again.")),
      );
    }
  } catch (e) {
    // Catch and display any errors during the login process
    String errorMessage = 'An unexpected error occurred. Please try again.';
    
    if (e is FirebaseAuthException) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'An account already exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'The credential is invalid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'The operation is not allowed. Please try again later.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user has been disabled.';
      } else {
        errorMessage = 'Firebase error: ${e.message}';
      }
    } else if (e is SocketException) {
      // Handle network errors
      errorMessage = 'Network error. Please check your internet connection.';
    } else if (e is TimeoutException) {
      // Handle timeout errors
      errorMessage = 'The request timed out. Please try again.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}

Future<void> _handleAppleLogin(BuildContext context) async {
  try {
    // Attempt Apple login
    User? user = await AuthMethods().signInWithAppleLogin(context);

    if (user != null) {
      final email = user.email ?? 'Unknown'; // Use 'Unknown' if email is not available

      // Check if the user email is not empty
      // Dialog box 
      if (email.isNotEmpty) {
        // Successfully logged in, navigate to the Dash screen
         if (!_dialogShown) {
           {
           await _showSuccessDialog(context, "Sign-In Successful!", "You have successfully Signed In!");
            setState(() {
              _dialogShown = true;  // Set the flag to true after showing the dialog
            });
          }
          }
           await DBHelper().setLoginState(true, email: email );    
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userEmail: email),
          ),
        );
      } else {
        // Show an error if email is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Apple login failed. Email not found.")),
        );
      }
    } else {
      // Show error if user is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Apple login failed. Please try again.")),
      );
    }
  } catch (e) {
    // Catch and display any errors during the login process
    String errorMessage = 'An unexpected error occurred. Please try again.';
    
    if (e is FirebaseAuthException) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'An account already exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'The credential is invalid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'The operation is not allowed. Please try again later.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user has been disabled.';
      } else {
        errorMessage = 'Firebase error: ${e.message}';
      }
    } else if (e is SocketException) {
      // Handle network errors
      errorMessage = 'Network error. Please check your internet connection.';
    } else if (e is TimeoutException) {
      // Handle timeout errors
      errorMessage = 'The request timed out. Please try again.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/logoforsplash.svg',
                    height: screenSize.height * 0.25,
                    width: screenSize.width * 0.5,
                  ),
                ],
              ),
              Text(
                'Get Started Now',
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Create an account or log in to explore',
                style: TextStyle(
                    fontSize: screenSize.width * 0.04, color: hint.customGray),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isLogin
                            ? MainColors.primaryColor
                            : MainColors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                              color: Color.fromRGBO(143, 0, 0, 1)),
                        ),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: isLogin ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = false;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: !isLogin
                            ? MainColors.primaryColor
                            : MainColors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                              color: Color.fromRGBO(143, 0, 0, 1)),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: !isLogin ? MainColors.white : MainColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     signIn(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: MainColors.primaryColor,
              //     minimumSize: const Size(double.infinity, 50),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: const Text(
              //     'Log In',
              //     style: TextStyle(color:MainColors.white),
              //   ),
              // ),
              CustomLoginButton(
                text: 'Log In',
                onPressed: () {
                  signIn(context);
                },
              ),
              const SizedBox(height: 20),
              const Text('Or login with'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    GestureDetector(
                    onTap: () {
                      _handleGoogleLogin(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/images/Googles.png',
                        height: screenSize.width * 0.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      _handleAppleLogin(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/images/Apples.png',
                        height: screenSize.width * 0.1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
