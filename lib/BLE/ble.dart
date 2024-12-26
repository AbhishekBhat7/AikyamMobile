import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
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
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final List<DiscoveredDevice> _devices = [];
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
    final bluetoothState = await _ble.statusStream.first;
    return bluetoothState == BleStatus.ready;
  }

  void _startScan() async {
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

    _scanSubscription = _ble.scanForDevices(withServices: []).listen(
      (device) {
        setState(() {
          if (_devices.every((d) => d.id != device.id)) {
            _devices.add(device);
          }
        });
      },
      onError: (error) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Scan error: $error")),
        );
      },
    );

    Timer(const Duration(seconds: 5), () {
      if (_isScanning) {
        _stopScan();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Scan completed.")),
        );
      }
    });
  }

  void _stopScan() {
    _scanSubscription?.cancel();
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

  Widget _buildDeviceDetails(DiscoveredDevice device) {
    List<Widget> details = [];

    // Add device ID
    details.add(Text("Device ID: ${device.id}"));

    // Add device name
    details.add(Text("Complete Local Name: ${device.name.isNotEmpty ? device.name : "N/A"}"));

    // Add RSSI
    details.add(Text("RSSI: ${device.rssi}"));

    // Add service UUIDs, if available
    if (device.serviceUuids.isNotEmpty) {
      details.add(Text("Complete list of 16-bit Service UUIDs: ${device.serviceUuids.join(", ")}"));
    }

    // Add manufacturer data if available
    if (device.manufacturerData.isNotEmpty) {
      details.add(Text("Manufacturer data (Bluetooth Core 4.1):\n${_formatManufacturerData(device.manufacturerData)}"));
    }

    // Add service data if available
    if (device.serviceData.isNotEmpty) {
      device.serviceData.forEach((uuid, data) {
        details.add(Text("Service Data: UUID: $uuid Data: ${_formatManufacturerData(data)}"));
      });
    }

    // Return all the dynamically added widgets
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details,
    );
  }

  /// Helper method to format raw manufacturer data into a human-readable string
  String _formatManufacturerData(Uint8List data) {
    return data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
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
        child: _isScanning
            ? const CircularProgressIndicator()
            : _devices.isEmpty
                ? const Text("No devices found. Tap search to scan.")
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      final isExpanded = _expandedDevices.contains(device.id);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.bluetooth),
                              title: Text(device.name.isNotEmpty ? device.name : "Unnamed Device"),
                              subtitle: Text("ID: ${device.id}"),
                              trailing: IconButton(
                                icon: Icon(isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                onPressed: () => _toggleDeviceDetails(device.id),
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildDeviceDetails(device),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
