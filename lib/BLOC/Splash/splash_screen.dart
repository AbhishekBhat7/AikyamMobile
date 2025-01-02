// import 'package:aikyamm/BLOC/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
// import 'package:aikyamm/authentication/authenticationn/otp1.dart';
// import 'package:aikyamm/authentication/authenticationn/prog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:aikyamm/authentication/authenticationn/dash.dart';
// import 'package:aikyamm/authentication/authenticationn/signin.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // BLoC Event
// abstract class SplashEvent {}

// class CheckLoginStatus extends SplashEvent {}

// // BLoC State
// abstract class SplashState {}

// class SplashInitial extends SplashState {}

// class SplashLoginSuccess extends SplashState {
//   final String email;
//   SplashLoginSuccess(this.email);
// }

// class SplashLoginFailure extends SplashState {}

// // BLoC Logic (Business Logic Component)
// class SplashBloc extends Bloc<SplashEvent, SplashState> {
//   SplashBloc() : super(SplashInitial());

//   @override
//   Stream<SplashState> mapEventToState(SplashEvent event) async* {
//     if (event is CheckLoginStatus) {
//       final loginState = await DBHelper().getLoginState();
      
//       if (loginState != null && loginState['is_logged_in'] == 1) {
//         // If logged in, pass the email
//         yield SplashLoginSuccess(loginState['email']);
//       } else {
//         // If not logged in, proceed with failure state
//         yield SplashLoginFailure();
//       }
//     }
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _logoAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the animation controller
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     // Scale animation for the logo
//     _logoAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );

//     _controller.forward();  // Start the animation when the screen appears

//     // Dispatch event to check login status after the animation delay
//     Future.delayed(const Duration(seconds: 3), () {
//       BlocProvider.of<SplashBloc>(context).add(CheckLoginStatus());
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen size
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: BlocListener<SplashBloc, SplashState>(
//         listener: (context, state) {
//           if (state is SplashLoginSuccess) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomePage(userEmail: state.email),
//               ),
//             );
//           } else if (state is SplashLoginFailure) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomePage(userEmail: 'logo@gmail.com'),
//               ),
//             );
//           }
//         },
//         child: Stack(
//           children: [
//             // Top-right corner image (responsive)
//             Positioned(
//               top: screenHeight * 0.05,  // Position relative to screen height
//               right: screenWidth * 0.05,  // Position relative to screen width
//               child: SvgPicture.asset(
//                 'assets/images/Vectors.svg',  // Path for your top-right image
//                 width: screenWidth * 0.45,  // 50% of screen width
//                 height: screenHeight * 0.35,  // 30% of screen height
//                 fit: BoxFit.contain,
//               ),
//             ),
            
//             // Bottom-left corner image (responsive)
//             Positioned(
//               bottom: -screenHeight * 0.1,  // Position relative to screen height
//               left: -screenWidth * 0.05,  // Position relative to screen width
//               child: SvgPicture.asset(
//                 'assets/images/Vectors.svg',  // Path for your bottom-left image
//                 width: screenWidth * 0.5,  // 60% of screen width
//                 height: screenHeight * 0.45,  // 40% of screen height
//                 fit: BoxFit.contain,
//               ),
//             ),
    
//             // Centered logo with animation
//             Center(
//               child: FadeTransition(
//                 opacity: _logoAnimation,
//                 child: ScaleTransition(
//                   scale: _logoAnimation,
//                   child: SvgPicture.asset(
//                     'assets/images/logoforsplash.svg',  // Ensure the path is correct
//                     width: screenWidth * 0.8,  // Responsive width (70% of screen width)
//                     height: screenHeight * 0.5,  // Responsive height (40% of screen height)
//                     fit: BoxFit.contain,  // Make sure the image fits within the bounds
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // void main() {
// //   runApp(
// //     MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: BlocProvider(
// //         create: (context) => SplashBloc(),
// //         child: const SplashScreen(),
// //       ),
// //     ),
// //   );
// // }



import 'package:aikyamm/BLOC/Cache/db_helper.dart';
import 'package:aikyamm/BLOC/Dashboards/Device/BLE.dart';
import 'package:aikyamm/BLOC/Dashboards/Device/cards.dart';
import 'package:aikyamm/BLOC/Dashboards/Home/Home.dart';
import 'package:aikyamm/BLOC/Dashboards/MainDash/Dash.dart';
import 'package:aikyamm/BLOC/Dashboards/TeamDashboard/TeamPage.dart';
import 'package:aikyamm/BLOC/Pages/profile/myprofile.dart';
import 'package:aikyamm/BLOC/Progress/Onboard.dart';
import 'package:aikyamm/BLOC/Progress/choicescreen.dart';
import 'package:aikyamm/BLOC/SignIn/forget_password.dart';
// import 'package:aikyamm/BLOC/SignIn/signin.dart';
import 'package:aikyamm/BLOC/Signup/Signup/otp.dart';
import 'package:aikyamm/BLOC/Signup/Signup/sign_up_screen.dart';
// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC Event
abstract class SplashEvent {}

class CheckLoginStatus extends SplashEvent {}

// BLoC State
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoginSuccess extends SplashState {
  final String email;
  SplashLoginSuccess(this.email);
}

class SplashLoginFailure extends SplashState {}

// BLoC Logic (Business Logic Component)
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckLoginStatus>(_onCheckLoginStatus);
  }

  // Event handler for CheckLoginStatus
  Future<void> _onCheckLoginStatus(
      CheckLoginStatus event, Emitter<SplashState> emit) async {
    try {
      final loginState = await DBHelper().getLoginState();

      if (loginState != null && loginState['is_logged_in'] == 1) {
        // If logged in, pass the email
        emit(SplashLoginSuccess(loginState['email']));
      } else {
        // If not logged in, proceed with failure state
        emit(SplashLoginFailure());
      }
    } catch (e) {
      // Handle any potential errors here
      emit(SplashLoginFailure());
    }
  }
}

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

    // Dispatch event to check login status after the animation delay
    Future.delayed(const Duration(seconds: 3), () {
      BlocProvider.of<SplashBloc>(context).add(CheckLoginStatus());
    });
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
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoginSuccess) {
            // Navigate to HomePage if login is successful
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userEmail: state.email),
              ),
            );
          } else if (state is SplashLoginFailure) {
            // Navigate to HomePage with a default email if login fails
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>   FitnessDashboard( )
              ),
            );

            //  Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => BlocProvider(
            //       create: (_) => BluetoothPageBloc(),
            //       child: BluetoothPage(),
            //     ),
            //   ),
            // );

        
          }
        },
        child: Stack(
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
      ),
    );
  }
}
