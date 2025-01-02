 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Define the events
abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {
  final String userEmail;

  FetchProfileEvent(this.userEmail);
}

class UpdateProfileEvent extends ProfileEvent {
  final String userEmail;
  final String name;
  final String gender;
  final String dob;
  final String email;
  final double weight;
  final double height;

  UpdateProfileEvent({
    required this.userEmail,
    required this.name,
    required this.gender,
    required this.dob,
    required this.email,
    required this.weight,
    required this.height,
  });
}

// Define the states
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String gender;
  final String email;
  final String dob;
  final double weight;
  final double height;

  ProfileLoaded({
    required this.name,
    required this.gender,
    required this.email,
    required this.dob,
    required this.weight,
    required this.height,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

// ProfileBloc implementation
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchProfileEvent) {
      yield ProfileLoading();
      try {
        final response = await http.get(Uri.parse('https://demoaikyam.azurewebsites.net/api/details/${event.userEmail}'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['user'] != null) {
            yield ProfileLoaded(
              name: data['user']['name'],
              gender: data['user']['gender'],
              email: data['user']['email'],
              dob: data['user']['date_of_birth'],
              weight: double.tryParse(data['user']['weight'].toString()) ?? 0.0,
              height: double.tryParse(data['user']['height'].toString()) ?? 0.0,
            );
          }
        } else {
          yield ProfileError("Error fetching profile data");
        }
      } catch (e) {
        yield ProfileError("Error fetching profile data: $e");
      }
    } else if (event is UpdateProfileEvent) {
      yield ProfileLoading();
      try {
        final response = await http.put(
          Uri.parse('https://demoaikyam.azurewebsites.net/api/updateprofile/details/${event.userEmail}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'role': 'athlete',
            'name': event.name,
            'gender': event.gender,
            'date_of_birth': event.dob,
            'email': event.email,
            'weight': event.weight,
            'height': event.height,
          }),
        );

        if (response.statusCode == 200) {
          yield ProfileLoaded(
            name: event.name,
            gender: event.gender,
            email: event.email,
            dob: event.dob,
            weight: event.weight,
            height: event.height,
          );
        } else {
          yield ProfileError("Error updating profile");
        }
      } catch (e) {
        yield ProfileError("Error updating profile: $e");
      }
    }
  }
}

class MyProfile extends StatefulWidget {
  final String userEmail;

  const MyProfile({super.key, required this.userEmail});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfile> {
  // Text controllers for editable fields
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // Dispatch the event only when the widget is fully initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure ProfileBloc is available before dispatching event
      final profileBloc = context.read<ProfileBloc>();
      profileBloc.add(FetchProfileEvent(widget.userEmail));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(), // Provide ProfileBloc here
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Color.fromRGBO(143, 0, 0, 1),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              // Make sure to update the text controllers with the loaded profile data
              nameController.text = state.name;
              genderController.text = state.gender;
              emailController.text = state.email;
              dobController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(state.dob));
              weightController.text = state.weight.toStringAsFixed(2);
              heightController.text = state.height.toStringAsFixed(2);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField("Name", nameController, isEditing),
                      _buildTextField("Gender", genderController, isEditing),
                      GestureDetector(
                        onTap: _showEmailMessage,
                        child: AbsorbPointer(child: _buildTextField("Email", emailController, false)),
                      ),
                      _buildTextField("Date of Birth", dobController, isEditing),
                      _buildTextField("Weight (kg)", weightController, isEditing, keyboardType: TextInputType.number),
                      _buildTextField("Height (cm)", heightController, isEditing, keyboardType: TextInputType.number),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _toggleEditMode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(143, 0, 0, 1),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text(isEditing ? "Cancel" : "Edit"),
                          ),
                          if (isEditing) const SizedBox(width: 20),
                          if (isEditing)
                            ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(143, 0, 0, 1),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text("Save Changes"),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
            }
            return Center(child: Text("Profile not loaded"));
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isEditable, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromRGBO(143, 0, 0, 1), width: 2),
          ),
        ),
        readOnly: !isEditable,
        keyboardType: keyboardType,
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    if (nameController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty) {
      context.read<ProfileBloc>().add(UpdateProfileEvent(
        userEmail: widget.userEmail,
        name: nameController.text,
        gender: genderController.text,
        dob: dobController.text,
        email: emailController.text,
        weight: double.tryParse(weightController.text) ?? 0.0,
        height: double.tryParse(heightController.text) ?? 0.0,
      ));
      _toggleEditMode();
    } else {
      _showEmailMessage();
    }
  }

  void _showEmailMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email"),
          content: Text("The email cannot be edited as it is unique to the user."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
