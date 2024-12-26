// import 'package:flutter/material.dart';

// void main() {
//   runApp(D());
// }

// class D extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.red), // Keeping the original red theme
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sign-Up / Sign-In Success")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 // Simulate a successful sign-up
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return SuccessDialog(
//                       source: "signUp", // Simulate the source as signUp
//                     );
//                   },
//                 );
//               },
//               child: Text('Simulate Sign-Up Success'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                 backgroundColor: Colors.red, // Elevated button color
//                 foregroundColor: Colors.white, // Text color on button
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Simulate a successful sign-in
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return SuccessDialog(
//                       source: "signIn", // Simulate the source as signIn
//                     );
//                   },
//                 );
//               },
//               child: Text('Simulate Sign-In Success'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                 backgroundColor: Colors.red, // Elevated button color
//                 foregroundColor: Colors.white, // Text color on button
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SuccessDialog extends StatelessWidget {
//   final String source; // This will determine if it's a sign-up or sign-in success

//   // Constructor to accept dynamic source
//   SuccessDialog({required this.source});

//   @override
//   Widget build(BuildContext context) {
//     // Set the success message dynamically based on the source
//     String message = '';
//     String title = '';

//     if (source == 'signUp') {
//       title = 'Sign-up Successful!';
//       message = 'You have successfully signed up!';
//     } else if (source == 'signIn') {
//       title = 'Sign-in Successful!';
//       message = 'You have successfully signed in!';
//     }

//     return Dialog(
//       insetPadding: EdgeInsets.all(20),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20), // Rounded corners
//       ),
//       elevation: 10,
//       backgroundColor: Colors.transparent, // Transparent background for gradient
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.green, // Green background for success
//           borderRadius: BorderRadius.circular(20), // Rounded corners
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               spreadRadius: 3,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(25),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.check_circle_outline,
//               color: Colors.white, // White check mark icon
//               size: 70,
//             ),
//             SizedBox(height: 20),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white, // White text for the title
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               message,
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 25),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white, // White button color
//                 foregroundColor: Colors.green, // Green text for the button
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               ),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String source;
  final String title;
  final String message;

  SuccessDialog({
    required this.source,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 70,
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
