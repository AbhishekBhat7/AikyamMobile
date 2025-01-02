 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:aikyamm/authentication/Libraries/Colors.dart';

// --- BLoC Events ---
abstract class ForgotPasswordEvent {}

class ForgotPasswordRequestEvent extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordRequestEvent(this.email);
}

// --- BLoC States ---
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final String message;
  ForgotPasswordSuccessState(this.message);
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String errorMessage;
  ForgotPasswordErrorState(this.errorMessage);
}

// --- BLoC Logic ---
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordRequestEvent) {
      yield ForgotPasswordLoadingState();  // Show loading state

      try {
        final response = await http.post(
          Uri.parse('https://demoaikyam.azurewebsites.net/api/request-password-reset'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: json.encode({'email': event.email}),
        );

        final data = json.decode(response.body);

        if (response.statusCode == 200) {
          yield ForgotPasswordSuccessState(data['message']);
        } else {
          yield ForgotPasswordErrorState(data['message'] ?? 'Something went wrong. Please try again.');
        }
      } catch (e) {
        yield ForgotPasswordErrorState('Error: ${e.toString()}');
      }
    }
  }
}

// --- ForgotPasswordScreen (UI part) ---
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final emailController = TextEditingController();

    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),  // Ensuring Bloc is properly provided
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Forgot Password', style: TextStyle(color: MainColors.white),),
          backgroundColor: MainColors.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Reset your password',
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter your email address to receive a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenSize.width * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
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
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                    Navigator.pop(context);  // Navigate back after successful reset
                  } else if (state is ForgotPasswordErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ForgotPasswordLoadingState) {
                    return ElevatedButton(
                      onPressed: null,  // Disable button when loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColors.primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  return ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter your email address.')),
                        );
                      } else {
                        // Dispatch the event to the bloc
                        BlocProvider.of<ForgotPasswordBloc>(context).add(ForgotPasswordRequestEvent(email));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColors.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(color: MainColors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
