// abstract class AuthEvent {}

// class SignUpEvent extends AuthEvent {
//   final String name;
//   final String email;
//   final String password;

//   SignUpEvent({
//     required this.name,
//     required this.email,
//     required this.password,
//   });
// }

// class GoogleSignInEvent extends AuthEvent {}

// class AppleSignInEvent extends AuthEvent {}


// signup_event.dart
part of 'signup_bloc.dart';

abstract class SignUpEvent {}

class SignUpFormSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpFormSubmitted({required this.name, required this.email, required this.password});
}
