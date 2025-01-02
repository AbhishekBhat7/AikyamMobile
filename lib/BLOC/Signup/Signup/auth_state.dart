// abstract class AuthState {}

// class AuthInitial extends AuthState {}

// class AuthInProgress extends AuthState {}

// class AuthSuccess extends AuthState {
//   final String status;
//   AuthSuccess(this.status);
// }

// class AuthError extends AuthState {
//   final String message;
//   AuthError(this.message);
// }


// signup_state.dart

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({required this.error});
}
