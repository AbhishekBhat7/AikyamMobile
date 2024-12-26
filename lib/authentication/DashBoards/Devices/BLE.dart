// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'BLE Connections',
//       theme: ThemeData(
//         primaryColor: const Color.fromRGBO(143, 0, 0, 1),
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const BLEDeviceListPage(),
//     );
//   }
// }

// class BLEDeviceListPage extends StatelessWidget {
//   const BLEDeviceListPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(143, 0, 0, 1),
//         title: const Text(
//           "Devices BLE Connections",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 18,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             // Handle back action
//           },
//         ),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             // Connect New Device Button
//             GestureDetector(
//               onTap: () {
//                 // Handle button action
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: const Color.fromRGBO(143, 0, 0, 1),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       offset: const Offset(0, 4),
//                       blurRadius: 6,
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(Icons.add, color: Colors.white, size: 20),
//                     SizedBox(width: 8),
//                     Text(
//                       "Connect New Device",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Saved Devices",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Saved Devices List
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildDeviceTile("Timing Gate ABC", isConnected: true),
//                   _buildDeviceTile("Timing Gate DEF", isConnected: false),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeviceTile(String deviceName, {bool isConnected = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             offset: const Offset(0, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.bluetooth,
//             color: isConnected
//                 ? const Color.fromRGBO(143, 0, 0, 1)
//                 : Colors.grey.shade600,
//             size: 30,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   deviceName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: isConnected ? Colors.black87 : Colors.grey.shade700,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   isConnected ? "Connected" : "Disconnected",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: isConnected
//                         ? const Color.fromRGBO(143, 0, 0, 1)
//                         : Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(
//             Icons.arrow_forward_ios,
//             size: 16,
//             color: Colors.black45,
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLE Connections',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(143, 0, 0, 1),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BLEDeviceListPage(),
    );
  }
}

class BLEDeviceListPage extends StatefulWidget {
  const BLEDeviceListPage({Key? key}) : super(key: key);

  @override
  State<BLEDeviceListPage> createState() => _BLEDeviceListPageState();
}

class _BLEDeviceListPageState extends State<BLEDeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 0, 0, 1),
        title: const Text(
          "Devices BLE Connections",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Handle back navigation
          },
        ),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Enhanced "Connect New Device" Button with Gradient
            GestureDetector(
              onTap: () {
                // Handle button tap
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(143, 0, 0, 1),
                      Color.fromRGBO(220, 20, 60, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      "Connect New Device",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Saved Devices",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            // Saved Devices List with Soft Cards
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDeviceTile("Timing Gate ABC", isConnected: true),
                  _buildDeviceTile("Timing Gate DEF", isConnected: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDeviceTile(String deviceName, {bool isConnected = false}) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 500),
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       gradient: isConnected
  //           ? const LinearGradient(
  //               colors: [
  //                 Color.fromRGBO(220, 20, 60, 0.2),
  //                 Colors.white,
  //               ],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             )
  //           : const LinearGradient(
  //               colors: [
  //                 Colors.white,
  //                 Colors.white,
  //               ],
  //             ),
  //       borderRadius: BorderRadius.circular(18),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           offset: const Offset(0, 2),
  //           blurRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           backgroundColor: isConnected
  //               ? const Color.fromRGBO(143, 0, 0, 0.8)
  //               : Colors.grey.shade300,
  //           radius: 28,
  //           child: Icon(
  //             Icons.bluetooth,
  //             color: Colors.white,
  //             size: 28,
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 deviceName,
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 isConnected ? "Connected" : "Disconnected",
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: isConnected
  //                       ? const Color.fromRGBO(143, 0, 0, 1)
  //                       : Colors.grey.shade600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Icon(
  //           Icons.arrow_forward_ios,
  //           size: 20,
  //           color: isConnected
  //               ? const Color.fromRGBO(143, 0, 0, 0.8)
  //               : Colors.black38,
  //         ),
  //       ],
  //     ),
  //   );
  // }

Widget _buildDeviceTile(String deviceName, {bool isConnected = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white, // Clean white background
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      border: Border.all(
        color: isConnected
            ? const Color.fromRGBO(143, 0, 0, 0.5)
            : Colors.grey.shade300,
        width: 1.5,
      ),
    ),
    child: Row(
      children: [
        // Circle Avatar with Status Indicator
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              backgroundColor: isConnected
                  ? const Color.fromRGBO(143, 0, 0, 0.8)
                  : Colors.grey.shade300,
              radius: 28,
              child: Icon(
                Icons.bluetooth,
                color: Colors.white,
                size: 30,
              ),
            ),
            if (isConnected)
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 200, 83, 1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Device Information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isConnected ? "Connected" : "Disconnected",
                style: TextStyle(
                  fontSize: 14,
                  color: isConnected
                      ? const Color.fromRGBO(143, 0, 0, 1)
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Right Arrow Icon for Interaction
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isConnected
                ? const Color.fromRGBO(143, 0, 0, 0.1)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: isConnected
                ? const Color.fromRGBO(143, 0, 0, 0.8)
                : Colors.black54,
          ),
        ),
      ],
    ),
  );
}

}
