// import 'package:aikyamm/authentication/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/authenticationn/myprofile.dart';
// import 'package:flutter/material.dart';



// class ProfilePages extends StatelessWidget {
//   final String userEmail; // Accept email as a parameter

//   // Constructor to accept the email
//   const ProfilePages({super.key, required this.userEmail});

//    @override
//   Widget build(BuildContext context) {
//     return ProfileScreen(userEmail: userEmail); // Pass userEmail to ProfileScreen
//   }
// }


// class ProfileScreen extends StatelessWidget {
//   final String userEmail; // Accept userEmail here

//   // Constructor to initialize userEmail
//   const ProfileScreen({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MainColors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             Hero(
//               tag: 'profile-pic',
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage('assets/images/profile.png'),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         print('Edit photo tapped');
//                       },
//                       child: CircleAvatar(
//                         radius: 15,
//                         backgroundColor: MainColors.white,
//                         child: Icon(Icons.edit, color: Colors.blue, size: 18),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               "Username", // Replace with dynamic username if available
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Email: $userEmail', // Display the email here
//               style: TextStyle(
//                 fontSize: 16,
//                 color: hint.customGray,
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     Icon(Icons.directions_walk, color: AppColors.Success),
//                     SizedBox(height: 5),
//                     Text(
//                       "1,243",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Steps",
//                       style: TextStyle(color: hint.customGray),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Icon(Icons.favorite, color: AppColors.Failure),
//                     SizedBox(height: 5),
//                     Text(
//                       "50",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "bpm",
//                       style: TextStyle(color: hint.customGray),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Icon(Icons.water_drop, color:AppColors.blue),
//                     SizedBox(height: 5),
//                     Text(
//                       "1,345",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "ml",
//                       style: TextStyle(color: hint.customGray),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView(
//                 children: [
//                   ProfileMenuItem(
//                     icon: Icons.person,
//                     text: "My Profile",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               Myprofile(userEmail: userEmail)
//                         ),
//                       );
//                     },
//                   ),
//                   ProfileMenuItem(
//                     icon: Icons.favorite,
//                     text: "My Favorite",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DetailScreen(title: "My Favorite"),
//                         ),
//                       );
//                     },
//                   ),
//                   ProfileMenuItem(
//                     icon: Icons.fitness_center,
//                     text: "Workout Setting",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DetailScreen(title: "Workout Setting"),
//                         ),
//                       );
//                     },
//                   ),
//                   ProfileMenuItem(
//                     icon: Icons.settings,
//                     text: "General Setting",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DetailScreen(title: "General Setting"),
//                         ),
//                       );
//                     },
//                   ),
//                   ProfileMenuItem(
//                     icon: Icons.star,
//                     text: "Rate Us",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DetailScreen(title: "Rate Us"),
//                         ),
//                       );
//                     },
//                   ),
//                   ProfileMenuItem(
//                     icon: Icons.help,
//                     text: "Help Center",
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DetailScreen(title: "Help Center"),
//                         ),
//                       );
//                     },
//                   ),
//                   ProfileMenuItem(
//                     icon: Icons.logout_outlined,
//                     text: "Log Out",
//                     onTap: () {
//                       _logout(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _logout(BuildContext context) async {
//     await DBHelper().clearLoginState(); // Clear login state in SQLite

//     // Navigate to the LoginScreen and remove all previous routes from the stack
//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       '/login', // The route name for the LoginScreen (define this in your routes)
//       (Route<dynamic> route) => false, // Removes all previous routes
//     );
//   }
// }

// class ProfileMenuItem extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final VoidCallback onTap;

//   const ProfileMenuItem(
//       {super.key, required this.icon, required this.text, required this.onTap});

