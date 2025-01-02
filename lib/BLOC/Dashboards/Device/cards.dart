import 'package:aikyamm/authentication/DashBoards/Devices/BLE1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class TimingGateState {}

class TimingGateInitialState extends TimingGateState {}

class TimingGateLoadedState extends TimingGateState {
  final List<Device> devices;
  TimingGateLoadedState({required this.devices});
}

// Events
abstract class TimingGateEvent {}

class LoadDevicesEvent extends TimingGateEvent {}

class DeviceClickEvent extends TimingGateEvent {
  final Device device;
  DeviceClickEvent({required this.device});
}

// Device Model
class Device {
  final String title;
  final String subtitle;
  final IconData icon;
  final String batteryLevel;
  final IconData trackModeIcon;
  final int gates;
  final String connectionStatus;
  Device({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.batteryLevel,
    required this.trackModeIcon,
    required this.gates,
    required this.connectionStatus,
  });
}

// BLoC
class TimingGateBloc extends Bloc<TimingGateEvent, TimingGateState> {
  TimingGateBloc() : super(TimingGateInitialState());

  @override
  Stream<TimingGateState> mapEventToState(TimingGateEvent event) async* {
    if (event is LoadDevicesEvent) {
      // Simulating data load
      yield TimingGateLoadedState(devices: [
        Device(
          title: 'Timing Gate',
          subtitle: 'Connected',
          icon: Icons.wifi,
          batteryLevel: '78%',
          trackModeIcon: Icons.track_changes,
          gates: 4,
          connectionStatus: 'Connected',
        ),
        Device(
          title: 'New Feature',
          subtitle: 'Disconnected',
          icon: Icons.signal_wifi_off,
          batteryLevel: '45%',
          trackModeIcon: Icons.airline_seat_recline_normal,
          gates: 3,
          connectionStatus: 'Disconnected',
        ),
        Device(
          title: 'Feature 3',
          subtitle: 'Active',
          icon: Icons.bluetooth_connected,
          batteryLevel: '85%',
          trackModeIcon: Icons.directions_run,
          gates: 5,
          connectionStatus: 'Connected',
        ),
      ]);
    } else if (event is DeviceClickEvent) {
      // Handle the device click logic
      // You can navigate to different pages or perform other actions here
      // For example, printing the clicked device title:
      print("${event.device.title} clicked");
    }
  }
}

// UI
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocProvider(
        create: (context) => TimingGateBloc()..add(LoadDevicesEvent()),
        child: BlocBuilder<TimingGateBloc, TimingGateState>(
          builder: (context, state) {
            if (state is TimingGateLoadedState) {
              return SingleChildScrollView(
                child: Column(
                  children: state.devices.map((device) {
                    return buildCard(
                      title: device.title,
                      subtitle: device.subtitle,
                      icon: device.icon,
                      batteryLevel: device.batteryLevel,
                      trackModeIcon: device.trackModeIcon,
                      gates: device.gates,
                      connectionStatus: device.connectionStatus,
                      onTap: () {
                        // When the card is clicked, dispatch the DeviceClickEvent
                        BlocProvider.of<TimingGateBloc>(context).add(
                          DeviceClickEvent(device: device),
                        );
                        // Handle navigation if needed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BluetoothPage()),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimingGateScreen(),
  ));
}
