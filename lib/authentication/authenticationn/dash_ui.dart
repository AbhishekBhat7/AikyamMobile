// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
// import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
// // import 'package:aikyamm/authentication/authenticationn/myprofile.dart';
// import 'package:aikyamm/authentication/authenticationn/teampage1.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class Dash extends StatelessWidget {
//   final String userEmail;

//   const Dash({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Dashboard UI',
//       theme: ThemeData(
//         primaryColor: MainColors.primaryColor,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   // List of pages in the bottom navigation bar
//   static final List<Widget> _pages = <Widget>[
//     FitnessDashboard(),
//     TeamPage(),
//     const SprintsPage(),
//     const DevicesPage(),
//     const Profilepage(), // ProfilePage will display user info
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColors.white,
//         elevation: 0,
//         title: Image.asset(
//           'assets/images/logoforsplash.png',
//           height: 70,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black, size: 30),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications, color: Colors.black, size: 30),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Center(
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           child: _pages.elementAt(_selectedIndex),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 0
//                 ? SvgPicture.asset(
//                     'assets/images/Home_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Home_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 1
//                 ? SvgPicture.asset(
//                     'assets/images/Teams_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Teams_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Teams',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 2
//                 ? SvgPicture.asset(
//                     'assets/images/Workout_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Workout_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Sprints',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 3
//                 ? SvgPicture.asset(
//                     'assets/images/Devices_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Devices_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Devices',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 4
//                 ? SvgPicture.asset(
//                     'assets/images/Profile_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Profile_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: MainColors.primaryColor,
//         unselectedItemColor: hint.customGray,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