//   @override 
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: ListTile(
//           leading: Icon(icon, color: Colors.black),
//           title: Text(
//             text,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           trailing: Icon(Icons.arrow_forward_ios, color: hint.customGray, size: 16),
//         ),
//       ),
//     );
//   }
// }

// class DetailScreen extends StatelessWidget {
//   final String title;

//   const DetailScreen({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: AppColors.Failure,
//       ),
//       body: Center(
//         child: Text(
//           "$title Page",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// class ChangePhotoScreen extends StatelessWidget {
//   const ChangePhotoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Change Photo"),
//         backgroundColor: AppColors.Failure,
//       ),
//       body: Center(
//         child: Hero(
//           tag: 'profile-pic',
//           child: CircleAvatar(
//             radius: 100,
//             backgroundImage: AssetImage(
//                 'assets/images/profile.png'), // Replace with your profile image
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:aikyamm/authentication/Cache/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/authenticationn/myprofile.dart';
// import 'package:flutter/material.dart';

// class ProfilePages extends StatelessWidget {
//   final String userEmail;

//   const ProfilePages({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return ProfileScreen(userEmail: userEmail); // Pass userEmail to ProfileScreen
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   final String userEmail;

//   const ProfileScreen({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(245, 245, 245, 1), // Light background color
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             _buildProfileSection(),
//             SizedBox(height: 30),
//             _buildUserStats(),
//             SizedBox(height: 30),
//             _buildProfileMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection() {
//     return Center(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Hero(
//             tag: 'profile-pic',
//             child: Container(
//               height: 160,
//               width: 160,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [
//                     Color.fromRGBO(143, 0, 0, 1), // Deep red
//                     Color.fromRGBO(255, 87, 34, 1), // Warm orange
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 15,
//                     offset: Offset(0, 6),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               print('Profile image tapped');
//             },
//             child: CircleAvatar(
//               radius: 70,
//               backgroundImage: AssetImage('assets/images/profile.png'),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: GestureDetector(
//               onTap: () {
//                 print('Edit photo tapped');
//               },
//               child: CircleAvatar(
//                 radius: 28,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.edit, color: Color.fromRGBO(143, 0, 0, 1), size: 24),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserStats() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildStatItem(Icons.directions_walk, "1,243", "Steps", Color.fromRGBO(143, 0, 0, 1)),
//         _buildStatItem(Icons.favorite, "50", "bpm", Color.fromRGBO(255, 87, 34, 1)),
//         _buildStatItem(Icons.water_drop, "1,345", "ml", Color.fromRGBO(0, 150, 136, 1)), // Teal color
//       ],
//     );
//   }

//   Widget _buildStatItem(IconData icon, String value, String label, Color iconColor) {
//     return Column(
//       children: [
//         Icon(icon, color: iconColor, size: 35),
//         SizedBox(height: 8),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Color.fromRGBO(136, 136, 136, 1), // Light gray text
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProfileMenu(BuildContext context) {
//     return Column(
//       children: [
//         ProfileMenuItem(
//           icon: Icons.person,
//           text: "My Profile",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Myprofile(userEmail: userEmail),
//               ),
//             );
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.favorite,
//           text: "My Favorite",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(title: "My Favorite"),
//               ),
//             );
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.fitness_center,
//           text: "Workout Settings",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(title: "Workout Settings"),
//               ),
//             );
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.settings,
//           text: "General Settings",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(title: "General Settings"),
//               ),
//             );
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.star,
//           text: "Rate Us",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(title: "Rate Us"),
//               ),
//             );
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.help,
//           text: "Help Center",
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailScreen(title: "Help Center"),
//               ),
//             );
//           },
//         ),
//         ProfileMenuItem(
//           icon: Icons.logout_outlined,
//           text: "Log Out",
//           onTap: () {
//             _logout(context);
//           },
//         ),
//       ],
//     );
//   }

//   Future<void> _logout(BuildContext context) async {
//     await DBHelper().clearLoginState(); // Clear login state in SQLite

//     Navigator.pushNamedAndRemoveUntil(
//       context,
//       '/login', // The route name for the LoginScreen (define this in your routes)
//       (Route<dynamic> route) => false, // Removes all previous routes
//     );
//   }
// }

// class ProfileMenuItem extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final VoidCallback onTap;

//   const ProfileMenuItem({super.key, required this.icon, required this.text, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: ListTile(
//           leading: Icon(icon, color: Color.fromRGBO(143, 0, 0, 1)), // Deep red for icons
//           title: Text(
//             text,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(136, 136, 136, 1), size: 20),
//         ),
//       ),
//     );
//   }
// }

// class DetailScreen extends StatelessWidget {
//   final String title;

//   const DetailScreen({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: Color.fromRGBO(143, 0, 0, 1), // Deep red
//       ),
//       body: Center(
//         child: Text(
//           "$title Page",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }


import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/authenticationn/myprofile.dart';
import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:flutter/material.dart';

class ProfilePages extends StatelessWidget {
  final String userEmail;

  const ProfilePages({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(userEmail: userEmail); // Pass userEmail to ProfileScreen
  }
}

class ProfileScreen extends StatelessWidget {
  final String userEmail;

  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1), // Light background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildProfileSection(),
            SizedBox(height: 25),
            _buildUserStats(),
            SizedBox(height: 30),
            _buildProfileMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'profile-pic',
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(143, 0, 0, 1), // Deep red
                    Color.fromRGBO(255, 87, 34, 1), // Warm orange
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('Profile image tapped');
            },
            child: CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                print('Edit photo tapped');
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, color: Color.fromRGBO(143, 0, 0, 1), size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(Icons.directions_walk, "1,243", "Steps", Color.fromRGBO(143, 0, 0, 1)),
        _buildStatItem(Icons.favorite, "50", "bpm", Color.fromRGBO(255, 87, 34, 1)),
        _buildStatItem(Icons.water_drop, "1,345", "ml", Color.fromRGBO(0, 150, 136, 1)), // Teal color
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 30),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color.fromRGBO(136, 136, 136, 1), // Light gray text
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.person,
          text: "My Profile",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProfile(userEmail: userEmail),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.favorite,
          text: "My Favorite",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(title: "My Favorite"),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.fitness_center,
          text: "Workout Settings",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(title: "Workout Settings"),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.settings,
          text: "General Settings",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(title: "General Settings"),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.star,
          text: "Rate Us",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(title: "Rate Us"),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.help,
          text: "Help Center",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(title: "Help Center"),
              ),
            );
          },
        ),
        ProfileMenuItem(
          icon: Icons.logout_outlined,
          text: "Log Out",
          onTap: () {
              logout(context);
          },
        ),
      ],
    );
  }

//   Future<void> _logout(BuildContext context) async {
//     await DBHelper().clearLoginState(); // Clear login state in SQLite

//     Navigator.pop(
//       context,
//  // The route name for the LoginScreen (define this in your routes)
//       (Route<dynamic> route) => false, // Removes all previous routes
//     );
//   }
// Future<void> logout() async {
//   // Set the login state to false (logged out)
//   await DBHelper().setLoginState(false, email: null);
// }
Future<void> logout(BuildContext context) async {
  // Set the login state to false (logged out)
  await DBHelper().setLoginState(false, email: null);

  // Navigate to the signup screen after logging out
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your Signup screen widget
  );
}

}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Color.fromRGBO(143, 0, 0, 1)), // Deep red for icons
          title: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(136, 136, 136, 1), size: 18),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title;

  const DetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(143, 0, 0, 1), // Deep red
      ),
      body: Center(
        child: Text(
          "$title Page",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
