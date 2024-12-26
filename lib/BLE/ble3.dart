// import 'dart:async';
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

//   Widget _buildDeviceDetails(ScanResult result) {
//     List<Widget> details = [];

//     // Add Complete Local Name if available
//     if (result.device.name.isNotEmpty) {
//       details.add(Text("Complete Local Name: ${result.device.name}"));
//     }

//     // Add Advertising Type (typically "Legacy" for BLE devices)
//     details.add(Text("Advertising type: ${_getAdvertisingType(result)}"));

//     // Add Flags (Flags represent the Bluetooth advertising flags)
//     details.add(Text("Flags: GeneralDiscoverable"));

//     // Add Manufacturer Data if available
//     if (result.advertisementData.manufacturerData.isNotEmpty) {
//       details.add(Text("Manufacturer data (Bluetooth Core 4.1):"));
//       details.add(Text(_formatManufacturerData(result.advertisementData.manufacturerData)));
//     }

//     // Add Service UUIDs if available
//     if (result.advertisementData.serviceUuids.isNotEmpty) {
//       details.add(Text("Complete list of 16-bit Service UUIDs: ${result.advertisementData.serviceUuids.join(", ")}"));
//     }

//     // Add Service Data if available
//     if (result.advertisementData.serviceData.isNotEmpty) {
//       result.advertisementData.serviceData.forEach((uuid, data) {
//         details.add(Text("Service Data: UUID: $uuid Data: ${_formatManufacturerData({uuid: data})}"));
//       });
//     }

//     // Return all the dynamically added widgets
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: details,
//     );
//   }

//   /// Helper method to format manufacturer data (which is a Map<int, List<int>>)
//   String _formatManufacturerData(Map<dynamic, List<int>> manufacturerData) {
//     List<String> formattedData = [];
//     manufacturerData.forEach((key, value) {
//       formattedData.add('Manufacturer ID: $key, Data: ${value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');
//     });
//     return formattedData.join('\n');
//   }

//   // Get Advertising Type (based on the advertisement data)
//   String _getAdvertisingType(ScanResult result) {
//     // Since "isConnectable" is not available, you can just use available data here
//     return "Legacy";
//   }

//   Future<void> _refreshDevices() async {
//     await _startScan(); // Trigger the scan again to refresh the list of devices.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bluetooth Scanner"),
//         actions: [
//           _isScanning
//               ? IconButton(
//                   icon: const Icon(Icons.stop),
//                   onPressed: _stopScan,
//                 )
//               : IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: _startScan,
//                 ),
//         ],
//       ),
//       body: Center(
//         child: _isScanning
//             ? const CircularProgressIndicator()
//             : _devices.isEmpty
//                 ? const Text("No devices found. Tap search to scan.")
//                 : RefreshIndicator(
//                     onRefresh: _refreshDevices, // Trigger the refresh action
//                     child: ListView.builder(
//                       itemCount: _devices.length,
//                       itemBuilder: (context, index) {
//                         final result = _devices[index];
//                         final isExpanded = _expandedDevices.contains(result.device.id.toString());
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 leading: const Icon(Icons.bluetooth),
//                                 title: Text(result.device.name.isNotEmpty ? result.device.name : "Unnamed Device"),
//                                 subtitle: Text("ID: ${result.device.id}"),
//                                 trailing: IconButton(
//                                   icon: Icon(isExpanded
//                                       ? Icons.expand_less
//                                       : Icons.expand_more),
//                                   onPressed: () => _toggleDeviceDetails(result.device.id.toString()),
//                                 ),
//                               ),
//                               if (isExpanded)
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: _buildDeviceDetails(result),
//                                 ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions are required for scanning.")),
      );
      return;
    }

    bool isBluetoothEnabled = await _isBluetoothOn();
    if (!isBluetoothEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
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

  Widget _buildDeviceDetails(ScanResult result) {
    List<Widget> details = [];

    // Add Complete Local Name if available
    if (result.device.name.isNotEmpty) {
      details.add(Text("Complete Local Name: ${result.device.name}"));
    }

    // Add Advertising Type (typically "Legacy" for BLE devices)
    details.add(Text("Advertising type: ${_getAdvertisingType(result)}"));

    // Add Flags (Flags represent the Bluetooth advertising flags)
    details.add(Text("Flags: GeneralDiscoverable"));

    // Add Manufacturer Data if available
    if (result.advertisementData.manufacturerData.isNotEmpty) {
      details.add(Text("Manufacturer data (Bluetooth Core 4.1):"));
      details.add(Text(_formatManufacturerData(result.advertisementData.manufacturerData)));
    }

    // Add Service UUIDs if available
    if (result.advertisementData.serviceUuids.isNotEmpty) {
      details.add(Text("Complete list of 16-bit Service UUIDs: ${result.advertisementData.serviceUuids.join(", ")}"));
    }

    // Add Service Data if available
    if (result.advertisementData.serviceData.isNotEmpty) {
      result.advertisementData.serviceData.forEach((uuid, data) {
        details.add(Text("Service Data: UUID: $uuid Data: ${_formatManufacturerData({uuid: data})}"));
      });
    }

    // Return all the dynamically added widgets
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  /// Helper method to format manufacturer data (which is a Map<int, List<int>>)
  String _formatManufacturerData(Map<dynamic, List<int>> manufacturerData) {
    List<String> formattedData = [];
    manufacturerData.forEach((key, value) {
      formattedData.add('Manufacturer ID: $key, Data: ${value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');
    });
    return formattedData.join('\n');
  }

  // Get Advertising Type (based on the advertisement data)
  String _getAdvertisingType(ScanResult result) {
    // Since "isConnectable" is not available, you can just use available data here
    return "Legacy";
  }

  Future<void> _refreshDevices() async {
    await _startScan(); // Trigger the scan again to refresh the list of devices.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Scanner"),
        actions: [
          _isScanning
              ? IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: _stopScan,
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startScan,
                ),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshDevices, // Trigger the refresh action
          child: ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final result = _devices[index];
              final isExpanded = _expandedDevices.contains(result.device.id.toString());
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(result.device.name.isNotEmpty ? result.device.name : "Unnamed Device"),
                      subtitle: Text("ID: ${result.device.id}"),
                      trailing: IconButton(
                        icon: Icon(isExpanded
                            ? Icons.expand_less
                            : Icons.expand_more),
                        onPressed: () => _toggleDeviceDetails(result.device.id.toString()),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildDeviceDetails(result),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