// // class DashboardPage extends StatelessWidget {
// //   const DashboardPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(12),
// //               gradient: const LinearGradient(
// //                 colors: [Colors.redAccent, Colors.orangeAccent],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //               image: DecorationImage(
// //                 image: const AssetImage('assets/images/workout.png'),
// //                 fit: BoxFit.cover,
// //                 colorFilter: ColorFilter.mode(
// //                     Colors.black.withOpacity(0.3), BlendMode.darken),
// //               ),
// //             ),
// //             height: 180,
// //             child: Stack(
// //               children: [
// //                 const Positioned(
// //                   top: 20,
// //                   left: 20,
// //                   child: Text(
// //                     "My Plan for Today",
// //                     style: TextStyle(
// //                         color: MainColors.white,
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 const Positioned(
// //                   bottom: 20,
// //                   left: 20,
// //                   child: Text(
// //                     "12/18 Complete",
// //                     style: TextStyle(color: MainColors.white, fontSize: 18),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   right: 65,
// //                   top: 80,
// //                   child: Stack(
// //                     alignment: Alignment.center,
// //                     children: [
// //                       CircularProgressIndicator(
// //                         value: 0.67,
// //                         color: MainColors.primaryColor,
// //                         backgroundColor: hint.customGray.withOpacity(0.3),
// //                         strokeAlign: 6,
// //                         strokeWidth: 10,
// //                       ),
// //                       const Text(
// //                         "67%",
// //                         style: TextStyle(
// //                             color: MainColors.white,
// //                             fontSize: 24,
// //                             fontWeight: FontWeight.bold),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// class SprintsPage extends StatelessWidget {
//   const SprintsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Sprints Page"));
//   }
// }

// class DevicesPage extends StatelessWidget {
//   const DevicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Devices Page"));
//   }
// }

// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
// import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
// import 'package:aikyamm/authentication/authenticationn/teampage1.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class Dash extends StatelessWidget {
//   final String userEmail;

//   const Dash({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Dashboard UI',
//       theme: ThemeData(
//         primaryColor: MainColors.primaryColor,
//       ),
//       home: HomePage(userEmail: userEmail), // Pass email here
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   final String userEmail;

//   const HomePage({super.key, required this.userEmail});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   // List of pages in the bottom navigation bar
//   static final List<Widget> _pages = <Widget>[
//     FitnessDashboard(),
//     TeamPage(),
//     const SprintsPage(),
//     const DevicesPage(),
//     // ProfilePage now accepts the email as a parameter
//      ProfilePage(userEmail: ''),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColors.white,
//         elevation: 0,
//         title: Image.asset(
//           'assets/images/logoforsplash.png',
//           height: 70,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black, size: 30),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications, color: Colors.black, size: 30),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Center(
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           child: _pages.elementAt(_selectedIndex),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 0
//                 ? SvgPicture.asset(
//                     'assets/images/Home_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Home_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 1
//                 ? SvgPicture.asset(
//                     'assets/images/Teams_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Teams_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Teams',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 2
//                 ? SvgPicture.asset(
//                     'assets/images/Workout_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Workout_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Sprints',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 3
//                 ? SvgPicture.asset(
//                     'assets/images/Devices_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Devices_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Devices',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 4
//                 ? SvgPicture.asset(
//                     'assets/images/Profile_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Profile_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: MainColors.primaryColor,
//         unselectedItemColor: hint.customGray,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//             if (_selectedIndex == 4) {
//               // Pass the email when navigating to the ProfilePage
//               _pages[4] = ProfilePage(userEmail: widget.userEmail);
//             }
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

// // Profile Page to display user email
// class ProfilePage extends StatelessWidget {
//   final String userEmail;

//   const ProfilePage({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: MainColors.white,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.person,
//                 size: 100,
//                 color: hint.customGray,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'User Email: $userEmail',
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SprintsPage extends StatelessWidget {
//   const SprintsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Sprints Page"));
//   }
// }

// class DevicesPage extends StatelessWidget {
//   const DevicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Devices Page"));
//   }
// }

// import 'package:aikyamm/authentication/DashBoards/Devices/cards.dart';
// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
// import 'package:aikyamm/authentication/authenticationn/teampage1.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class Dash extends StatelessWidget {
//   final String userEmail;

//   const Dash({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Dashboard UI',
//       theme: ThemeData(
//         primaryColor: MainColors.primaryColor,
//       ),
//       home: HomePage(userEmail: userEmail), // Pass email here
//     );
//   }
// } 

// class HomePage extends StatefulWidget {
//   final String userEmail;

//   const HomePage({super.key, required this.userEmail});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   // List of pages in the bottom navigation bar
//   late List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the pages and pass the email to ProfilePage directly
//     _pages = <Widget>[
//       FitnessDashboard(),
//       TeamPage(),
//       const SprintsPage(),
//       TimingGateScreen(),
//       ProfilePage(userEmail: widget.userEmail), // Pass email here
//     ];
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColors.white,
//         elevation: 0,
//         title: Image.asset(
//           'assets/images/logoforsplash.png',
//           height: 70,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black, size: 30),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon:
//                 const Icon(Icons.notifications, color: Colors.black, size: 30),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Center(
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           child: _pages.elementAt(_selectedIndex),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 0
//                 ? SvgPicture.asset(
//                     'assets/images/Home_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Home_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 1
//                 ? SvgPicture.asset(
//                     'assets/images/Teams_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Teams_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Teams',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 2
//                 ? SvgPicture.asset(
//                     'assets/images/Workout_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Workout_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Sprints',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 3
//                 ? SvgPicture.asset(
//                     'assets/images/Devices_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Devices_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Devices',
//           ),
//           BottomNavigationBarItem(
//             icon: _selectedIndex == 4
//                 ? SvgPicture.asset(
//                     'assets/images/Profile_icon.svg',
//                     width: 34,
//                     height: 34,
//                     color: MainColors.primaryColor,
//                   )
//                 : SvgPicture.asset(
//                     'assets/images/Profile_icon.svg',
//                     width: 34,
//                     height: 34,
//                   ),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: MainColors.primaryColor,
//         unselectedItemColor: hint.customGray,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//             if (_selectedIndex == 4) {
//               // Ensure the ProfilePage receives the correct email
//               // _pages[4] = ProfilePage(userEmail: widget.userEmail);
//               _pages[4] = ProfilePages(userEmail: widget.userEmail);
//             }
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

// // Profile Page to display user email
// class ProfilePage extends StatelessWidget {
//   final String userEmail;

//   const ProfilePage({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: MainColors.white,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.person,
//                 size: 100,
//                 color: hint.customGray,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'User Email: $userEmail',
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SprintsPage extends StatelessWidget {
//   const SprintsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Sprints Page"));
//   }
// }

// class DevicesPage extends StatelessWidget {
//   const DevicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Devices Page"));
//   }
// }

