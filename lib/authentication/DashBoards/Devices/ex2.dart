import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';

class CreateNewConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: MainColors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Device Configurations"),
        actions: [Icon(Icons.more_vert)],
        elevation: 4,
        backgroundColor: MainColors.primaryColor,
         titleTextStyle: TextStyle(
      color: MainColors.white, // White text color for the title
      fontWeight: FontWeight.bold, // Optional: For bold text
      fontSize: 20, // Optional: Adjust font size if needed
    ),
       // Theme color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Configuration",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: MainColors.primaryColor, // Theme color
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
                    backgroundColor: MainColors.primaryColor, // Theme color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Save Configuration",
                    style: TextStyle(color: AppColors.backgroundColor, fontSize: 18),
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
            Icon(Icons.text_fields, color: MainColors.primaryColor), // Icon for text field
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MainColors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: hint.customGray),
            filled: true,
            fillColor: AppColors.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MainColors.primaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 4,
            //     spreadRadius: 1,
            //   ),
            // ],
          ),
        ),
      ],
    );
  }
}

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
            Icon(Icons.arrow_drop_down_circle, color: MainColors.primaryColor), // Icon for dropdown
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MainColors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: 'Select $label',
            hintStyle: TextStyle(color: hint.customGray),
            filled: true,
            fillColor: AppColors.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:MainColors.primaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 4,
            //     spreadRadius: 1,
            //   ),
            // ],
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
            Icon(Icons.toggle_on, color: MainColors.primaryColor), // Icon for switch
            SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MainColors.black,
                fontSize: 16,
              ),
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
          activeColor: MainColors.primaryColor, // Theme color for active switch
          inactiveTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.grey[600],
        ),
      ],
    );
  }
}
