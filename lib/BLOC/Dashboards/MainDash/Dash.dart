// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/services.dart'; // Import for SystemNavigator.pop
// import 'package:aikyamm/authentication/DashBoards/Devices/cards.dart';
// import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
// import 'package:aikyamm/authentication/authenticationn/teampage1.dart';

// // BLoC for Bottom Navigation
// enum BottomNavEvent { home, team, sprints, devices, profile }

// class BottomNavCubit extends Cubit<int> {
//   BottomNavCubit() : super(0);

//   void selectPage(int index) {
//     emit(index);
//   }
// }

// // BLoC for Back Button Handling
// class BackButtonCubit extends Cubit<bool> {
//   BackButtonCubit() : super(false);

//   void confirmExit(bool value) {
//     emit(value);
//   }
// }

// class HomePage extends StatelessWidget {
//   final String userEmail;

//   const HomePage({super.key, required this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => BottomNavCubit(),
//       child: BlocProvider(
//         create: (context) => BackButtonCubit(),
//         child: WillPopScope(
//           onWillPop: () async {
//             return await _onWillPop(context);
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: MainColors.white,
//               elevation: 0,
//               leading: null,
//               automaticallyImplyLeading: false,
//               title: SvgPicture.asset(
//                 'assets/images/logoforsplash.svg',
//                 height: 70,
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.search, color: Colors.black, size: 30),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.notifications,
//                       color: Colors.black, size: 30),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             body: BlocBuilder<BottomNavCubit, int>(
//               builder: (context, selectedIndex) {
//                 return Center(
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 500),
//                     transitionBuilder: (Widget child, Animation<double> animation) {
//                       return FadeTransition(opacity: animation, child: child);
//                     },
//                     child: _pages(context, selectedIndex),
//                   ),
//                 );
//               },
//             ),
//             bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
//               builder: (context, selectedIndex) {
//                 return BottomNavigationBar(
//                   items: <BottomNavigationBarItem>[
//                     BottomNavigationBarItem(
//                       icon: _selectedIcon(context, 0, 'Home_icon'),
//                       label: 'Home',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: _selectedIcon(context, 1, 'Teams_icon'),
//                       label: 'Teams',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: _selectedIcon(context, 2, 'Workout_icon'),
//                       label: 'Sprints',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: _selectedIcon(context, 3, 'Devices_icon'),
//                       label: 'Devices',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: _selectedIcon(context, 4, 'Profile_icon'),
//                       label: 'Profile',
//                     ),
//                   ],
//                   currentIndex: selectedIndex,
//                   selectedItemColor: MainColors.primaryColor,
//                   unselectedItemColor: hint.customGray,
//                   onTap: (index) {
//                     context.read<BottomNavCubit>().selectPage(index);
//                     if (index == 4) {
//                       context.read<BottomNavCubit>().selectPage(4);
//                     }
//                   },
//                   type: BottomNavigationBarType.fixed,
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _pages(BuildContext context, int selectedIndex) {
//     List<Widget> pages = [
//       FitnessDashboard(),
//       TeamDashboard(),
//       const SprintsPage(),
//       TimingGateScreen(),
//       ProfilePages(userEmail: userEmail), // Pass email here
//     ];

//     return pages[selectedIndex];
//   }

//   Widget _selectedIcon(BuildContext context, int index, String asset) {
//     final selectedIndex = context.watch<BottomNavCubit>().state;
//     return SvgPicture.asset(
//       'assets/images/$asset.svg',
//       width: 34,
//       height: 34,
//       color: selectedIndex == index
//           ? MainColors.primaryColor
//           : Colors.black.withOpacity(0.6),
//     );
//   }

//   Future<bool> _onWillPop(BuildContext context) async {
//     final backButtonCubit = context.read<BackButtonCubit>();
//     backButtonCubit.confirmExit(false);

//     final bool? exit = await showDialog<bool>(
//       context: context,
//       builder: (context) => BlocBuilder<BackButtonCubit, bool>(
//         builder: (context, state) {
//           return AlertDialog(
//             title: const Text('Exit App'),
//             content: const Text('Do you want to exit?'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('No'),
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//               ),
//               TextButton(
//                 child: const Text('Yes'),
//                 onPressed: () {
//                   SystemNavigator.pop();
//                   Navigator.of(context).pop(true);
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     return exit ?? false;
//   }
// }

// class SprintsPage extends StatelessWidget {
//   const SprintsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//         child: Text("Coming Soon!!!!!!!!!! ",
//             style: TextStyle(
//                 fontSize: 25,
//                 color: MainColors.black,
//                 backgroundColor: AppColors.yellow)));
//   }
// }

// class DevicesPage extends StatelessWidget {
//   const DevicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Devices Page"));
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator.pop
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/cards.dart';
import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
import 'package:aikyamm/authentication/authenticationn/teampage1.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages in the bottom navigation bar
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      FitnessDashboard(),
      TeamDashboard(),
      const SprintsPage(),
      TimingGateScreen(),
      ProfilePages(userEmail: widget.userEmail),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle back button press to show confirmation dialog
  Future<bool> _onWillPop() async {
    // Show confirmation dialog when the user presses the back button
    bool? exitApp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false); // Stay on the current screen
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true); // Close the dialog
              SystemNavigator.pop(); // This will close the app
            },
          ),
        ],
      ),
    );

    return exitApp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press here
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MainColors.white,
          elevation: 0,
          leading: null,
          automaticallyImplyLeading: false,
          title: SvgPicture.asset(
            'assets/images/logoforsplash.svg',
            height: 70,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black, size: 30),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications,
                  color: Colors.black, size: 30),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _pages.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? SvgPicture.asset(
                      'assets/images/Home_icon.svg',
                      width: 34,
                      height: 34,
                      color: MainColors.primaryColor,
                    )
                  : SvgPicture.asset(
                      'assets/images/Home_icon.svg',
                      width: 34,
                      height: 34,
                    ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? SvgPicture.asset(
                      'assets/images/Teams_icon.svg',
                      width: 34,
                      height: 34,
                      color: MainColors.primaryColor,
                    )
                  : SvgPicture.asset(
                      'assets/images/Teams_icon.svg',
                      width: 34,
                      height: 34,
                    ),
              label: 'Teams',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? SvgPicture.asset(
                      'assets/images/Workout_icon.svg',
                      width: 34,
                      height: 34,
                      color: MainColors.primaryColor,
                    )
                  : SvgPicture.asset(
                      'assets/images/Workout_icon.svg',
                      width: 34,
                      height: 34,
                    ),
              label: 'Sprints',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? SvgPicture.asset(
                      'assets/images/Devices_icon.svg',
                      width: 34,
                      height: 34,
                      color: MainColors.primaryColor,
                    )
                  : SvgPicture.asset(
                      'assets/images/Devices_icon.svg',
                      width: 34,
                      height: 34,
                    ),
              label: 'Devices',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 4
                  ? SvgPicture.asset(
                      'assets/images/Profile_icon.svg',
                      width: 34,
                      height: 34,
                      color: MainColors.primaryColor,
                    )
                  : SvgPicture.asset(
                      'assets/images/Profile_icon.svg',
                      width: 34,
                      height: 34,
                    ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: MainColors.primaryColor,
          unselectedItemColor: hint.customGray,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

class SprintsPage extends StatelessWidget {
  const SprintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Coming Soon!!!!!!!!!! ",
            style: TextStyle(
                fontSize: 25,
                color: MainColors.black,
                backgroundColor: AppColors.yellow)));
  }
}

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Devices Page"));
  }
}
