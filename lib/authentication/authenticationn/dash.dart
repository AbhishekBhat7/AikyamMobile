import 'package:aikyamm/authentication/DashBoards/Devices/cards.dart';
import 'package:aikyamm/authentication/DashBoards/HomeDashboard/home.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
import 'package:aikyamm/authentication/authenticationn/teampage1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dash extends StatelessWidget {
  final String userEmail;

  const Dash({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard UI',
      theme: ThemeData(
        primaryColor: MainColors.primaryColor,
      ),
      home: HomePage(userEmail: userEmail), // Pass email here
    );
  }
}

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
    // Initialize the pages and pass the email to ProfilePage directly
    _pages = <Widget>[
      FitnessDashboard(),
      TeamPage(),
      const SprintsPage(),
      TimingGateScreen(),
      // ProfilePage(userEmail: widget.userEmail), // Pass email here
      ProfilePages(userEmail: widget.userEmail)
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
    return (await showDialog(
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
              Navigator.of(context).pop(true); // Exit the app
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignUpPage()));  // Replace the current page
            },
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press here
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MainColors.white,
          elevation: 0,
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
              icon: const Icon(Icons.notifications, color: Colors.black, size: 30),
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
              if (_selectedIndex == 4) {
                // Ensure the ProfilePage receives the correct email
                _pages[4] = ProfilePages(userEmail: widget.userEmail);
              }
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
    return const Center(child: Text("Yet To Come ", style: TextStyle(fontSize: 25, color: MainColors.black),));
  }
}

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Devices Page"));
  }
}
