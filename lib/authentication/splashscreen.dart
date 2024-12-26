// import 'package:aikyamm/authentication/authenticationn/dash.dart';
// import 'package:aikyamm/authentication/authenticationn/signin.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'Cache/db_helper.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     final loginState = await DBHelper().getLoginState();

//     if (loginState != null && loginState['is_logged_in'] == 1) {
//       // Retrieve the email from login state
//       String email = loginState['email'];
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Dash(userEmail: email), // Pass the email to Dash
//         ),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     }
//   }

//   @override 
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SvgPicture.asset(
//           'assets/images/logoforsplash.svg', // Make sure the path is correct
//           width: MediaQuery.of(context).size.width * 0.8, // Responsive width
//           height: MediaQuery.of(context).size.height * 0.6, // Responsive height
//           fit: BoxFit.contain, // Make sure the image fits
//         ),
//       ),
//     );
//   }
// }


// updated UI

import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
import 'package:aikyamm/authentication/authenticationn/otp1.dart';
import 'package:aikyamm/authentication/authenticationn/prog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Cache/db_helper.dart';
import 'package:aikyamm/authentication/authenticationn/dash.dart';
import 'package:aikyamm/authentication/authenticationn/signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Scale animation for the logo
    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();  // Start the animation when the screen appears

    // Check login status after a delay to let animation run
    Future.delayed(const Duration(seconds: 3), _checkLoginStatus);
  }

  // Check if the user is logged in or not
  Future<void> _checkLoginStatus() async {
    final loginState = await DBHelper().getLoginState();

    if (loginState != null && loginState['is_logged_in'] == 1) {
      // Retrieve the email from login state
      String email = loginState['email'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dash(userEmail: email),
        ),
      );
    } else {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      // );
         Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dash(userEmail: 'logo@gmail.com',))
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Top-right corner image (responsive)
          Positioned(
            top: screenHeight * 0.05,  // Position relative to screen height
            right: screenWidth * 0.05,  // Position relative to screen width
            child: SvgPicture.asset(
              'assets/images/Vectors.svg',  // Path for your top-right image
              width: screenWidth * 0.45,  // 50% of screen width
              height: screenHeight * 0.35,  // 30% of screen height
              fit: BoxFit.contain,
            ),
          ),
          
          // Bottom-left corner image (responsive)
          Positioned(
            bottom: -screenHeight * 0.1,  // Position relative to screen height
            left: -screenWidth * 0.05,  // Position relative to screen width
            child: SvgPicture.asset(
              'assets/images/Vectors.svg',  // Path for your bottom-left image
              width: screenWidth * 0.5,  // 60% of screen width
              height: screenHeight * 0.45,  // 40% of screen height
              fit: BoxFit.contain,
            ),
          ),

          // Centered logo with animation
          Center(
            child: FadeTransition(
              opacity: _logoAnimation,
              child: ScaleTransition(
                scale: _logoAnimation,
                child: SvgPicture.asset(
                  'assets/images/logoforsplash.svg',  // Ensure the path is correct
                  width: screenWidth * 0.8,  // Responsive width (70% of screen width)
                  height: screenHeight * 0.5,  // Responsive height (40% of screen height)
                  fit: BoxFit.contain,  // Make sure the image fits within the bounds
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
