// import 'dart:async';
// import 'package:aikyamm/BLE/DD5.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MyApp1());
// }

// class MyApp1 extends StatelessWidget {
//   const MyApp1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bluetooth Scanner',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const BluetoothPage(),
//     );
//   }
// }

// class BluetoothPage extends StatefulWidget {
//   const BluetoothPage({Key? key}) : super(key: key);

//   @override
//   State<BluetoothPage> createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   final List<ScanResult> _devices = [];
//   final Set<String> _expandedDevices = {}; // Track expanded devices
//   final Map<String, String> _connectionStatus = {}; // Track connection status
//   StreamSubscription? _scanSubscription;
//   bool _isScanning = false;

//   @override
//   void dispose() {
//     _scanSubscription?.cancel();
//     super.dispose();
//   }

//   Future<bool> _checkPermissions() async {
//     var locationPermissionStatus = await Permission.location.request();
//     var bluetoothScanPermissionStatus = await Permission.bluetoothScan.request();
//     var bluetoothConnectPermissionStatus = await Permission.bluetoothConnect.request();

//     if (locationPermissionStatus.isDenied ||
//         bluetoothScanPermissionStatus.isDenied ||
//         bluetoothConnectPermissionStatus.isDenied) {
//       return false;
//     }
//     return true;
//   }

//   Future<bool> _isBluetoothOn() async {
//     final bluetoothState = await FlutterBluePlus.adapterState.first;
//     return bluetoothState == BluetoothAdapterState.on;
//   }

//   Future<void> _startScan() async {
//     bool hasPermission = await _checkPermissions();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Permissions are required for scanning.")),
//       );
//       return;
//     }

//     bool isBluetoothEnabled = await _isBluetoothOn();
//     if (!isBluetoothEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Bluetooth is turned off. Please enable it.")),
//       );
//       return;
//     }

//     setState(() {
//       _isScanning = true;
//       _devices.clear();
//     });

//     // Start scanning and listen for scan results.
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

//     _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
//       setState(() {
//         for (ScanResult result in results) {
//           if (_devices.every((d) => d.device.id != result.device.id)) {
//             _devices.add(result);
//             _connectionStatus[result.device.id.toString()] = 'Connect'; // Show connect button
//           }
//         }
//       });
//     });

//     // After 5 seconds, stop the scan
//     Timer(const Duration(seconds: 5), _stopScan);
//   }

//   void _stopScan() {
//     FlutterBluePlus.stopScan();
//     setState(() => _isScanning = false);
//   }

//   void _toggleDeviceDetails(String deviceId) {
//     setState(() {
//       if (_expandedDevices.contains(deviceId)) {
//         _expandedDevices.remove(deviceId);
//       } else {
//         _expandedDevices.add(deviceId);
//       }
//     });
//   }

//   Future<void> _connectToDevice(ScanResult result) async {
//     setState(() {
//       _connectionStatus[result.device.id.toString()] = 'Connecting...'; // Show Connecting
//     });

//     try {
//       await result.device.connect();
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connected'; // Show Connected
//       });

//       // Fetch additional device data after connection
//       List<BluetoothService> services = await result.device.discoverServices();
//       String deviceType = _getDeviceType(result);

//       // Navigate to the Device Details page
//       if (context.mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DeviceDetailsPage(
//               device: result.device,
//               // deviceType: deviceType,
//               // services: services,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connection Failed'; // Handle failed connection
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to connect to ${result.device.name}")),
//       );
//     }
//   }

//   Future<void> _refreshDevices() async {
//     setState(() {
//       _isScanning = true;
//     });
//     await _startScan(); // Trigger the scan again to refresh the list of devices.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColors.primaryColor,
//         title: const Text(
//           "Devices BLE Connections",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             color: MainColors.white,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
//           onPressed: () {
//             // Handle back navigation
//           },
//         ),
//         elevation: 5,
//       ),
//       body: SafeArea( // Ensuring safe area for the UI
//         child: RefreshIndicator(
//           onRefresh: _refreshDevices, // Trigger the refresh action
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 // Enhanced "Connect New Device" Button with Gradient
//                 GestureDetector(
//                   onTap: _startScan,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color.fromRGBO(143, 0, 0, 1),
//                           Color.fromRGBO(220, 20, 60, 1),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           offset: const Offset(0, 4),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.add_circle_outline, color: MainColors.white, size: 22),
//                         SizedBox(width: 10),
//                         Text(
//                           "Connect New Device",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: MainColors.white,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Saved Devices",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // Saved Devices List with Soft Cards
//                 Expanded(
//   child: ListView.builder(
//     itemCount: _devices.length,
//     itemBuilder: (context, index) {
//       final result = _devices[index];
//       final isExpanded = _expandedDevices.contains(result.device.id.toString());
//       final deviceStatus = _connectionStatus[result.device.id.toString()] ?? 'Connect';

