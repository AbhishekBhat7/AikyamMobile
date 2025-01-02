import 'package:aikyamm/authentication/DashBoards/Devices/devicedetails.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/ex2.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';

// import '../../../BLE/final2.dart';


class DeviceConfigurationsPage extends StatelessWidget {
  final dynamic device; // The 'device' that was passed from the previous screen

  // Constructor to accept the 'device' data
  const DeviceConfigurationsPage({Key? key, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios_new, color: MainColors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
          onPressed: () {
            Navigator.pop(context); // Should correctly pop the current route
            print("We Back to the page");
          },
        ),

        title: Text("Device Configurations",
            style: TextStyle(color: MainColors.white)),
        actions: [Icon(Icons.more_vert, color: MainColors.white)],
        elevation: 4,
        backgroundColor: MainColors.primaryColor
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Here, you can use the 'device' data to display relevant information
            Text(
                'Device Data: ${device.toString()}'), // Displaying the device info as a string

            ConfigurationCard(
              title: "Create New Configuration",
              icon: Icons.add_circle_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewConfigurationPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ConfigurationCard(
              title: "4 Gate Sprint Run",
              subtitle: "4 Gates\nLast Used 23 Oct\nAttributes 1\nAttributes 2",
              icon: Icons.speed,
            ),
            SizedBox(height: 16),
            ConfigurationCard(
              title: "Device Debug",
              icon: Icons.settings_input_component,
              onTap: () {
                // Passing the `device` data to DeviceDetailsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceDetailsPage(device: device),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigurationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const ConfigurationCard({
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MainColors.primaryColor, LinearColors.Mixer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: MainColors.white,
              radius: 35,
              child: Icon(
                icon,
                color: MainColors.primaryColor,
                size: 32,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: MainColors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          color: MainColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 24, color: MainColors.white),
          ],
        ),
      ),
    );
  }
}
