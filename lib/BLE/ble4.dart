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
//       await _fetchDeviceData(result.device);

//     } catch (e) {
//       setState(() {
//         _connectionStatus[result.device.id.toString()] = 'Connection Failed'; // Handle failed connection
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to connect to ${result.device.name}")),
//       );
//     }
//   }

//   Future<void> _fetchDeviceData(BluetoothDevice device) async {
//     // Fetching services and characteristics
//     List<BluetoothService> services = await device.discoverServices();
    
//     for (var service in services) {
//       for (var characteristic in service.characteristics) {
//         // Fetch data for each characteristic
//         var value = await characteristic.read();
//         print("Service UUID: ${service.uuid}, Characteristic UUID: ${characteristic.uuid}, Value: $value");
//       }
//     }
//   }

//   Widget _buildDeviceDetails(ScanResult result) {
//     List<Widget> details = [];

//     // Device Name
//     details.add(Text("Device Name: ${result.device.name.isNotEmpty ? result.device.name : "Unnamed Device"}"));
    
//     // RSSI
//     details.add(Text("RSSI: ${result.rssi} dBm"));

//     // Advertising Type
//     details.add(Text("Advertising Type: ${_getAdvertisingType(result)}"));

//     // Manufacturer Data (Bluetooth Core 4.1)
//     if (result.advertisementData.manufacturerData.isNotEmpty) {
//       details.add(Text("Manufacturer Data:"));
//       details.add(Text(_formatManufacturerData(result.advertisementData.manufacturerData)));
//     }

//     // Service UUIDs
//     if (result.advertisementData.serviceUuids.isNotEmpty) {
//       details.add(Text("Service UUIDs: ${result.advertisementData.serviceUuids.join(", ")}"));
//     }

//     // Service Data (Bluetooth 4.0+)
//     if (result.advertisementData.serviceData.isNotEmpty) {
//       result.advertisementData.serviceData.forEach((uuid, data) {
//         details.add(Text("Service Data - UUID: $uuid"));
//         details.add(Text("Data: ${_formatManufacturerData({uuid: data})}"));
//       });
//     }

//     // Tx Power Level
//     if (result.advertisementData.txPowerLevel != null) {
//       details.add(Text("Tx Power Level: ${result.advertisementData.txPowerLevel} dBm"));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: details,
//     );
//   }

//   // Helper method to format manufacturer data
//   String _formatManufacturerData(Map<dynamic, List<int>> manufacturerData) {
//     List<String> formattedData = [];
//     manufacturerData.forEach((key, value) {
//       formattedData.add('Manufacturer ID: $key, Data: ${value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');
//     });
//     return formattedData.join('\n');
//   }

//   // Get Advertising Type
//   String _getAdvertisingType(ScanResult result) {
//     // You can expand this to fetch more sophisticated advertising data.
//     return "Legacy"; // Placeholder, you can refine based on specific flags/data.
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
//       body: SafeArea( // Ensuring safe area for the UI
//         child: RefreshIndicator(
//           onRefresh: _refreshDevices, // Trigger the refresh action
//           child: ListView.builder(
//             itemCount: _devices.length,
//             itemBuilder: (context, index) {
//               final result = _devices[index];
//               final isExpanded = _expandedDevices.contains(result.device.id.toString());
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: const Icon(Icons.bluetooth),
//                       title: Text(result.device.name.isNotEmpty ? result.device.name : "Unnamed Device"),
//                       subtitle: Text("ID: ${result.device.id}"),
//                       trailing: Column(
//                         children: [
//                           IconButton(
//                             icon: Icon(isExpanded
//                                 ? Icons.expand_less
//                                 : Icons.expand_more),
//                             onPressed: () => _toggleDeviceDetails(result.device.id.toString()),
//                           ),
//                           ElevatedButton(
//                             onPressed: _connectionStatus[result.device.id.toString()] == 'Connect'
//                                 ? () => _connectToDevice(result)
//                                 : null,
//                             child: Text(_connectionStatus[result.device.id.toString()] ?? "Connect"),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (isExpanded)
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: _buildDeviceDetails(result),
//                       ),
//                     if (_connectionStatus[result.device.id.toString()] == 'Connecting...')
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator(),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
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

      // Fetch additional device data after connection
      await _fetchDeviceData(result.device);

    } catch (e) {
      setState(() {
        _connectionStatus[result.device.id.toString()] = 'Connection Failed'; // Handle failed connection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to connect to ${result.device.name}")),
      );
    }
  }

  Future<void> _fetchDeviceData(BluetoothDevice device) async {
    // Fetching services and characteristics
    List<BluetoothService> services = await device.discoverServices();
    
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        // Fetch data for each characteristic
        var value = await characteristic.read();
        print("Service UUID: ${service.uuid}, Characteristic UUID: ${characteristic.uuid}, Value: $value");
      }
    }
  }

  Widget _buildDeviceDetails(ScanResult result) {
    List<Widget> details = [];

    // Device Name
    details.add(Text("Device Name: ${result.device.name.isNotEmpty ? result.device.name : "Unnamed Device"}"));
    
    // RSSI
    details.add(Text("RSSI: ${result.rssi} dBm"));

    // Advertising Type
    details.add(Text("Advertising Type: ${_getAdvertisingType(result)}"));

    // Manufacturer Data (Bluetooth Core 4.1)
    if (result.advertisementData.manufacturerData.isNotEmpty) {
      details.add(Text("Manufacturer Data:"));
      details.add(Text(_formatManufacturerData(result.advertisementData.manufacturerData)));
    }

    // Complete Local Name
    if (result.advertisementData.localName.isNotEmpty) {
      details.add(Text("Local Name: ${result.advertisementData.localName}"));
    }

    // Service UUIDs
    if (result.advertisementData.serviceUuids.isNotEmpty) {
      details.add(Text("Service UUIDs: ${result.advertisementData.serviceUuids.join(", ")}"));
    }

    // Service Data (Bluetooth 4.0+)
    if (result.advertisementData.serviceData.isNotEmpty) {
      result.advertisementData.serviceData.forEach((uuid, data) {
        details.add(Text("Service Data - UUID: $uuid"));
        details.add(Text("Data: ${_formatManufacturerData({uuid: data})}"));
      });
    }

    // Tx Power Level
    if (result.advertisementData.txPowerLevel != null) {
      details.add(Text("Tx Power Level: ${result.advertisementData.txPowerLevel} dBm"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  // Helper method to format manufacturer data
  String _formatManufacturerData(Map<dynamic, List<int>> manufacturerData) {
    List<String> formattedData = [];
    manufacturerData.forEach((key, value) {
      formattedData.add('Manufacturer ID: $key, Data: ${value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');
    });
    return formattedData.join('\n');
  }

  // Get Advertising Type
  String _getAdvertisingType(ScanResult result) {
    // You can expand this to fetch more sophisticated advertising data.
    return "Legacy"; // Placeholder, you can refine based on specific flags/data.
  }

  Future<void> _refreshDevices() async {
    setState(() {
      _isScanning = true;
    });
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
      body: SafeArea( // Ensuring safe area for the UI
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
                      trailing: Column(
                        children: [
                          IconButton(
                            icon: Icon(isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () => _toggleDeviceDetails(result.device.id.toString()),
                          ),
                          ElevatedButton(
                            onPressed: _connectionStatus[result.device.id.toString()] == 'Connect'
                                ? () => _connectToDevice(result)
                                : null,
                            child: Text(_connectionStatus[result.device.id.toString()] ?? "Connect"),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildDeviceDetails(result),
                      ),
                    if (_connectionStatus[result.device.id.toString()] == 'Connecting...')
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
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
