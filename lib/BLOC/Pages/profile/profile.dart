import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/authenticationn/myprofile.dart';
import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:equatable/equatable.dart';

// --- BLoC Events ---
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfileEvent extends ProfileEvent {
  final String userEmail;

  const LoadProfileEvent(this.userEmail);

  @override
  List<Object?> get props => [userEmail];
}

class LogoutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

// --- BLoC States ---
abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final String userEmail;

  const ProfileLoadedState(this.userEmail);

  @override
  List<Object?> get props => [userEmail];
}

class ProfileLogoutState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileErrorState extends ProfileState {
  final String error;

  const ProfileErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// --- BLoC Logic ---
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileEvent) {
      try {
        yield ProfileLoadedState(event.userEmail);
      } catch (error) {
        yield ProfileErrorState('Failed to load profile');
      }
    }

    if (event is LogoutEvent) {
      try {
        await DBHelper().setLoginState(false, email: null);
        yield ProfileLogoutState();
      } catch (error) {
        yield ProfileErrorState('Failed to log out');
      }
    }
  }
}

// --- ProfilePages (Main Widget) ---
class ProfilePages extends StatelessWidget {
  final String userEmail;

  const ProfilePages({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileEvent(userEmail)),
      child: ProfileScreen(userEmail: userEmail),
    );
  }
}

// --- ProfileScreen (UI with BLoC integration) ---
class ProfileScreen extends StatelessWidget {
  final String userEmail;

  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            return SingleChildScrollView(
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
            );
          } else if (state is ProfileErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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
                    Color.fromRGBO(143, 0, 0, 1),
                    Color.fromRGBO(255, 87, 34, 1),
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
        _buildStatItem(Icons.directions_walk, "1,243", "Steps", MainColors.primaryColor),
        _buildStatItem(Icons.favorite, "50", "bpm", AppColors.accentColor),
        _buildStatItem(Icons.water_drop, "1,345", "ml", AppColors.secondaryColor),
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
            color: MainColors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: hint.customGray,
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
            BlocProvider.of<ProfileBloc>(context).add(LogoutEvent());
          },
        ),
      ],
    );
  }
}

// --- ProfileMenuItem Widget ---
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
        ),
        child: ListTile(
          leading: Icon(icon, color: MainColors.primaryColor),
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

// --- DetailScreen Widget ---
class DetailScreen extends StatelessWidget {
  final String title;

  const DetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: MainColors.primaryColor,
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

// --- Logout logic ---
// Call logout in BLoC (already handled in the BLoC)
Future<void> logout(BuildContext context) async {
  // Set the login state to false (logged out)
  await DBHelper().setLoginState(false, email: null);

  // Navigate to the signup screen after logging out
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your Signup screen widget
  );
}