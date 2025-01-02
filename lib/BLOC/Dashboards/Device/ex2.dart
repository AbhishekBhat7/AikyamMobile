import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC classes
class ConfigurationEvent {}

class SaveConfigurationEvent extends ConfigurationEvent {}

class ConfigurationState {}

class ConfigurationInitialState extends ConfigurationState {}

class ConfigurationSavedState extends ConfigurationState {}

// BLoC Implementation
class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  ConfigurationBloc() : super(ConfigurationInitialState());

  @override
  Stream<ConfigurationState> mapEventToState(ConfigurationEvent event) async* {
    if (event is SaveConfigurationEvent) {
      yield ConfigurationSavedState(); // Simulate saving configuration
    }
  }
}

// Main page with BLoC
class CreateNewConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfigurationBloc(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: MainColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Device Configurations",
            style: TextStyle(color: MainColors.white),
          ),
          actions: [Icon(Icons.more_vert)],
          backgroundColor: MainColors.primaryColor,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: BlocListener<ConfigurationBloc, ConfigurationState>(
            listener: (context, state) {
              if (state is ConfigurationSavedState) {
                // Show a message when configuration is saved
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Configuration Saved"),
                ));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create New Configuration",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color:MainColors.primaryColor,
                  ),
                ),
                SizedBox(height: 30),
                CustomTextField(label: "Name"),
                SizedBox(height: 16),
                CustomDropdown(label: "Sprint Type", items: ["Jump", "Run"]),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                          label: "Num. of Gates", items: ["2", "4", "6"]),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown(
                          label: "Arrangement", items: ["Linear", "Circular"]),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                          label: "Start Type", items: ["Dash", "Jump"]),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown(
                          label: "End Type", items: ["Dash", "Stop"]),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                CustomSwitch(label: "Buzzer Commands"),
                CustomSwitch(label: "LED Commands"),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:MainColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        // Trigger save event
                        BlocProvider.of<ConfigurationBloc>(context)
                            .add(SaveConfigurationEvent());
                      },
                      child: Text(
                        "Save Configuration",
                        style: TextStyle(color: MainColors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final String label;
  const CustomTextField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.text_fields, color: MainColors.primaryColor),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MainColors.primaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }
}

// Custom Dropdown Widget
class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;

  const CustomDropdown({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_drop_down_circle, color: MainColors.primaryColor),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: 'Select $label',
            filled: true,
            fillColor: hint.customGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MainColors.primaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }
}

// Custom Switch Widget
class CustomSwitch extends StatefulWidget {
  final String label;

  const CustomSwitch({required this.label});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.toggle_on, color: MainColors.primaryColor),
            SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
          },
          activeColor: MainColors.primaryColor,
          inactiveTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.grey[600],
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(home: CreateNewConfigurationPage()));
}
