import 'package:aikyamm/authentication/Cache/db_helper.dart';
import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await DBHelper().clearLoginState(); // Clear login state in SQLite

    // Navigate to the LoginScreen and remove all previous routes from the stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // The route name for the LoginScreen (define this in your routes)
      (Route<dynamic> route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Dashboard!')),
    );
  }
}
