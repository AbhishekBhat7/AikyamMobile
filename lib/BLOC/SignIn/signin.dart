// import 'dart:convert';
// import 'dart:async';
// import 'package:aikyamm/authentication/authenticationn/auth5.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:aikyamm/authentication/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/Libraries/button.dart';
// import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
// import 'package:aikyamm/authentication/authenticationn/dash.dart';
// import 'package:aikyamm/authentication/authenticationn/signup_2.dart';
// import 'package:aikyamm/authentication/authenticationn/forget_pass.dart';

// // Define Login Event
// abstract class LoginEvent {}

// class EmailPasswordLoginEvent extends LoginEvent {
//   final String email;
//   final String password;

//   EmailPasswordLoginEvent({required this.email, required this.password});
// }

// class GoogleLoginEvent extends LoginEvent {}

// class AppleLoginEvent extends LoginEvent {}

// // Define Login States
// abstract class LoginState {}

// class LoginInitialState extends LoginState {}

// class LoginLoadingState extends LoginState {}

// class LoginSuccessState extends LoginState {
//   final String email;

//   LoginSuccessState({required this.email});
// }

// class LoginErrorState extends LoginState {
//   final String errorMessage;

//   LoginErrorState({required this.errorMessage});
// }

// // Define Login BLoC
// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   LoginBloc() : super(LoginInitialState());

//   @override
//   Stream<LoginState> mapEventToState(LoginEvent event) async* {
//     if (event is EmailPasswordLoginEvent) {
//       yield LoginLoadingState();
//       try {
//         final response = await http.post(
//           Uri.parse('https://demoaikyam.azurewebsites.net/api/login'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'email': event.email,
//             'password': event.password,
//           }),
//         );
//         final data = json.decode(response.body);
//         if (response.statusCode == 200) {
//           String token = data['token'];
//           await DBHelper().setLoginState(true, email: event.email);
//           yield LoginSuccessState(email: event.email);
//         } else {
//           yield LoginErrorState(errorMessage: data['message']);
//         }
//       } catch (e) {
//         yield LoginErrorState(errorMessage: 'Error: ${e.toString()}');
//       }
//     }

//     if (event is GoogleLoginEvent) {
//       yield LoginLoadingState();
//       try {
//         UserCredential? userCredential = await AuthMethods().signInWithGoogleLogin();
//         if (userCredential != null) {
//           final email = userCredential.user?.email ?? '';
//           if (email.isNotEmpty) {
//             await DBHelper().setLoginState(true, email: email);
//             yield LoginSuccessState(email: email);
//           } else {
//             yield LoginErrorState(errorMessage: 'Google login failed. Email not found.');
//           }
//         } else {
//           yield LoginErrorState(errorMessage: 'Google login failed. Please try again.');
//         }
//       } catch (e) {
//         yield LoginErrorState(errorMessage: 'Error: ${e.toString()}');
//       }
//     }

//     if (event is AppleLoginEvent) {
//       yield LoginLoadingState();
//       try {
//         User? user = await AuthMethods().signInWithAppleLogin();
//         if (user != null) {
//           final email = user.email ?? 'Unknown';
//           if (email.isNotEmpty) {
//             await DBHelper().setLoginState(true, email: email);
//             yield LoginSuccessState(email: email);
//           } else {
//             yield LoginErrorState(errorMessage: 'Apple login failed. Email not found.');
//           }
//         } else {
//           yield LoginErrorState(errorMessage: 'Apple login failed. Please try again.');
//         }
//       } catch (e) {
//         yield LoginErrorState(errorMessage: 'Error: ${e.toString()}');
//       }
//     }
//   }
// }

// // The LoginScreen Widget
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _rememberMe = false;
//   bool isLogin = true;
//   bool _dialogShown = false;

//   Future<void> _showSuccessDialog(BuildContext context, String title, String message) async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return SuccessDialog(
//           source: "signIn",
//           title: title,
//           message: message,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//           child: BlocProvider(
//             create: (context) => LoginBloc(),
//             child: BlocConsumer<LoginBloc, LoginState>(
//               listener: (context, state) {
//                 if (state is LoginSuccessState) {
//                   if (!_dialogShown) {
//                     _showSuccessDialog(context, "Sign-In Successful!", "You have successfully Signed In!");
//                     setState(() {
//                       _dialogShown = true;
//                     });
//                   }
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomePage(userEmail: state.email),
//                     ),
//                   );
//                 } else if (state is LoginErrorState) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.errorMessage)),
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SvgPicture.asset(
//                           'assets/images/logoforsplash.svg',
//                           height: screenSize.height * 0.25,
//                           width: screenSize.width * 0.5,
//                         ),
//                       ],
//                     ),
//                     Text(
//                       'Get Started Now',
//                       style: TextStyle(
//                         fontSize: screenSize.width * 0.05,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       'Create an account or log in to explore',
//                       style: TextStyle(
//                           fontSize: screenSize.width * 0.04, color: hint.customGray),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 isLogin = true;
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                                 );
//                               });
//                             },
//                             style: TextButton.styleFrom(
//                               backgroundColor: isLogin ? MainColors.primaryColor : MainColors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 side: const BorderSide(color: Color.fromRGBO(143, 0, 0, 1)),
//                               ),
//                             ),
//                             child: Text(
//                               'Log In',
//                               style: TextStyle(
//                                 fontSize: screenSize.width * 0.05,
//                                 fontWeight: FontWeight.bold,
//                                 color: isLogin ? Colors.white : Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 isLogin = false;
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const SignUp()),
//                                 );
//                               });
//                             },
//                             style: TextButton.styleFrom(
//                               backgroundColor: !isLogin ? MainColors.primaryColor : MainColors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 side: const BorderSide(color: Color.fromRGBO(143, 0, 0, 1)),
//                               ),
//                             ),
//                             child: Text(
//                               'Sign Up',
//                               style: TextStyle(
//                                 fontSize: screenSize.width * 0.05,
//                                 fontWeight: FontWeight.bold,
//                                 color: !isLogin ? MainColors.white : MainColors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         prefixIcon: const Icon(Icons.email),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: passwordController,
//                       obscureText: _obscurePassword,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         prefixIcon: const Icon(Icons.lock),
//                         suffixIcon: IconButton(
//                           icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: _rememberMe,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _rememberMe = value ?? false;
//                                 });
//                               },
//                             ),
//                             const Text('Remember me'),
//                           ],
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
//                             );
//                           },
//                           child: const Text('Forgot Password?'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     CustomLoginButton(
//                       text: 'Log In',
//                       onPressed: () {
//                         context.read<LoginBloc>().add(
//                           EmailPasswordLoginEvent(
//                             email: emailController.text.trim(),
//                             password: passwordController.text.trim(),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     const Text('Or login with'),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             context.read<LoginBloc>().add(GoogleLoginEvent());
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Image.asset(
//                               'assets/images/Googles.png',
//                               height: screenSize.width * 0.1,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         GestureDetector(
//                           onTap: () {
//                             context.read<LoginBloc>().add(AppleLoginEvent());
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Image.asset(
//                               'assets/images/Apples.png',
//                               height: screenSize.width * 0.1,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 1),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const SignUp()),
//                         );
//                       },
//                       child: const Text("Don't have an account? Sign Up"),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