//       // Set the icon color based on the connection status
//       Color iconColor;
//       if (deviceStatus == 'Connecting...') {
//         iconColor = Colors.yellow; // Yellow for connecting
//       } else if (deviceStatus == 'Connected') {
//         iconColor = Color.fromRGBO(143, 0, 0, 1); // Green for connected
//       } else {
//         iconColor = Colors.grey; // Grey for not connected
//       }

//       return Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: MainColors.white, // Clean white background
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               offset: const Offset(0, 4),
//               blurRadius: 10,
//             ),
//           ],
//           border: Border.all(
//             color: result.device.id.toString() == _connectionStatus[result.device.id.toString()]
//                 ? const Color.fromRGBO(143, 0, 0, 0.5)
//                 : Colors.grey.shade300,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             // Circle Avatar with Status Indicator
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: iconColor, // Dynamic icon color
//                   radius: 28,
//                   child: Icon(
//                     Icons.bluetooth,
//                     color: MainColors.white,
//                     size: 30,
//                   ),
//                 ),
//                 if (deviceStatus == 'Connected') // Show status indicator for connected devices
//                   Container(
//                     width: 12,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: const Color.fromRGBO(0, 200, 83, 1), // Green circle
//                       shape: BoxShape.circle,
//                       border: Border.all(color: MainColors.white, width: 2),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 10),
//             // Device Name and Address
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   result.device.name.isEmpty ? "Unknown Device" : result.device.name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   result.device.id.toString(),
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             // Connect Button
//             ElevatedButton(
//               onPressed: () => _connectToDevice(result),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: MainColors.white, 
//                 backgroundColor: MainColors.primaryColor,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 deviceStatus,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   ),
// ),

//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _getDeviceType(ScanResult result) {
//     if (result.device.name.contains("DD5")) {
//       return "DD5 Device";
//     }
//     return "Unknown Device";
//   }
// }


// import 'dart:async';
// import 'package:aikyamm/BLE/DD5.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MyApp1());
// }

// class MyApp1 extends StatelessWidget {
//   const MyApp1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bluetooth Scanner',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const BluetoothPage(),
//     );
//   }
// }

// class BluetoothPage extends StatefulWidget {
//   const BluetoothPage({Key? key}) : super(key: key);

//   @override
//   State<BluetoothPage> createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   final List<ScanResult> _devices = [];
//   final Set<String> _expandedDevices = {}; // Track expanded devices
//   final Map<String, String> _connectionStatus = {}; // Track connection status
//   StreamSubscription? _scanSubscription;
//   bool _isScanning = false;

//   @override
//   void dispose() {
//     _scanSubscription?.cancel();
//     super.dispose();
//   }

//   Future<bool> _checkPermissions() async {
//     var locationPermissionStatus = await Permission.location.request();
//     var bluetoothScanPermissionStatus = await Permission.bluetoothScan.request();
//     var bluetoothConnectPermissionStatus = await Permission.bluetoothConnect.request();

//     if (locationPermissionStatus.isDenied ||
//         bluetoothScanPermissionStatus.isDenied ||
//         bluetoothConnectPermissionStatus.isDenied) {
//       return false;
//     }
//     return true;
//   }

//   Future<bool> _isBluetoothOn() async {
//     final bluetoothState = await FlutterBluePlus.adapterState.first;
//     return bluetoothState == BluetoothAdapterState.on;
//   }

//   Future<void> _startScan() async {
//     bool hasPermission = await _checkPermissions();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Permissions are required for scanning.")),
//       );
//       return;
//     }

//     bool isBluetoothEnabled = await _isBluetoothOn();
//     if (!isBluetoothEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Bluetooth is turned off. Please enable it.")),
//       );
//       return;
//     }

//     setState(() {
//       _isScanning = true;
//       _devices.clear();
//     });

//     // Start scanning and listen for scan results.
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

//     _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
//       setState(() {
//         for (ScanResult result in results) {
//           if (_devices.every((d) => d.device.id != result.device.id)) {
//             _devices.add(result);
//             _connectionStatus[result.device.id.toString()] = 'Connect'; // Show connect button
//           }
//         }
//       });
//     });

