import 'package:aikyamm/authentication/authenticationn/profilepage.dart';
import 'package:aikyamm/authentication/authenticationn/teampage1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const Dash());
}

class Dash extends StatelessWidget {
  const Dash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This removes the debug banner
      title: 'Dashboard UI',
      theme: ThemeData(
        primaryColor: const Color(0xFF8F0000),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override 
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    TeamPage(),
    const SprintsPage(),
    const DevicesPage(),
    Profilepage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/logoforsplash.png', // Update with your logo
          height: 70, // Increased logo size
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon:
                const Icon(Icons.notifications, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(
              milliseconds: 500), // Duration for smoother transition
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
                opacity: animation, child: child); // Smooth fade effect
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
                    color:
                        const Color(0xFF8F0000), // Make icon red when selected
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
                    color:
                        const Color(0xFF8F0000), // Make icon red when selected
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
                    color:
                        const Color(0xFF8F0000), // Make icon red when selected
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
                    color:
                        const Color(0xFF8F0000), // Make icon red when selected
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
                    color:
                        const Color(0xFF8F0000), // Make icon red when selected
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
        selectedItemColor:
            const Color(0xFF8F0000), // This controls the text color
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: const AssetImage(
                    'assets/images/workout.png'), // Add your background image
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
            ),
            height: 180,
            child: Stack(
              children: [
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    "My Plan for Today",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "12/18 Complete",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Positioned(
                  right: 65,
                  top: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0.67, // 67% complete
                        color: const Color(0xFF8F0000),
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        strokeAlign: 6,
                        strokeWidth: 10, // Bigger progress indicator
                      ),
                      const Text(
                        "67%", // Percentage text inside the progress indicator
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SprintsPage extends StatelessWidget {
  const SprintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Sprints Page"));
  }
}

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Devices Page"));
  }
}
