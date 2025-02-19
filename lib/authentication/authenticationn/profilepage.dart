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
      backgroundColor: AppColors.backgroundColor, // Light background color
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
                backgroundColor: AppColors.backgroundColor,
                child: Icon(Icons.edit, color: MainColors.primaryColor, size: 20),
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
        _buildStatItem(Icons.directions_walk, "1,243", "Steps",MainColors.primaryColor),
        _buildStatItem(Icons.favorite, "50", "bpm", AppColors.accentColor),
        _buildStatItem(Icons.water_drop, "1,345", "ml", AppColors.secondaryColor), // Teal color
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
            color:MainColors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color:hint.customGray, // Light gray text
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
          color: MainColors.white, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // color: MainColors.black,
              // blurRadius: 8,
              // offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: MainColors.primaryColor), // Deep red for icons
          title: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: MainColors.black,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: hint.customGray, size: 18),
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
        backgroundColor:MainColors.primaryColor, // Deep red
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
