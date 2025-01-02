import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
import 'package:aikyamm/authentication/Libraries/button.dart';
import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
import 'package:aikyamm/authentication/authenticationn/otp1.dart';
import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

// BLoC Events
abstract class SignUpEvent {}

class SignUpSubmitEvent extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpSubmitEvent({required this.name, required this.email, required this.password});
}

class GoogleSignInEvent extends SignUpEvent {}

class AppleSignInEvent extends SignUpEvent {}

// BLoC States
abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {
  final String message;

  SignUpSuccessState({required this.message});
}

class SignUpErrorState extends SignUpState {
  final String error;

  SignUpErrorState({required this.error});
}

// BLoC Logic
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpSubmitEvent) {
      yield SignUpLoadingState();

      try {
        final response = await _signUpWithEmailPassword(event.name, event.email, event.password);

        if (response != null && response['status'] == 'success') {
          yield SignUpSuccessState(message: 'Registered Successfully');
        } else {
          yield SignUpErrorState(error: response['message'] ?? 'Registration failed');
        }
      } catch (e) {
        yield SignUpErrorState(error: 'Error: $e');
      }
    } else if (event is GoogleSignInEvent) {
      yield SignUpLoadingState();
      try {
        // Implement Google SignIn logic here and yield appropriate states.
        yield SignUpSuccessState(message: 'Google SignIn Success');
      } catch (e) {
        yield SignUpErrorState(error: 'Google sign-in failed');
      }
    } else if (event is AppleSignInEvent) {
      yield SignUpLoadingState();
      try {
        // Implement Apple SignIn logic here and yield appropriate states.
        yield SignUpSuccessState(message: 'Apple SignIn Success');
      } catch (e) {
        yield SignUpErrorState(error: 'Apple sign-in failed');
      }
    }
  }

  // SignUp method to interact with your Node.js server
  Future<Map<String, dynamic>> _signUpWithEmailPassword(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://demoaikyam.azurewebsites.net/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email, // Use email as the primary key
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}

// UI Code
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email = "", password = "", name = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MainColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logoforsplash.svg',
                  height: screenSize.height * 0.245,
                  width: screenSize.width * 0.8,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Fill the form below to create an account',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: hint.customGray,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton(
                      context,
                      title: 'Log In',
                      isSelected: false,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildToggleButton(
                      context,
                      title: 'Sign Up',
                      isSelected: true,
                      onTap: () => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextFormField('Name', Icons.person, (value) => name = value!),
                const SizedBox(height: 20),
                _buildTextFormField('Email', Icons.email, (value) => email = value!),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                CustomLoginButton(
                  text: 'Sign Up',
                  onPressed: () {
                    _formKey.currentState!.save();
                    BlocProvider.of<SignUpBloc>(context).add(SignUpSubmitEvent(name: name, email: email, password: password));
                  },
                ),
                const SizedBox(height: 20),
                const Text('Or continue with'),
                const SizedBox(height: 20),
                _buildSocialButtons(screenSize),
                BlocListener<SignUpBloc, SignUpState>(
                  listener: (context, state) {
                    if (state is SignUpSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPScreen(name: name, password: password, email: email),
                        ),
                      );
                    } else if (state is SignUpErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, IconData icon, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onSaved: onSaved,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          }),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: _isPasswordHidden,
      onSaved: (value) => password = value!,
      validator: (value) =>
          value!.length < 6 ? 'Password must be at least 6 characters long' : null,
    );
  }

  Widget _buildSocialButtons(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => BlocProvider.of<SignUpBloc>(context).add(GoogleSignInEvent()),
          child: _socialButton('assets/images/Googles.png', screenSize),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => BlocProvider.of<SignUpBloc>(context).add(AppleSignInEvent()),
          child: _socialButton('assets/images/apple.png', screenSize),
        ),
      ],
    );
  }

  Widget _socialButton(String imagePath, Size screenSize) {
    return Container(
      height: screenSize.width * 0.14,
      width: screenSize.width * 0.14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Colors.black12, spreadRadius: 0.5, blurRadius: 5),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, {required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? MainColors.primaryColor : Colors.transparent, width: 2)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? MainColors.primaryColor : hint.customGray,
          ),
        ),
      ),
    );
  }
}
