import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

// OTP BLoC code
 
class OTPScreen extends StatefulWidget {
  final String name;
  final String password;
  final String email;

  const OTPScreen({
    Key? key,
    required this.name,
    required this.password,
    required this.email,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  late OtpBloc _otpBloc;
  bool _dialogShown = false;
  int _timerDuration = 180; // 3 minutes = 180 seconds
  bool isOtpExpired = false;

  @override
  void initState() {
    super.initState();
    _otpBloc = OtpBloc(email: widget.email, name: widget.name, password: widget.password);
    _otpBloc.add(SendOtpEvent()); // Send OTP when the screen is loaded
    startTimer();
  }

  // Start OTP timer countdown
  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerDuration > 0) {
        setState(() {
          _timerDuration--;
        });
      } else {
        setState(() {
          isOtpExpired = true; // OTP has expired
        });
        timer.cancel();
      }
    });
  }

  Future<void> _showSuccessDialog(BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          source: "signUp",
          title: title,
          message: message,
        );
      },
    );
  }

  void _onOtpEntered(int index, String value) {
    if (value.isNotEmpty && index < otpControllers.length - 1) {
      FocusScope.of(context).nextFocus();
    } else if (index == otpControllers.length - 1 && value.isNotEmpty) {
      final otp = otpControllers.map((controller) => controller.text).join();
      _otpBloc.add(VerifyOtpEvent(otp));
    }
  }

  @override
  void dispose() {
    _otpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _otpBloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MainColors.transparent,
          iconTheme: IconThemeData(color: MainColors.black),
          title: Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.bold, color: MainColors.black)),
          centerTitle: true,
        ),
        body: BlocListener<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpSent) {
              // Handle OTP sent state
            } else if (state is OtpVerified) {
              if (!_dialogShown) {
                _showSuccessDialog(context, "Sign-up Successful!", "You have successfully registered!");
                setState(() {
                  _dialogShown = true;
                });
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoiceScreen(userEmail: widget.email, userData: {}),
                ),
              );
              DBHelper().setLoginState(true, email: widget.email);
            } else if (state is OtpError) {
              // Handle OTP error state
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<OtpBloc, OtpState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/images/Vectors.svg',
                      height: 270,
                      width: 270,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/images/bottomsvgss.svg',
                      height: 250,
                      width: 250,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email_outlined, size: 80, color: MainColors.primaryColor),
                            SizedBox(height: 20),
                            Text("Check your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text("We sent a code to your email address ${widget.email}", style: TextStyle(fontSize: 16, color: hint.customGray)),
                            SizedBox(height: 40),
                            if (state is OtpSent) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(6, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 9,
                                      child: TextField(
                                        controller: otpControllers[index],
                                        onChanged: (value) => _onOtpEntered(index, value),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: MainColors.primaryColor, width: 2),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MainColors.primaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: state is OtpLoading ? null : () {
                                  final otp = otpControllers.map((controller) => controller.text).join();
                                  _otpBloc.add(VerifyOtpEvent(otp));
                                },
                                child: state is OtpLoading
                                    ? CircularProgressIndicator(color: MainColors.white)
                                    : Text("Submit", style: TextStyle(fontSize: 16)),
                              ),
                            ],
                            if (state is OtpError) ...[
                              SizedBox(height: 20),
                              Text(
                                state.message,
                                style: TextStyle(
                                  color: state.message.contains("Invalid") ? MainColors.primaryColor : AppColors.Success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: state is OtpLoading ? null : () {
                                _otpBloc.add(SendOtpEvent());
                              },
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(fontSize: 16, color: MainColors.primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (_timerDuration > 0)
                              Text(
                                "OTP expires in: $_timerDuration seconds",
                                style: TextStyle(fontSize: 16, color: hint.customGray),
                              ),
                            if (isOtpExpired)
                              Text(
                                "OTP Expired. Please resend.",
                                style: TextStyle(fontSize: 16, color: AppColors.Failure),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// OTP BLoC code
 

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final String email;
  final String name;
  final String password;

  OtpBloc({required this.email, required this.name, required this.password}) : super(OtpInitial());

  @override
  Stream<OtpState> mapEventToState(OtpEvent event) async* {
    if (event is SendOtpEvent) {
      yield* _sendOtp();
    } else if (event is VerifyOtpEvent) {
      yield* _verifyOtp(event.otp);
    }
  }

  Stream<OtpState> _sendOtp() async* {
    yield OtpLoading();
    try {
      final response = await http.post(
        Uri.parse('https://demoaikyam.azurewebsites.net/sendOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success']) {
          yield OtpSent();
        } else {
          yield OtpError(responseBody['error']);
        }
      } else {
        yield OtpError("Failed to send OTP.");
      }
    } catch (e) {
      yield OtpError("Error sending OTP: $e");
    }
  }

  Stream<OtpState> _verifyOtp(String otp) async* {
    yield OtpLoading();
    try {
      final response = await http.post(
        Uri.parse('https://demoaikyam.azurewebsites.net/verifyOtp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'userOtp': otp}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['verified']) {
          yield OtpVerified();
        } else {
          yield OtpError("Invalid OTP. Please try again.");
        }
      } else {
        yield OtpError("Error verifying OTP.");
      }
    } catch (e) {
      yield OtpError("Error verifying OTP: $e");
    }
  }
}

// OTP Event
 
@immutable
abstract class OtpEvent {}

class SendOtpEvent extends OtpEvent {}

class VerifyOtpEvent extends OtpEvent {
  final String otp;

  VerifyOtpEvent(this.otp);
}

// OTP State
 

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSent extends OtpState {}

class OtpVerified extends OtpState {}

class OtpError extends OtpState {
  final String message;

  OtpError(this.message);
}
