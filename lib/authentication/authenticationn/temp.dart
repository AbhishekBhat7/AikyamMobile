import 'package:aikyamm/authentication/authenticationn/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:your_app/athlete_page.dart'; // Replace with your actual page imports
// import 'package:your_app/trainer_page.dart'; // Replace with your actual page imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChoiceScreen(),
    );
  }
}

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select your best suitable choice',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceCard(
                    title: 'Athlete',
                    description:
                        'Limited tools to manage individual or to join trainers\n- Manage your Sports Routine\n- Join Top listed Trainers\n- Personalized content\nAnd many more.',
                    color: Colors.red.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(), // Navigate to Athlete Page
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  ChoiceCard(
                    title: 'Trainer',
                    description:
                        'More tools for better performance of sports team or groups of athletes\n- Connect to Training Smart Devices\n- Create & Manage Sports Team/Group\n- Enhanced Sports Performance Analysis tools\nAnd many more.',
                    color: Colors.red.shade100,
                    badgeText: 'Needs Subscription',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(), // Navigate to Trainer Page
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChoiceCard extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String? badgeText;
  final VoidCallback onTap;

  const ChoiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    this.badgeText,
  });

  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHovering ? widget.color.withOpacity(0.9) : widget.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isHovering)
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
            ],
          ),
          width: 160,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.badgeText != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.badgeText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
