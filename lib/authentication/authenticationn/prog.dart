import 'package:aikyamm/authentication/authenticationn/dash1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ProgressApp());
}

class ProgressApp extends StatelessWidget {
  const ProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Flow',
      theme: ThemeData(
        primaryColor: const Color(0xFF8F0000),
      ),
      // home: const OnboardingScreen(),
    );
  }
}
class OnboardingScreen extends StatefulWidget {
  final UserCredential userCredential;

  const OnboardingScreen({super.key, required this.userCredential});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final List<Widget> screens = [
    const NameInput(),
    const GenderInput(),
    const DateInput(),
    const WeightInput(),
    HeightInput(),
  ];

  List<bool> formValidity = [false, false, false, false, false];

  String? name;
  String? gender;
  DateTime? dob;
  int? weight;
  int? height;

  // To track if the current screen's form is valid
  void nextScreen() {
    if (formValidity[currentIndex]) {
      if (currentIndex < screens.length - 1) {
        setState(() {
          currentIndex++;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields to proceed.')),
      );
    }
  }

  void previousScreen() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / screens.length;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/images/Vectors.svg',
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, _) =>
                              LinearProgressIndicator(
                            value: value,
                            color: const Color(0xFF8F0000),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: screens[currentIndex],
                ),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentIndex > 0)
                        GestureDetector(
                          onTap: previousScreen,
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFF8F0000),
                            radius: 30,
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      if (currentIndex == screens.length - 1)
                        GestureDetector(
                          onTap: () async {
                            // Collecting all user data and saving it to Firestore
                            await FirebaseFirestore.instance.collection('usersinfo').doc(widget.userCredential.user!.uid).update({
                              'name': name,
                              'gender': gender,
                              'dob': dob,
                              'weight': weight,
                              'height': height,
                              'onboarding_completed': true, // New field for onboarding status
                            });

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Dash()),
                            );
                          },
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFF8F0000),
                            radius: 30,
                            child: Icon(Icons.check, color: Colors.white),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: nextScreen,
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFF8F0000),
                            radius: 30,
                            child: Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class NameInput extends StatefulWidget {
  const NameInput({super.key});

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 90),
            SvgPicture.asset('assets/images/first.svg', height: 200, width: 200),
            const SizedBox(height: 25),
            const Text("How can we remember you?",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Color(0xFF8F0000), fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Your Name',
                ),
                onChanged: (value) {
                  setState(() {
                    _isValid = value.isNotEmpty;
                    // Update the value in OnboardingScreen
                    (context.findAncestorStateOfType<_OnboardingScreenState>()!)
                        .name = value;
                    (context.findAncestorStateOfType<_OnboardingScreenState>()!)
                        .formValidity[0] = _isValid;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class GenderInput extends StatefulWidget {
  const GenderInput({super.key});

  @override
  _GenderInputState createState() => _GenderInputState();
}

class _GenderInputState extends State<GenderInput> {
  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            const Text(
              "Gender",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8F0000)),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _genderIcon('Male', 'assets/images/men.svg', 'male'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child:
                      _genderIcon('Female', 'assets/images/girl.svg', 'female'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child:
                      _genderIcon('Other', 'assets/images/other.svg', 'other'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderIcon(String label, String assetPath, String genderValue) {
    bool isSelected = selectedGender == genderValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = genderValue;
          // Update the value in OnboardingScreen
          (context.findAncestorStateOfType<_OnboardingScreenState>()!)
              .gender = genderValue;
          (context.findAncestorStateOfType<_OnboardingScreenState>()!)
              .formValidity[1] = true;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(255, 252, 224, 224)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SvgPicture.asset(assetPath, height: 100, width: 100),
            const SizedBox(height: 10),
            Text(label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
class DateInput extends StatefulWidget {
  const DateInput({super.key});

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? selectedDate = DateTime.now();
  final TextEditingController dateController = TextEditingController();

  bool _isValid = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('MM/dd/yyyy').format(picked);
        _isValid = true; // Mark as valid once a date is selected
        // Update the value in OnboardingScreen
        (context.findAncestorStateOfType<_OnboardingScreenState>()!)
            .dob = picked;
        (context.findAncestorStateOfType<_OnboardingScreenState>()!)
            .formValidity[2] = _isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            SvgPicture.asset('assets/images/dob.svg', height: 100, width: 100),
            const SizedBox(height: 20),
            const Text("Date of Birth",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                controller: dateController,
                style: const TextStyle(color: Color(0xFF8F0000), fontSize: 24),
                decoration: InputDecoration(
                  labelText: 'MM/DD/YYYY',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class WeightInput extends StatefulWidget {
  const WeightInput({super.key});

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  int weight = 60; // Default weight value
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            SvgPicture.asset(
              'assets/images/weight.svg',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Weight",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "$weight kg",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8F0000),
              ),
            ),
            NumberPicker(
              value: weight,
              minValue: 30,
              maxValue: 150,
              onChanged: (value) {
                setState(() {
                  weight = value;
                  _isValid = weight >= 30; // Weight must be valid (greater than or equal to 30)
                  // Update the value in OnboardingScreen
                  (context.findAncestorStateOfType<_OnboardingScreenState>()!)
                      .weight = weight;
                  (context.findAncestorStateOfType<_OnboardingScreenState>()!)
                      .formValidity[3] = _isValid;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
class HeightInput extends StatefulWidget {
  int height = 160; // Default height value

  HeightInput({super.key}); // Default height value

  @override
  _HeightInputState createState() => _HeightInputState();
}

class _HeightInputState extends State<HeightInput> {
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            SvgPicture.asset(
              'assets/images/height.svg',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Height",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "${widget.height} cm",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8F0000),
              ),
            ),
            NumberPicker(
              value: widget.height,
              minValue: 100,
              maxValue: 250,
              onChanged: (value) {
                setState(() {
                  widget.height = value;
                  _isValid = widget.height >= 100 && widget.height <= 250; // Height should be within a valid range
                  // Update the value in OnboardingScreen
                  (context.findAncestorStateOfType<_OnboardingScreenState>()!)
                      .height = widget.height;
                  (context.findAncestorStateOfType<_OnboardingScreenState>()!)
                      .formValidity[4] = _isValid;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