//     // After 5 seconds, stop the scan
//     Timer(const Duration(seconds: 5), _stopScan);
//   }

//   void _stopScan() {
//     FlutterBluePlus.stopScan();
//     setState(() => _isScanning = false);
//   }

//   void _toggleDeviceDetails(String deviceId) {
//     setState(() {
//       if (_expandedDevices.contains(deviceId)) {
//         _expandedDevices.remove(deviceId);
//       } else {
//         _expandedDevices.add(deviceId);
//       }
//     });
//   }

//   Future<void> _connectToDevice(ScanResult result) async {
//     setState(() {
//       _connectionStatus[result.device.id.toString()] = 'Connecting...'; // Show Connecting
//     });

//     try {
//       await result.device.connect();
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connected'; // Show Connected
//       });

//       // Fetch additional device data after connection
//       List<BluetoothService> services = await result.device.discoverServices();
//       String deviceType = _getDeviceType(result);

//       // Navigate to the Device Details page
//       if (context.mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DeviceDetailsPage(
//               device: result.device,
//               // deviceType: deviceType,
//               // services: services,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connection Failed'; // Handle failed connection
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to connect to ${result.device.name}")),
//       );
//     }
//   }

//   Future<void> _refreshDevices() async {
//     setState(() {
//       _isScanning = true;
//     });
//     await _startScan(); // Trigger the scan again to refresh the list of devices.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColors.primaryColor,
//         title: const Text(
//           "Devices BLE Connections",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             color: MainColors.white,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
//           onPressed: () {
//             // Handle back navigation
//           },
//         ),
//         elevation: 5,
//       ),
//       body: SafeArea( // Ensuring safe area for the UI
//         child: RefreshIndicator(
//           onRefresh: _refreshDevices, // Trigger the refresh action
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 // Enhanced "Connect New Device" Button with Gradient
//                 GestureDetector(
//                   onTap: _startScan,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color.fromRGBO(143, 0, 0, 1),
//                           Color.fromRGBO(220, 20, 60, 1),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           offset: const Offset(0, 4),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.add_circle_outline, color: MainColors.white, size: 22),
//                         SizedBox(width: 10),
//                         Text(
//                           "Connect New Device",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: MainColors.white,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Saved Devices",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // Saved Devices List with Soft Cards
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _devices.length,
//                     itemBuilder: (context, index) {
//                       final result = _devices[index];
//                       final isExpanded = _expandedDevices.contains(result.device.id.toString());
//                       final deviceStatus = _connectionStatus[result.device.id.toString()] ?? 'Connect';

//                       // Set the icon color based on the connection status
//                       Color iconColor;
//                       if (deviceStatus == 'Connecting...') {
//                         iconColor = Colors.yellow; // Yellow for connecting
//                       } else if (deviceStatus == 'Connected') {
//                         iconColor = Color.fromRGBO(143, 0, 0, 1); // Green for connected
//                       } else {
//                         iconColor = Colors.grey; // Grey for not connected
//                       }

