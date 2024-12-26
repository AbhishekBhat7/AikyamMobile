import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth App',
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
  StreamSubscription? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  bool _isScanning = false;
  DiscoveredDevice? _connectedDevice;

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    _scanSubscription = _ble.scanForDevices(withServices: []).listen(
      (device) {
        if (_devices.every((d) => d.id != device.id)) {
          setState(() {
            _devices.add(device);
          });
        }
      },
      onError: (error) {
        setState(() => _isScanning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Scan error: $error")),
        );
      },
      onDone: () {
        setState(() => _isScanning = false);
      },
    );
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    setState(() => _isScanning = false);
  }

  void _connectToDevice(DiscoveredDevice device) {
    setState(() => _connectedDevice = device);

    _connectionSubscription = _ble
        .connectToDevice(
          id: device.id,
          connectionTimeout: const Duration(seconds: 10),
        )
        .listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connected to ${device.name}")),
        );
        _showConnectedDialog(device);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${device.name} disconnected")),
        );
        setState(() => _connectedDevice = null);
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: $error")),
      );
    });
  }

  void _disconnectDevice() {
    _connectionSubscription?.cancel();
    setState(() {
      _connectedDevice = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Disconnected")),
    );
  }

  void _showConnectedDialog(DiscoveredDevice device) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Connected to ${device.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("ID: ${device.id}"),
              Text("RSSI: ${device.rssi}"),
              Text(
                "Service UUIDs: ${device.serviceUuids.isEmpty ? "None" : device.serviceUuids.join(", ")}",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _disconnectDevice();
              },
              child: const Text("Disconnect"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeviceList() {
    return ListView.builder(
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
        return ListTile(
          title: Text(
            device.name.isNotEmpty ? device.name : "Unknown Device",
          ),
          subtitle: Text("ID: ${device.id}"),
          trailing: IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () => _connectToDevice(device),
          ),
        );
      },
    );
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
      body: Column(
        children: [
          if (_connectedDevice != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text("Connected Device: ${_connectedDevice!.name}"),
                  subtitle: Text("ID: ${_connectedDevice!.id}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _disconnectDevice,
                  ),
                ),
              ),
            ),
          Expanded(
            child: _isScanning
                ? const Center(child: CircularProgressIndicator())
                : _devices.isEmpty
                    ? const Center(child: Text("No devices found."))
                    : _buildDeviceList(),
          ),
        ],
      ),
    );
  }
}
