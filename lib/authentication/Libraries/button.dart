// import 'package:flutter/material.dart';

// class CustomLoginButton extends StatefulWidget {
//   final String text;
//   final VoidCallback onPressed;

//   const CustomLoginButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   _CustomLoginButtonState createState() => _CustomLoginButtonState();
// }

// class _CustomLoginButtonState extends State<CustomLoginButton> {
//   // To handle smooth scaling effect when the button is pressed
//   double _scaleFactor = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.onPressed();
//       },
//       onTapDown: (_) {
//         setState(() {
//           _scaleFactor = 0.95;  // Shrink the button when pressed
//         });
//       },
//       onTapUp: (_) {
//         setState(() {
//           _scaleFactor = 1.0;   // Return the button to normal size after release
//         });
//       },
//       child: AnimatedScale(
//         scale: _scaleFactor,
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(143, 0, 0, 1),  // Set the solid color
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.red.withOpacity(0.3),  // Adjusted shadow color to match button color
//                 blurRadius: 10,
//                 offset: const Offset(0, 5), // Shadow direction
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 15),
//           alignment: Alignment.center,
//           child: Text(
//             widget.text,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class CustomLoginButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomLoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomLoginButtonState createState() => _CustomLoginButtonState();
}

class _CustomLoginButtonState extends State<CustomLoginButton> {
  // To handle smooth scaling effect when the button is pressed
  double _scaleFactor = 1.0;
  double _elevation = 5.0; // Elevation for the button's shadow

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      onTapDown: (_) {
        setState(() {
          _scaleFactor = 0.95;  // Shrink the button when pressed
          _elevation = 10.0;    // Increase shadow to simulate elevation on tap
        });
      },
      onTapUp: (_) {
        setState(() {
          _scaleFactor = 1.0;   // Return the button to normal size after release
          _elevation = 5.0;     // Return shadow to normal elevation
        });
      },
      onTapCancel: () {
        setState(() {
          _scaleFactor = 1.0;   // Reset scale if tap is canceled
          _elevation = 5.0;     // Reset shadow
        });
      },
      child: AnimatedScale(
        scale: _scaleFactor,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent, // Make the material color transparent
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.white.withOpacity(0.4), // Ripple effect color
            highlightColor: Colors.white.withOpacity(0.1), // Highlight color when tapped
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Color.fromRGBO(143, 0, 0, 1),  // Set the solid color
                borderRadius: BorderRadius.circular(10),
                
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
