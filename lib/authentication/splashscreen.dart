import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Start the timer to navigate after 5 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => FitnessDashboard()),
      // );
    });
  } 

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/images/logoforsplash.svg', // Make sure the path is correct
          width: MediaQuery.of(context).size.width * 0.8, // Responsive width
          height: MediaQuery.of(context).size.height * 0.6, // Responsive height
          fit: BoxFit.contain, // Make sure the image fits
        ),
      ),
    );
  }
}

// Example next screen
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Screen')),
      body: const Center(child: Text('Welcome to the next screen!')),
    );
  }
}

void main() => runApp(const MaterialApp(home: LoginScreen()));
