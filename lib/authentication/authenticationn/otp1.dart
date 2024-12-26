// import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// class OTPScreen extends StatefulWidget {
// //   final String email;
// //   final String userId;
// //   final String name;  // New field for name
// //   final String password;  // New field for password

// //   const OTPScreen({
// //     Key? key, 
// //     required this.email, 
// //     required this.userId,
// //     required this.name,  // Pass name dynamically
// //     required this.password,  // Pass password dynamically
// //   }) : super(key: key);
// // class OTPScreen extends StatelessWidget {
//   final String name;
//   final String password;
//   final String email;
//   // final String userId;

//   const OTPScreen({
//     Key? key,
//     required this.name,
//     required this.password,
//     required this.email,
//     // required this.userId,
//   }) : super(key: key);

//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
//   String? errorMessage;
//   bool otpSent = false;
//   bool isLoading = false;
//   bool isOtpExpired = false;
//   late Timer _timer;
//   int _timerDuration = 180; // 3 minutes = 180 seconds

//   @override
//   void initState() {
//     super.initState();
//     sendOtp(); // Automatically send OTP on screen load
//     startTimer();
//   }

//   // Start the OTP expiry countdown timer
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_timerDuration > 0) {
//         setState(() {
//           _timerDuration--;
//         });
//       } else {
//         setState(() {
//           isOtpExpired = true; // OTP has expired
//         });
//         _timer.cancel();
//       }
//     });
//   }

//   // Updated sendOtp function to dynamically pass data (name, email, password)
//   Future<void> sendOtp() async {
//     final email = widget.email;
//     final name = widget.name;  // Access name dynamically
//     final password = widget.password;  // Access password dynamically

//     setState(() {
//       isLoading = true;
//       otpSent = false;
//       isOtpExpired = false; // Reset OTP expiration state
//     });

//     int retryCount = 0;
//     while (retryCount < 3) {
//       try {
//         final response = await http.post(
//           Uri.parse('https://demoaikyam.azurewebsites.net/sendOtp'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'name': name,  // Send name dynamically
//             'email': email,  // Send email dynamically
//             'password': password,  // Send password dynamically
//           }),
//         );
        
//         if (response.statusCode == 200) {
//           final responseBody = json.decode(response.body);
//           setState(() {
//             otpSent = responseBody['success'];
//             errorMessage = responseBody['success'] ? null : responseBody['error'];
//           });
//           break;
//         } else {
//           setState(() {
//             errorMessage = "Failed to send OTP. Status: ${response.statusCode}";
//             otpSent = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           errorMessage = "Error sending OTP: $e";
//           otpSent = false;
//         });
//       }
//       retryCount++;
//       if (retryCount < 3) {
//         await Future.delayed(Duration(seconds: 2)); // Delay before retrying
//       }
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> verifyOtp() async {
//     final otp = otpControllers.map((controller) => controller.text).join();
//     setState(() {
//       isLoading = true;
//     });
//     final response = await http.post(
//       Uri.parse('https://demoaikyam.azurewebsites.net/verifyOtp'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': widget.email, 'userOtp': otp}),
//     );
//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       if (responseBody['verified']) {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     // builder: (context) => ChoiceScreen(userId: widget.userId),
//         //   ),
//         // );
//       } else {
//         setState(() {
//           errorMessage = "Invalid OTP. Please try again.";
//         });
//       }
//     } else {
//       setState(() {
//         errorMessage = "Error verifying OTP.";
//       });
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   void _onOtpEntered(int index, String value) {
//     if (value.isNotEmpty && index < otpControllers.length - 1) {
//       FocusScope.of(context).nextFocus();
//     } else if (index == otpControllers.length - 1 && value.isNotEmpty) {
//       // Automatically verify OTP once all fields are filled
//       verifyOtp();
//     }
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer when leaving the screen
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             right: 0,
//             child: SvgPicture.asset(
//               'assets/images/Vectors.svg',
//               height: 270,
//               width: 270,
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: SvgPicture.asset(
//               'assets/images/bottomsvgss.svg',
//               height: 250,
//               width: 250,
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.email_outlined, size: 80, color: Color.fromRGBO(143, 0, 0, 1)),
//                     SizedBox(height: 20),
//                     Text("Check your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     Text("We sent a code to your email address ${widget.email}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
//                     SizedBox(height: 40),
//                     if (otpSent) ...[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(6, (index) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width / 9,
//                             child: TextField(
//                               controller: otpControllers[index],
//                               onChanged: (value) => _onOtpEntered(index, value),
//                               decoration: InputDecoration(
//                                 counterText: '',
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                   borderSide: BorderSide(color: Color.fromRGBO(143, 0, 0, 1), width: 2),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.number,
//                               textAlign: TextAlign.center,
//                               maxLength: 1,
//                             ),
//                           ),
//                         )),
//                       ),
//                       SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromRGBO(143, 0, 0, 1),
//                           padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: isLoading ? null : verifyOtp,
//                         child: isLoading
//                             ? CircularProgressIndicator(color: Colors.white)
//                             : Text("Submit", style: TextStyle(fontSize: 16)),
//                       ),
//                     ],
//                     if (errorMessage != null) ...[
//                       SizedBox(height: 20),
//                       Text(
//                         errorMessage!,
//                         style: TextStyle(
//                           color: errorMessage!.contains("Invalid") ? Color.fromRGBO(143, 0, 0, 1) : Colors.green,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                     SizedBox(height: 20),
//                     TextButton(
//                       onPressed: isLoading ? null : sendOtp,
//                       child: Text(
//                         "Resend OTP",
//                         style: TextStyle(fontSize: 16, color: Color.fromRGBO(143, 0, 0, 1), fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     if (_timerDuration > 0)
//                       Text(
//                         "OTP expires in: $_timerDuration seconds",
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     if (isOtpExpired)
//                       Text(
//                         "OTP Expired. Please resend.",
//                         style: TextStyle(fontSize: 16, color: Colors.red),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:aikyamm/authentication/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
// import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

// class OTPScreen extends StatefulWidget {
//   final String name;
//   final String password;
//   final String email;

//   const OTPScreen({
//     Key? key,
//     required this.name,
//     required this.password,
//     required this.email,
//   }) : super(key: key);

//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
//   String? errorMessage;
//   bool otpSent = false;
//   bool isLoading = false;
//   bool isOtpExpired = false;
//   bool _dialogShown = false;
//   late Timer _timer;
//   int _timerDuration = 180; // 3 minutes = 180 seconds

//   @override
//   void initState() {
//     super.initState();
//     sendOtp(); // Automatically send OTP on screen load
//     startTimer();
//   }

//   // Start the OTP expiry countdown timer
//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_timerDuration > 0) {
//         setState(() {
//           _timerDuration--;
//         });
//       } else {
//         setState(() {
//           isOtpExpired = true; // OTP has expired
//         });
//         _timer.cancel();
//       }
//     });
//   }

//   // Updated sendOtp function to dynamically pass data (name, email, password)
//   Future<void> sendOtp() async {
//     final email = widget.email;
//     final name = widget.name;  // Access name dynamically
//     final password = widget.password;  // Access password dynamically

//     setState(() {
//       isLoading = true;
//       otpSent = false;
//       isOtpExpired = false; // Reset OTP expiration state
//     });

//     int retryCount = 0;
//     while (retryCount < 3) {
//       try {
//         final response = await http.post(
//           Uri.parse('https://demoaikyam.azurewebsites.net/sendOtp'),
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'name': name,  // Send name dynamically
//             'email': email,  // Send email dynamically
//             'password': password,  // Send password dynamically
//           }),
//         );
        
//         if (response.statusCode == 200) {
//           final responseBody = json.decode(response.body);
//           setState(() {
//             otpSent = responseBody['success'];
//             errorMessage = responseBody['success'] ? null : responseBody['error'];
//           });
//           break;
//         } else {
//           setState(() {
//             errorMessage = "Failed to send OTP. Status: ${response.statusCode}";
//             otpSent = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           errorMessage = "Error sending OTP: $e";
//           otpSent = false;
//         });
//       }
//       retryCount++;
//       if (retryCount < 3) {
//         await Future.delayed(Duration(seconds: 2)); // Delay before retrying
//       }
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> verifyOtp() async {
//     final otp = otpControllers.map((controller) => controller.text).join();
    
//     setState(() {
//       isLoading = true;
//     });
//     final response = await http.post(
//       Uri.parse('https://demoaikyam.azurewebsites.net/verifyOtp'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'email': widget.email, 'userOtp': otp}),
//     );
//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       if (responseBody['verified']) {
//         // Navigate to ChoiceScreen using email instead of userId
//          if (!_dialogShown) {
//            {
//            await _showSuccessDialog(context, "Sign-up Successful!", "You have successfully registered!");
//             setState(() {
//               _dialogShown = true;  // Set the flag to true after showing the dialog
//             });
//           }
//           }
//           await DBHelper().setLoginState(true, email: widget.email); 
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChoiceScreen(userEmail: widget.email, userData: {},),  // Pass email
//           ),
//         );
//       } else {
//         setState(() {
//           errorMessage = "Invalid OTP. Please try again.";
//         });
//       }
//     } else {
//       setState(() {
//         errorMessage = "Error verifying OTP.";
//       });
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//   // Calling the Dialog box
//   //       void _showSuccessDialog(BuildContext context, String title, String message) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return SuccessDialog(
//   //         source: "signUp", // This can be customized for different success cases
//   //         title: title,
//   //         message: message,
//   //       );
//   //     },
//   //   );
//   // }
// Future<void> _showSuccessDialog(BuildContext context, String title, String message) async {
//   // Show the dialog and wait for it to be dismissed before proceeding
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return SuccessDialog(
//          source: "signUp",
//         title: title,
//         message: message,
//       );
//     },
//   );
// }
//   void _onOtpEntered(int index, String value) {
//     if (value.isNotEmpty && index < otpControllers.length - 1) {
//       FocusScope.of(context).nextFocus();
//     } else if (index == otpControllers.length - 1 && value.isNotEmpty) {
//       // Automatically verify OTP once all fields are filled
//       verifyOtp();
//     }
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer when leaving the screen
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: MainColors.transparent,
//         iconTheme: IconThemeData(color: MainColors.black),
//         title: Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.bold, color: MainColors.black)),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             right: 0,
//             child: SvgPicture.asset(
//               'assets/images/Vectors.svg',
//               height: 270,
//               width: 270,
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: SvgPicture.asset(
//               'assets/images/bottomsvgss.svg',
//               height: 250,
//               width: 250,
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.email_outlined, size: 80, color: MainColors.primaryColor),
//                     SizedBox(height: 20),
//                     Text("Check your Email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     Text("We sent a code to your email address ${widget.email}", style: TextStyle(fontSize: 16, color: hint.customGray)),
//                     SizedBox(height: 40),
//                     if (otpSent) ...[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(6, (index) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width / 9,
//                             child: TextField(
//                               controller: otpControllers[index],
//                               onChanged: (value) => _onOtpEntered(index, value),
//                               decoration: InputDecoration(
//                                 counterText: '',
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                   borderSide: BorderSide(color: MainColors.primaryColor, width: 2),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.number,
//                               textAlign: TextAlign.center,
//                               maxLength: 1,
//                             ),
//                           ),
//                         ))),
//                       SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: MainColors.primaryColor,
//                           padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: isLoading ? null : verifyOtp,
//                         child: isLoading
//                             ? CircularProgressIndicator(color: MainColors.white)
//                             : Text("Submit", style: TextStyle(fontSize: 16)),
//                       ),
//                     ],
//                     if (errorMessage != null) ...[
//                       SizedBox(height: 20),
//                       Text(
//                         errorMessage!,
//                         style: TextStyle(
//                           color: errorMessage!.contains("Invalid") ? MainColors.primaryColor : AppColors.Success,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                     SizedBox(height: 20),
//                     TextButton(
//                       onPressed: isLoading ? null : sendOtp,
//                       child: Text(
//                         "Resend OTP",
//                         style: TextStyle(fontSize: 16, color: MainColors.primaryColor, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     if (_timerDuration > 0)
//                       Text(
//                         "OTP expires in: $_timerDuration seconds",
//                         style: TextStyle(fontSize: 16, color: hint.customGray),
//                       ),
//                     if (isOtpExpired)
//                       Text(
//                         "OTP Expired. Please resend.",
//                         style: TextStyle(fontSize: 16, color: AppColors.Failure),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/Libraries/Dailogue/success.dart';
import 'package:aikyamm/authentication/authenticationn/homescreens.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
  String? errorMessage;
  bool otpSent = false;
  bool isLoading = false;
  bool isOtpExpired = false;
  bool _dialogShown = false;
  late Timer _timer;
  int _timerDuration = 180; // 3 minutes = 180 seconds

  @override
  void initState() {
    super.initState();
    sendOtp(); // Automatically send OTP on screen load
    startTimer();
  }

  // Start the OTP expiry countdown timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerDuration > 0) {
        setState(() {
          _timerDuration--;
        });
      } else {
        setState(() {
          isOtpExpired = true; // OTP has expired
        });
        _timer.cancel();
      }
    });
  }

  // Updated sendOtp function to dynamically pass data (name, email, password)
  Future<void> sendOtp() async {
    final email = widget.email;
    final name = widget.name;  // Access name dynamically
    final password = widget.password;  // Access password dynamically

    setState(() {
      isLoading = true;
      otpSent = false;
      isOtpExpired = false; // Reset OTP expiration state
    });

    int retryCount = 0;
    while (retryCount < 3) {
      try {
        final response = await http.post(
          Uri.parse('https://demoaikyam.azurewebsites.net/sendOtp'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,  // Send name dynamically
            'email': email,  // Send email dynamically
            'password': password,  // Send password dynamically
          }),
        );
        
        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          setState(() {
            otpSent = responseBody['success'];
            errorMessage = responseBody['success'] ? null : responseBody['error'];
          });
          break;
        } else {
          setState(() {
            errorMessage = "Failed to send OTP. Status: ${response.statusCode}";
            otpSent = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = "Error sending OTP: $e";
          otpSent = false;
        });
      }
      retryCount++;
      if (retryCount < 3) {
        await Future.delayed(Duration(seconds: 2)); // Delay before retrying
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((controller) => controller.text).join();
    
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse('https://demoaikyam.azurewebsites.net/verifyOtp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': widget.email, 'userOtp': otp}),
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['verified']) {
        // Navigate to ChoiceScreen using email instead of userId
         if (!_dialogShown) {
           {
           await _showSuccessDialog(context, "Sign-up Successful!", "You have successfully registered!");
            setState(() {
              _dialogShown = true;  // Set the flag to true after showing the dialog
            });
          }
          }
          
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChoiceScreen(userEmail: widget.email, userData: {},),  // Pass email
          ),
        );
        
        await DBHelper().setLoginState(true, email: widget.email); 
      } else {
        setState(() {
          errorMessage = "Invalid OTP. Please try again.";
        });
      }
    } else {
      setState(() {
        errorMessage = "Error verifying OTP.";
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  
  Future<void> _showSuccessDialog(BuildContext context, String title, String message) async {
  // Show the dialog and wait for it to be dismissed before proceeding
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
      // Automatically verify OTP once all fields are filled
      verifyOtp();
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when leaving the screen
    super.dispose();
  }

  // Handle back press to show a message or prevent back navigation
  Future<bool> _onWillPop() async {
    // Show a dialog or a message when the user tries to go back
    bool? goBack = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('You will lose the OTP if you go back.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Don't go back
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Allow going back
              },
            ),
          ],
        );
      },
    );
    return goBack ?? false; // If user cancels, don't go back
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MainColors.transparent,
          iconTheme: IconThemeData(color: MainColors.black),
          title: Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.bold, color: MainColors.black)),
          centerTitle: true,
        ),
        body: Stack(
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
                      if (otpSent) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) => Padding(
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
                          ))),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isLoading ? null : verifyOtp,
                          child: isLoading
                              ? CircularProgressIndicator(color: MainColors.white)
                              : Text("Submit", style: TextStyle(fontSize: 16)),
                        ),
                      ],
                      if (errorMessage != null) ...[
                        SizedBox(height: 20),
                        Text(
                          errorMessage!,
                          style: TextStyle(
                            color: errorMessage!.contains("Invalid") ? MainColors.primaryColor : AppColors.Success,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: isLoading ? null : sendOtp,
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
        ),
      ),
    );
  }
}
