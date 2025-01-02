import 'package:aikyamm/authentication/DashBoards/Devices/BLE1.dart';
import 'package:flutter/material.dart';

class TimingGateScreen extends StatelessWidget {
  const TimingGateScreen({Key? key}) : super(key: key);

  // Reusable card function
  Widget buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String batteryLevel,
    required IconData trackModeIcon,
    required int gates,
    required String connectionStatus,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // Makes the card clickable
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 8, // Increased shadow for a more elegant look
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/HomeDash/c.jpg'), // Add your image here
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.darken),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight:
                      FontWeight.w600, // Slightly lighter for a modern feel
                ),
              ),
              const SizedBox(height: 12),
              // Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        connectionStatus, // This will show "Connected" or "Disconnected"
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.battery_full, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        batteryLevel,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Track Mode Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(trackModeIcon, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Track Mode',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.wifi_tethering, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$gates Gates',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to create multiple cards dynamically
  Widget _buildMyPlansCard(
      String title,
      String subtitle,
      IconData icon,
      String batteryLevel,
      IconData trackModeIcon,
      int gates,
      String connectionStatus,
      VoidCallback onTap) {
    return buildCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      batteryLevel: batteryLevel,
      trackModeIcon: trackModeIcon,
      gates: gates,
      connectionStatus: connectionStatus,
      onTap: onTap,
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First card
            _buildMyPlansCard(
              'Timing Gate',
              'Connected',
              Icons.wifi,
              '78%',
              Icons.track_changes,
              4,
              'Connected', // You can change this to 'Disconnected' for other cards
              () {
                // Action when clicked
                // print("Timing Gate Clicked");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>BluetoothPage()),
                );
              },
            ),
            // Second card
            _buildMyPlansCard(
              'New Feature',
              'Disconnected',
              Icons.signal_wifi_off,
              '45%',
              Icons
                  .airline_seat_recline_normal, // Example of another track mode icon
              3,
              'Disconnected', // For disconnected state
              () {
                print("New Feature Clicked");
              },
            ),
            // Additional cards here
            _buildMyPlansCard(
              'Feature 3',
              'Active',
              Icons.bluetooth_connected,
              '85%',
              Icons.directions_run, // Track mode for a run activity
              5,
              'Connected',
              () {
                print("Feature 3 Clicked");
              },
            ),
          ],
        ),
      ),
    );
  }
}

