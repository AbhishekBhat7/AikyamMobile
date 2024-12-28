import 'dart:async';
import 'package:aikyamm/authentication/DashBoards/Devices/ex1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/database/db_helper.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
 

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
    var bluetoothScanPermissionStatus =
        await Permission.bluetoothScan.request();
    var bluetoothConnectPermissionStatus =
        await Permission.bluetoothConnect.request();

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
        const SnackBar(
            content: Text("Bluetooth is turned off. Please enable it.")),
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
            _connectionStatus[result.device.id.toString()] =
                'Connect'; // Show connect button
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
      _connectionStatus[result.device.id.toString()] =
          'Connecting...'; // Show Connecting
    });

    try {
      await result.device.connect();
      setState(() {
        _connectionStatus[result.device.id.toString()] =
            'Connected'; // Show Connected
      });

      // Save the device in the database
      Device device =
          Device(id: result.device.id.toString(), name: result.device.name);
      await DatabaseHelper.instance.insertDevice(device);

      // Fetch saved devices to refresh the list
      _refreshDevices();

      // Navigate to the Device Details page
      // if (mounted) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => DeviceDetailsPage(device: result.device),
      //     ),
      //   );
      // }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>DeviceConfigurationsPage(device: result.device)
          ),
        );

    } catch (e) {
      setState(() {
        _connectionStatus[result.device.id.toString()] =
            'Connection Failed'; // Handle failed connection
      });
      ScaffoldMessenger.of(context).showSnackBar(
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

    final List<Device> savedDevices =
        await DatabaseHelper.instance.getDevices();
    setState(() {
      _devices.clear();
      for (var device in savedDevices) {
        final bluetoothDevice =
            BluetoothDevice(remoteId: DeviceIdentifier(device.id));

        final advertisementData = AdvertisementData(
          advName: device.name,
          txPowerLevel: null,
          appearance: null,
          connectable: true,
          manufacturerData: {},
          serviceData: {},
          serviceUuids: [],
        );

        _devices.add(
          ScanResult(
            device: bluetoothDevice,
            advertisementData: advertisementData,
            rssi: -1,
            timeStamp: DateTime.now(),
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
            // Ensure you're only popping when the widget is still mounted
            if (mounted) {
              Navigator.pop(context);
              print("We Back to the page"); // Proper back navigation
            } else {
              print('not possiblr');
              
            }
          },
        ),
        elevation: 5,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDevices,
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
                        Icon(Icons.add_circle_outline,
                            color: MainColors.white, size: 22),
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
                      final deviceStatus =
                          _connectionStatus[result.device.id.toString()] ??
                              'Connect';

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
                                    result.device.name.isEmpty
                                        ? "Unknown Device"
                                        : result.device.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    result.device.id.toString(),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _connectToDevice(result),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: MainColors.white,
                                backgroundColor: MainColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
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
