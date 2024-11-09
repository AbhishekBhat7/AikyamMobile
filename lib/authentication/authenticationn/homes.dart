import 'package:aikyamm/authentication/authenticationn/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class SelectRoleScreen extends StatelessWidget {
//   final String userId;

//   SelectRoleScreen({required this.userId});

//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ChoiceScreen(),
//       theme: ThemeData(
//         fontFamily: 'Arial',
//         primaryColor: Colors.deepOrangeAccent,
//       ),
//     );
//   }
// }

class ChoiceScreen extends StatelessWidget {
  final String userId;

  const ChoiceScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: SvgPicture.asset(
              'assets/images/Vectors.svg', // Replace with your SVG file path
              height: 270,
              width: 270,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: SvgPicture.asset(
              'assets/images/bottomsvgss.svg', // Replace with your SVG file path
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
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Update the user's role to Athlete in Firestore
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({
                  'role': 'Athlete',
                });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProgressApp(), 
                              ),
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
                          onTap: () {
                            // Update the user's role to Trainer in Firestore
                            FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({
                            'role': 'Trainer',
                });
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
    );
  }
}

class ChoiceCard extends StatelessWidget {
  final String title;
  final List<String> description;
  final Color backgroundColor;
  final Color borderColor;
  final String? subscriptionLabel;

  const ChoiceCard({super.key, 
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
          colors: [backgroundColor, Colors.white],
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

class AthleteScreen extends StatelessWidget {
  const AthleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Athlete"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: Hero(
          tag: "Athlete",
          child: Text(
            "Welcome to Athlete Page",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
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
