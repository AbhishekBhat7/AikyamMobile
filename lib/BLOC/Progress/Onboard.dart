import 'package:aikyamm/authentication/authenticationn/dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define Events
abstract class FormEvent {}

class NameChanged extends FormEvent {
  final String name;
  NameChanged(this.name);
}

class GenderChanged extends FormEvent {
  final String gender;
  GenderChanged(this.gender);
}

class DateOfBirthChanged extends FormEvent {
  final DateTime dateOfBirth;
  DateOfBirthChanged(this.dateOfBirth);
}

class WeightChanged extends FormEvent {
  final int weight;
  WeightChanged(this.weight);
}

class HeightChanged extends FormEvent {
  final int height;
  HeightChanged(this.height);
}

class SubmitForm extends FormEvent {}

// Define States
abstract class FormState {}

class FormInitial extends FormState {}

class FormValid extends FormState {}

class FormInvalid extends FormState {}

// BLoC to manage form state
class FormBloc extends Bloc<FormEvent, FormState> {
  String name = '';
  String gender = '';
  DateTime? dateOfBirth;
  int weight = 60;
  int height = 160;

  FormBloc() : super(FormInitial());

  @override
  Stream<FormState> mapEventToState(FormEvent event) async* {
    if (event is NameChanged) {
      name = event.name;
    } else if (event is GenderChanged) {
      gender = event.gender;
    } else if (event is DateOfBirthChanged) {
      dateOfBirth = event.dateOfBirth;
    } else if (event is WeightChanged) {
      weight = event.weight;
    } else if (event is HeightChanged) {
      height = event.height;
    } else if (event is SubmitForm) {
      if (name.isNotEmpty && gender.isNotEmpty && dateOfBirth != null && weight > 0 && height > 0) {
        yield FormValid();
      } else {
        yield FormInvalid();
      }
    }
  }
}

class OnboardingScreen extends StatefulWidget {
  final String userEmail;  // Pass the email here

  const OnboardingScreen({super.key, required this.userEmail});

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

  void nextScreen() {
    if (currentIndex < screens.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void previousScreen() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void submitData(FormBloc formBloc) async {
    if (formBloc.state is FormValid) {
      try {
        final String apiUrl = "https://demoaikyam.azurewebsites.net/api/details";
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': widget.userEmail,
            'name': formBloc.name,
            'gender': formBloc.gender,
            'dob': DateFormat('yyyy-MM-dd').format(formBloc.dateOfBirth!),
            'weight': formBloc.weight,
            'height': formBloc.height,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage(userEmail: widget.userEmail)),
            (Route<dynamic> route) => false,
          );
        } else {
          throw Exception('Failed to update user details');
        }
      } catch (e) {
        print("Error submitting user data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting user data')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / screens.length;

    return BlocProvider(
      create: (context) => FormBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/images/Vectors.svg',
                    height: 280,
                    width: 280,
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
                          BlocBuilder<FormBloc, FormState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () => submitData(context.read<FormBloc>()),
                                child: const CircleAvatar(
                                  backgroundColor: Color(0xFF8F0000),
                                  radius: 30,
                                  child: Icon(Icons.check, color: Colors.white),
                                ),
                              );
                            },
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
      ),
    );
  }
}

// Name Input Widget
class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 90),
                SvgPicture.asset(
                  'assets/images/first.svg',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 25),
                const Text("How can we remember you?",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      context.read<FormBloc>().add(NameChanged(value));
                    },
                    style: const TextStyle(
                      color: Color(0xFF8F0000),
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Your Name',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Gender Input Widget
class GenderInput extends StatelessWidget {
  const GenderInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
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
                      child: _genderIcon('Male', 'assets/images/men.svg', 'male', context),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _genderIcon('Female', 'assets/images/girl.svg', 'female', context),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _genderIcon('Other', 'assets/images/other.svg', 'other', context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _genderIcon(String label, String assetPath, String genderValue, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<FormBloc>().add(GenderChanged(genderValue));
      },
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: genderValue == context.read<FormBloc>().gender ? Colors.red : Colors.grey)),
        ],
      ),
    );
  }
}

// Date Input Widget
class DateInput extends StatelessWidget {
  const DateInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormState>(
      builder: (context, state) {
        DateTime selectedDate = DateTime.now();
        final TextEditingController dateController = TextEditingController();
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 150),
                SvgPicture.asset('assets/images/dob.svg', height: 120, width: 120),
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
                      labelText: 'YYYY-MM-DD',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null && picked != selectedDate) {
                            context.read<FormBloc>().add(DateOfBirthChanged(picked));
                            dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Weight Input Widget
class WeightInput extends StatelessWidget {
  const WeightInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormState>(
      builder: (context, state) {
        int weight = context.read<FormBloc>().weight;
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 130),
                SvgPicture.asset(
                  'assets/images/weight.svg',
                  height: 120,
                  width: 120,
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
                    context.read<FormBloc>().add(WeightChanged(value));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Height Input Widget
class HeightInput extends StatelessWidget {
  const HeightInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormState>(
      builder: (context, state) {
        int height = context.read<FormBloc>().height;
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 130),
                SvgPicture.asset(
                  'assets/images/height.svg',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Height",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "$height cm",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8F0000),
                  ),
                ),
                NumberPicker(
                  value: height,
                  minValue: 100,
                  maxValue: 250,
                  onChanged: (value) {
                    context.read<FormBloc>().add(HeightChanged(value));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
 