//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: MainColors.white, // Clean white background
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               offset: const Offset(0, 4),
//                               blurRadius: 10,
//                             ),
//                           ],
//                           border: Border.all(
//                             color: result.device.id.toString() == _connectionStatus[result.device.id.toString()]
//                                 ? const Color.fromRGBO(143, 0, 0, 0.5)
//                                 : Colors.grey.shade300,
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             // Circle Avatar with Status Indicator
//                             Stack(
//                               alignment: Alignment.bottomRight,
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor: iconColor, // Dynamic icon color
//                                   radius: 28,
//                                   child: Icon(
//                                     Icons.bluetooth,
//                                     color: MainColors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 if (deviceStatus == 'Connected') // Show status indicator for connected devices
//                                   Container(
//                                     width: 12,
//                                     height: 12,
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromRGBO(0, 200, 83, 1), // Green circle
//                                       shape: BoxShape.circle,
//                                       border: Border.all(color: MainColors.white, width: 2),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(width: 10),
//                             // Device Name and Address with Scroll
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Text(
//                                       result.device.name.isEmpty ? "Unknown Device" : result.device.name,
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Text(
//                                       result.device.id.toString(),
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             // Connect Button
//                             ElevatedButton(
//                               onPressed: () => _connectToDevice(result),
//                               style: ElevatedButton.styleFrom(
//                                 foregroundColor: MainColors.white, 
//                                 backgroundColor: MainColors.primaryColor,
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(
//                                 deviceStatus,
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _getDeviceType(ScanResult result) {
//     if (result.device.name.contains("DD5")) {
//       return "DD5 Device";
//     }
//     return "Unknown Device";
//   }
// }


// import 'dart:async';
// import 'package:aikyamm/BLE/DD5.dart';
// import 'package:aikyamm/authentication/DashBoards/Devices/database/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:flutter/material.dart';  // This gives you BuildContext
// import 'package:path/path.dart' as path; // For working with file paths

// void main() {
//   runApp(const MyApp1());
// }

// class MyApp1 extends StatelessWidget {
//   const MyApp1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bluetooth Scanner',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const BluetoothPage(),
//     );
//   }
// }

// class BluetoothPage extends StatefulWidget {
//   const BluetoothPage({Key? key}) : super(key: key);

//   @override
//   State<BluetoothPage> createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   final List<ScanResult> _devices = [];
//   final Set<String> _expandedDevices = {}; // Track expanded devices
//   final Map<String, String> _connectionStatus = {}; // Track connection status
//   StreamSubscription? _scanSubscription;
//   bool _isScanning = false;

//   @override
//   void dispose() {
//     _scanSubscription?.cancel();
//     super.dispose();
//   }

//   Future<bool> _checkPermissions() async {
//     var locationPermissionStatus = await Permission.location.request();
//     var bluetoothScanPermissionStatus = await Permission.bluetoothScan.request();
//     var bluetoothConnectPermissionStatus = await Permission.bluetoothConnect.request();

//     if (locationPermissionStatus.isDenied ||
//         bluetoothScanPermissionStatus.isDenied ||
//         bluetoothConnectPermissionStatus.isDenied) {
//       return false;
//     }
//     return true;
//   }

//   Future<bool> _isBluetoothOn() async {
//     final bluetoothState = await FlutterBluePlus.adapterState.first;
//     return bluetoothState == BluetoothAdapterState.on;
//   }

//   Future<void> _startScan() async {
//     bool hasPermission = await _checkPermissions();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         const SnackBar(content: Text("Permissions are required for scanning.")),
//       );
//       return;
//     }

//     bool isBluetoothEnabled = await _isBluetoothOn();
//     if (!isBluetoothEnabled) {
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         const SnackBar(content: Text("Bluetooth is turned off. Please enable it.")),
//       );
//       return;
//     }

//     setState(() {
//       _isScanning = true;
//       _devices.clear();
//     });

//     // Start scanning and listen for scan results.
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

//     _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
//       setState(() {
//         for (ScanResult result in results) {
//           if (_devices.every((d) => d.device.id != result.device.id)) {
//             _devices.add(result);
//             _connectionStatus[result.device.id.toString()] = 'Connect'; // Show connect button
//           }
//         }
//       });
//     });

//     // After 5 seconds, stop the scan
//     Timer(const Duration(seconds: 5), _stopScan);
//   }

//   void _stopScan() {
//     FlutterBluePlus.stopScan();
//     setState(() => _isScanning = false);
//   }

//   void _toggleDeviceDetails(String deviceId) {
//     setState(() {
//       if (_expandedDevices.contains(deviceId)) {
//         _expandedDevices.remove(deviceId);
//       } else {
//         _expandedDevices.add(deviceId);
//       }
//     });
//   }

//   Future<void> _connectToDevice(ScanResult result) async {
//     setState(() {
//       _connectionStatus[result.device.id.toString()] = 'Connecting...'; // Show Connecting
//     });

//     try {
//       await result.device.connect();
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connected'; // Show Connected
//       });

//       // Save the device in the database
//       Device device = Device(id: result.device.id.toString(), name: result.device.name);
//       await DatabaseHelper.instance.insertDevice(device);

//       // Fetch saved devices to refresh the list
//       _refreshDevices();

//       // Navigate to the Device Details page
//       if (mounted) {
//         Navigator.push(
//           context as BuildContext,
//           MaterialPageRoute(
//             builder: (context) => DeviceDetailsPage(device: result.device),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connection Failed'; // Handle failed connection
//       });
//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         SnackBar(content: Text("Failed to connect to ${result.device.name}")),
//       );
//     }
//   }

//   Future<void> _refreshDevices() async {
//     setState(() {
//   _isScanning = true;
// });
// // Fetch the saved devices from the database
// final devices = await DatabaseHelper.instance.getDevices();
// setState(() {
//   _isScanning = true;
// });
// // Fetch the saved devices from the database
// final List<Device> savedDevices = await DatabaseHelper.instance.getDevices(); // Renamed to savedDevices
// setState(() {
//   _devices.clear();
//   // Convert saved devices into ScanResults format to display
//   for (var device in savedDevices) { // Using savedDevices instead of devices
//     // Correctly create BluetoothDevice using the DeviceIdentifier
//     final bluetoothDevice = BluetoothDevice(remoteId: DeviceIdentifier(device.id));

//     // Creating AdvertisementData with required placeholders
//     final advertisementData = AdvertisementData(
//       advName: device.name, // Using device name as the advertisement name
//       txPowerLevel: null, // Placeholder for txPowerLevel
//       appearance: null, // Placeholder for appearance
//       connectable: true, // Assuming the device is connectable
//       manufacturerData: {}, // Placeholder for manufacturerData
//       serviceData: {}, // Placeholder for serviceData
//       serviceUuids: [], // Placeholder for serviceUuids
//     );

//     // Adding ScanResult with all the required parameters
//     _devices.add(
//       ScanResult(
//         device: bluetoothDevice,
//         advertisementData: advertisementData,
//         rssi: -1, // Placeholder RSSI value
//         timeStamp: DateTime.now(), // Using current time as the timestamp
//       ),
//     );
//   }
// });

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MainColors.primaryColor,
//         title: const Text(
//           "Devices BLE Connections",
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             color: MainColors.white,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
//           onPressed: () {
//             // Handle back navigation
//           },
//         ),
//         elevation: 5,
//       ),
//       body: SafeArea( // Ensuring safe area for the UI
//         child: RefreshIndicator(
//           onRefresh: _refreshDevices, // Trigger the refresh action
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: _startScan,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color.fromRGBO(143, 0, 0, 1),
//                           Color.fromRGBO(220, 20, 60, 1),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           offset: const Offset(0, 4),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.add_circle_outline, color: MainColors.white, size: 22),
//                         SizedBox(width: 10),
//                         Text(
//                           "Connect New Device",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: MainColors.white,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Saved Devices",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _devices.length,
//                     itemBuilder: (context, index) {
//                       final result = _devices[index];
//                       final deviceStatus = _connectionStatus[result.device.id.toString()] ?? 'Connect';

//                       Color iconColor;
//                       if (deviceStatus == 'Connecting...') {
//                         iconColor = Colors.yellow;
//                       } else if (deviceStatus == 'Connected') {
//                         iconColor = Color.fromRGBO(143, 0, 0, 1);
//                       } else {
//                         iconColor = Colors.grey;
//                       }

//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: MainColors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               offset: const Offset(0, 4),
//                               blurRadius: 10,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Stack(
//                               alignment: Alignment.bottomRight,
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor: iconColor,
//                                   radius: 28,
//                                   child: Icon(
//                                     Icons.bluetooth,
//                                     color: MainColors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     result.device.name.isEmpty ? "Unknown Device" : result.device.name,
//                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                                   ),
//                                   Text(
//                                     result.device.id.toString(),
//                                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () => _connectToDevice(result),
//                               style: ElevatedButton.styleFrom(
//                                 foregroundColor: MainColors.white,
//                                 backgroundColor: MainColors.primaryColor,
//                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: Text(deviceStatus),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
 

import 'dart:async';
import 'package:aikyamm/BLE/DD5.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/database/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';  // This gives you BuildContext
import 'package:path/path.dart' as path; // For working with file paths


void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final List<ScanResult> _devices = [];
  final Set<String> _expandedDevices = {}; // Track expanded devices
  final Map<String, String> _connectionStatus = {}; // Track connection status
  StreamSubscription? _scanSubscription;
  bool _isScanning = false;

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  Future<bool> _checkPermissions() async {
    var locationPermissionStatus = await Permission.location.request();
    var bluetoothScanPermissionStatus = await Permission.bluetoothScan.request();
    var bluetoothConnectPermissionStatus = await Permission.bluetoothConnect.request();

    if (locationPermissionStatus.isDenied ||
        bluetoothScanPermissionStatus.isDenied ||
        bluetoothConnectPermissionStatus.isDenied) {
      return false;
    }
    return true;
  }

  Future<bool> _isBluetoothOn() async {
    final bluetoothState = await FlutterBluePlus.adapterState.first;
    return bluetoothState == BluetoothAdapterState.on;
  }

  Future<void> _startScan() async {
    bool hasPermission = await _checkPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text("Permissions are required for scanning.")),
      );
      return;
    }

    bool isBluetoothEnabled = await _isBluetoothOn();
    if (!isBluetoothEnabled) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text("Bluetooth is turned off. Please enable it.")),
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    // Start scanning and listen for scan results.
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        for (ScanResult result in results) {
          if (_devices.every((d) => d.device.id != result.device.id)) {
            _devices.add(result);
            _connectionStatus[result.device.id.toString()] = 'Connect'; // Show connect button
          }
        }
      });
    });

    // After 5 seconds, stop the scan
    Timer(const Duration(seconds: 5), _stopScan);
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() => _isScanning = false);
  }

  void _toggleDeviceDetails(String deviceId) {
    setState(() {
      if (_expandedDevices.contains(deviceId)) {
        _expandedDevices.remove(deviceId);
      } else {
        _expandedDevices.add(deviceId);
      }
    });
  }

  Future<void> _connectToDevice(ScanResult result) async {
    setState(() {
      _connectionStatus[result.device.id.toString()] = 'Connecting...'; // Show Connecting
    });

    try {
      await result.device.connect();
      setState(() {
        _connectionStatus[result.device.id.toString()] = 'Connected'; // Show Connected
      });

      // Save the device in the database
      Device device = Device(id: result.device.id.toString(), name: result.device.name);
      await DatabaseHelper.instance.insertDevice(device);

      // Fetch saved devices to refresh the list
      _refreshDevices();

      // Navigate to the Device Details page
      if (mounted) {
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(
            builder: (context) => DeviceDetailsPage(device: result.device),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _connectionStatus[result.device.id.toString()] = 'Connection Failed'; // Handle failed connection
      });
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text("Failed to connect to ${result.device.name}")),
      );
    }
  }

  Future<void> _refreshDevices() async {
    setState(() {
  _isScanning = true;
});
// Fetch the saved devices from the database
final devices = await DatabaseHelper.instance.getDevices();
setState(() {
  _isScanning = true;
});
// Fetch the saved devices from the database
final List<Device> savedDevices = await DatabaseHelper.instance.getDevices(); // Renamed to savedDevices
setState(() {
  _devices.clear();
  // Convert saved devices into ScanResults format to display
  for (var device in savedDevices) { // Using savedDevices instead of devices
    // Correctly create BluetoothDevice using the DeviceIdentifier
    final bluetoothDevice = BluetoothDevice(remoteId: DeviceIdentifier(device.id));

    // Creating AdvertisementData with required placeholders
    final advertisementData = AdvertisementData(
      advName: device.name, // Using device name as the advertisement name
      txPowerLevel: null, // Placeholder for txPowerLevel
      appearance: null, // Placeholder for appearance
      connectable: true, // Assuming the device is connectable
      manufacturerData: {}, // Placeholder for manufacturerData
      serviceData: {}, // Placeholder for serviceData
      serviceUuids: [], // Placeholder for serviceUuids
    );

    // Adding ScanResult with all the required parameters
    _devices.add(
      ScanResult(
        device: bluetoothDevice,
        advertisementData: advertisementData,
        rssi: -1, // Placeholder RSSI value
        timeStamp: DateTime.now(), // Using current time as the timestamp
      ),
    );
  }
});



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColors.primaryColor,
        title: const Text(
          "Devices BLE Connections",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: MainColors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
          onPressed: () {
            // Handle back navigation
             Navigator.pop(context);
          },
        ),
        elevation: 5,
      ),
      body: SafeArea( // Ensuring safe area for the UI
        child: RefreshIndicator(
          onRefresh: _refreshDevices, // Trigger the refresh action
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _startScan,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 0, 0, 1),
                          Color.fromRGBO(220, 20, 60, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline, color: MainColors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          "Connect New Device",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: MainColors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Saved Devices",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final result = _devices[index];
                      final deviceStatus = _connectionStatus[result.device.id.toString()] ?? 'Connect';

                      Color iconColor;
                      if (deviceStatus == 'Connecting...') {
                        iconColor = Colors.yellow;
                      } else if (deviceStatus == 'Connected') {
                        iconColor = Color.fromRGBO(143, 0, 0, 1);
                      } else {
                        iconColor = Colors.grey;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: MainColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundColor: iconColor,
                                  radius: 28,
                                  child: Icon(
                                    Icons.bluetooth,
                                    color: MainColors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    result.device.name.isEmpty ? "Unknown Device" : result.device.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    result.device.id.toString(),
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _connectToDevice(result),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: MainColors.white, 
                                backgroundColor: MainColors.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(deviceStatus),
                            ),
                          ],
                        ),
                      );
                    },
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
