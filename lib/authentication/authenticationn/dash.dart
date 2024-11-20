import 'package:aikyamm/authentication/authenticationn/myprofile.dart';
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
      debugShowCheckedModeBanner: false,
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

  // List of pages in the bottom navigation bar
  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    TeamPage(),
    const SprintsPage(),
    const DevicesPage(),
    const ProfilePage(), // ProfilePage will display user info
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
          'assets/images/logoforsplash.png',
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
                    color: const Color(0xFF8F0000),
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
                    color: const Color(0xFF8F0000),
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
                    color: const Color(0xFF8F0000),
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
                    color: const Color(0xFF8F0000),
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
                    color: const Color(0xFF8F0000),
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
        selectedItemColor: const Color(0xFF8F0000),
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
                image: const AssetImage('assets/images/workout.png'),
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
                        value: 0.67,
                        color: const Color(0xFF8F0000),
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        strokeAlign: 6,
                        strokeWidth: 10,
                      ),
                      const Text(
                        "67%",
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

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   // User data
//   String? name;
//   String? gender;
//   String? dob;
//   int? weight;
//   int? height;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   // Fetch user data from Firestore
//   Future<void> _fetchUserData() async {
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           name = userDoc['name'];
//           gender = userDoc['gender'];
//           dob = userDoc['dob'];
//           weight = userDoc['weight'];
//           height = userDoc['height'];
//         });
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),
//           Text(
//             "Profile Information",
//             style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           name != null
//               ? Text("Name: $name", style: TextStyle(fontSize: 18))
//               : const CircularProgressIndicator(),
//           gender != null
//               ? Text("Gender: $gender", style: TextStyle(fontSize: 18))
//               : const CircularProgressIndicator(),
//           dob != null
//               ? Text("Date of Birth: $dob", style: TextStyle(fontSize: 18))
//               : const CircularProgressIndicator(),
//           weight != null
//               ? Text("Weight: $weight kg", style: TextStyle(fontSize: 18))
//               : const CircularProgressIndicator(),
//           height != null
//               ? Text("Height: $height cm", style: TextStyle(fontSize: 18))
//               : const CircularProgressIndicator(),
//         ],
//       ),
//     );
//   }
// }
