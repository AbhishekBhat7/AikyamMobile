import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:aikyamm/authentication/authenticationn/prog.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ChoiceScreen extends StatelessWidget {
  final String userEmail;

  const ChoiceScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChoiceBloc(),
      child: Scaffold(
        backgroundColor: MainColors.white,
        body: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: SvgPicture.asset(
                'assets/images/Vectors.svg',
                height: 270,
                width: 270,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 10,
              child: SvgPicture.asset(
                'assets/images/bottomsvgss.svg',
                height: 250,
                width: 250,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select Your Best Suitable Choice",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MainColors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              context.read<ChoiceBloc>().add(RoleSelected('athlete', userEmail));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnboardingScreen(userEmail: userEmail),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: ChoiceCard(
                              title: "Athlete",
                              description: [
                                "Manage your Sports Routine's",
                                "Join Top listed Trainers",
                                "Personalized content.",
                                "And many more.",
                              ],
                              backgroundColor: Colors.orange.shade50,
                              borderColor: Colors.deepOrangeAccent,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              context.read<ChoiceBloc>().add(RoleSelected('trainer', userEmail));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrainerScreen(),
                                ),
                              );
                            },
                            child: ChoiceCard(
                              title: "Trainer",
                              description: [
                                "Connect to Training Smart Devices",
                                "Create & Manage Sports Team/Group",
                                "Enhanced Sports Performance Analysis tools",
                                "And many more.",
                              ],
                              backgroundColor: Colors.orange.shade50,
                              borderColor: Colors.deepOrangeAccent,
                              subscriptionLabel: "Needs Subscription",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  final String title;
  final List<String> description;
  final Color backgroundColor;
  final Color borderColor;
  final String? subscriptionLabel;

  const ChoiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.borderColor,
    this.subscriptionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, MainColors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subscriptionLabel != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subscriptionLabel!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
          Hero(
            tag: title,
            child: Text(
              title,
              style: TextStyle(
                color: borderColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          ...description.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "• $item",
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trainer"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Hero(
          tag: "Trainer",
          child: Text(
            "Welcome to Trainer Page",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// BLoC Implementation

// State class to handle the state of role selection
abstract class ChoiceState {}

class InitialChoiceState extends ChoiceState {}

class RoleUpdatedState extends ChoiceState {
  final String role;
  RoleUpdatedState(this.role);
}

// Event class to handle user role selection
abstract class ChoiceEvent {}

class RoleSelected extends ChoiceEvent {
  final String role;
  final String userEmail;

  RoleSelected(this.role, this.userEmail);
}

// BLoC class to handle role selection
class ChoiceBloc extends Bloc<ChoiceEvent, ChoiceState> {
  ChoiceBloc() : super(InitialChoiceState());

  @override
  Stream<ChoiceState> mapEventToState(ChoiceEvent event) async* {
    if (event is RoleSelected) {
      await updateUserRole(event.role, event.userEmail);
      yield RoleUpdatedState(event.role);
    }
  }

  Future<void> updateUserRole(String role, String userEmail) async {
    final url = Uri.parse('https://demoaikyam.azurewebsites.net/api/role');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': userEmail,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      print('Role updated successfully');
    } else {
      print('Failed to update role');
    }
  }
}
