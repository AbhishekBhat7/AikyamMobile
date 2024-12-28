// import 'package:aikyamm/authentication/DashBoards/Devices/ex2.dart';
// import 'package:flutter/material.dart';

// class ex1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Device Configurations',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: DeviceConfigurationsPage(),
//     );
//   }
// }

// class DeviceConfigurationsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.arrow_back),
//         title: Text("Device Configurations"),
//         actions: [Icon(Icons.more_vert)],
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ConfigurationCard(
//               title: "Create New Configuration",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateNewConfigurationPage(),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             ConfigurationCard(
//               title: "4 Gate Sprint Run",
//               subtitle: "4 Gates\nLast Used 23 Oct\nAttributes 1\nAttributes 2",
//               icon: Icons.more_vert,
//             ),
//             SizedBox(height: 16),
//             ConfigurationCard(
//               title: "Device Debug",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConfigurationCard extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final IconData? icon;
//   final VoidCallback? onTap;

//   const ConfigurationCard({
//     required this.title,
//     this.subtitle,
//     this.icon,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (subtitle != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Text(
//                         subtitle!,
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (icon != null) Icon(icon),
//             Icon(Icons.arrow_forward_ios, size: 18),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:aikyamm/authentication/DashBoards/Devices/ex2.dart';
// import 'package:flutter/material.dart';

// class ex1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Device Configurations',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: DeviceConfigurationsPage(),
//     );
//   }
// }

// class DeviceConfigurationsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//         title: Text("Device Configurations", style: TextStyle(color: Colors.white)),
//         actions: [Icon(Icons.more_vert, color: Colors.white)],
//         elevation: 4,
//         backgroundColor: Color(0xFF8F0000), // Deep red color
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ConfigurationCard(
//               title: "Create New Configuration",
//               icon: Icons.add_circle_outline,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateNewConfigurationPage(),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             ConfigurationCard(
//               title: "4 Gate Sprint Run",
//               subtitle: "4 Gates\nLast Used 23 Oct\nAttributes 1\nAttributes 2",
//               icon: Icons.speed,
//             ),
//             SizedBox(height: 16),
//             ConfigurationCard(
//               title: "Device Debug",
//               icon: Icons.settings_input_component,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConfigurationCard extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final IconData? icon;
//   final VoidCallback? onTap;

//   const ConfigurationCard({
//     required this.title,
//     this.subtitle,
//     this.icon,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF8F0000), Color(0xFFD32F2F)], // Deep red to lighter red gradient
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 30,
//               child: Icon(
//                 icon,
//                 color: Color(0xFF8F0000), // Deep red color for icon
//                 size: 30,
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   if (subtitle != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 6.0),
//                       child: Text(
//                         subtitle!,
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:aikyamm/authentication/DashBoards/Devices/ex2.dart';
// import 'package:flutter/material.dart';

// class ex1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Device Configurations',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         textTheme: TextTheme(
//           bodyMedium: TextStyle(color: Colors.black87), // Ensuring text readability
//         ),
//       ),
//       home: DeviceConfigurationsPage(),
//     );
//   }
// }

// class DeviceConfigurationsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//         title: Text("Device Configurations", style: TextStyle(color: Colors.white)),
//         actions: [Icon(Icons.more_vert, color: Colors.white)],
//         elevation: 4,
//         backgroundColor: Color(0xFF8F0000), // Primary theme color
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ConfigurationCard(
//               title: "Create New Configuration",
//               icon: Icons.add_circle_outline,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateNewConfigurationPage(),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             ConfigurationCard(
//               title: "4 Gate Sprint Run",
//               subtitle: "4 Gates\nLast Used 23 Oct\nAttributes 1\nAttributes 2",
//               icon: Icons.speed,
//             ),
//             SizedBox(height: 16),
//             ConfigurationCard(
//               title: "Device Debug",
//               icon: Icons.settings_input_component,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConfigurationCard extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final IconData? icon;
//   final VoidCallback? onTap;

//   const ConfigurationCard({
//     required this.title,
//     this.subtitle,
//     this.icon,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF8F0000), Color(0xFFD32F2F)], // Deep red to lighter red gradient
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(25), // More rounded corners for a sleek look
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 15,
//               spreadRadius: 5,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 35, // Slightly larger icon for emphasis
//               child: Icon(
//                 icon,
//                 color: Color(0xFF8F0000), // Using the theme color for icons
//                 size: 32,
//               ),
//             ),
//             SizedBox(width: 20), // Extra spacing to make the card look more spacious
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700, // Strong font weight for title
//                       color: Colors.white,
//                     ),
//                   ),
//                   if (subtitle != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 6.0),
//                       child: Text(
//                         subtitle!,
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:aikyamm/authentication/DashBoards/Devices/ex2.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';

import '../../../BLE/final2.dart';


class DeviceConfigurationsPage extends StatelessWidget {
  final dynamic device; // The 'device' that was passed from the previous screen

  // Constructor to accept the 'device' data
  const DeviceConfigurationsPage({Key? key, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
          onPressed: () {
            Navigator.pop(context); // Should correctly pop the current route
            print("We Back to the page");
          },
        ),

        title: Text("Device Configurations",
            style: TextStyle(color: Colors.white)),
        actions: [Icon(Icons.more_vert, color: Colors.white)],
        elevation: 4,
        backgroundColor: Color(0xFF8F0000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Here, you can use the 'device' data to display relevant information
            Text(
                'Device Data: ${device.toString()}'), // Displaying the device info as a string

            ConfigurationCard(
              title: "Create New Configuration",
              icon: Icons.add_circle_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewConfigurationPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ConfigurationCard(
              title: "4 Gate Sprint Run",
              subtitle: "4 Gates\nLast Used 23 Oct\nAttributes 1\nAttributes 2",
              icon: Icons.speed,
            ),
            SizedBox(height: 16),
            ConfigurationCard(
              title: "Device Debug",
              icon: Icons.settings_input_component,
              onTap: () {
                // Passing the `device` data to DeviceDetailsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetailsPage(device: device),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigurationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const ConfigurationCard({
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8F0000), Color(0xFFD32F2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              child: Icon(
                icon,
                color: Color(0xFF8F0000),
                size: 32,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
