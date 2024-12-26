// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';


// class DeviceDetailsPage extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

//   @override
//   State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
// }

// class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
//   String connectionStatus = "Disconnected";
//   List<String> serviceList = [];
//   List<String> characteristicList = [];
//   String batteryLevel = "Unavailable";

//   @override
//   void initState() {
//     super.initState();
//     _fetchDeviceDetails();
//   }

//   Future<void> _fetchDeviceDetails() async {
//     try {
//       // Connect to the device
//       await widget.device.connect();
//       setState(() {
//         connectionStatus = "Connected";
//       });

//       // Discover services
//       List<BluetoothService> services = await widget.device.discoverServices();
//       for (var service in services) {
//         serviceList.add("Service UUID: ${service.uuid}");
//         for (var characteristic in service.characteristics) {
//           characteristicList.add("Characteristic UUID: ${characteristic.uuid}");

//           // Read Battery Level if the UUID matches
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             setState(() {
//               batteryLevel = "${value[0]}%";
//             });
//           }
//         }
//       }
//     } catch (e) {
//       setState(() {
//         connectionStatus = "Failed to connect: ${e.toString()}";
//       });
//     }
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text("Device Name: ${widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device"}"),
//             Text("Device ID: ${widget.device.id}"),
//             Text("Connection Status: $connectionStatus"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Battery Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Battery Level: $batteryLevel"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Available Services",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             serviceList.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: serviceList.map((service) => Text(service)).toList(),
//                   )
//                 : const Text("No services found"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Characteristics",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             characteristicList.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: characteristicList.map((char) => Text(char)).toList(),
//                   )
//                 : const Text("No characteristics found"),
//           ],
//         ),
//       ),
//     );
//   }
// // }



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class DeviceDetailsPage extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

//   @override
//   State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
// }

// class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
//   String connectionStatus = "Disconnected";
//   List<String> serviceList = [];
//   List<String> characteristicList = [];
//   String batteryLevel = "Unavailable";

//   @override
//   void initState() {
//     super.initState();
//     _fetchDeviceDetails();
//   }

//   Future<void> _fetchDeviceDetails() async {
//     try {
//       // Connect to the device
//       await widget.device.connect();
//       setState(() {
//         connectionStatus = "Connected";
//       });

//       // Discover services
//       List<BluetoothService> services = await widget.device.discoverServices();
//       print("Discovered services: ${services.length}");

//       for (var service in services) {
//         serviceList.add("Service UUID: ${service.uuid}");
//         for (var characteristic in service.characteristics) {
//           characteristicList.add("Characteristic UUID: ${characteristic.uuid}");
//           // Check for the Battery Level characteristic UUID
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             if (value.isNotEmpty) {
//               setState(() {
//                 batteryLevel = "${value[0]}%";
//               });
//             } else {
//               setState(() {
//                 batteryLevel = "Battery Level Unavailable";
//               });
//             }
//           }
//         }
//       }
//     } catch (e) {
//       setState(() {
//         connectionStatus = "Failed to connect: ${e.toString()}";
//       });
//       print("Error: ${e.toString()}");
//     }
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text("Device Name: ${widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device"}"),
//             Text("Device ID: ${widget.device.id}"),
//             Text("Connection Status: $connectionStatus"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Battery Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Battery Level: $batteryLevel"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Available Services",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             serviceList.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: serviceList.map((service) => Text(service)).toList(),
//                   )
//                 : const Text("No services found"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Characteristics",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             characteristicList.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: characteristicList.map((char) => Text(char)).toList(),
//                   )
//                 : const Text("No characteristics found"),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class DeviceDetailsPage extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

//   @override
//   State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
// }

// class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
//   String connectionStatus = "Disconnected";
//   List<String> serviceList = [];
//   List<String> characteristicList = [];
//   String batteryLevel = "Unavailable";
//   List<BluetoothService> services = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchDeviceDetails();
//   }

//   Future<void> _fetchDeviceDetails() async {
//     try {
//       // Connect to the device
//       await widget.device.connect();
//       setState(() {
//         connectionStatus = "Connected";
//       });

//       // Discover services
//       services = await widget.device.discoverServices();
//       print("Discovered services: ${services.length}");

//       for (var service in services) {
//         serviceList.add("Service UUID: ${service.uuid}");
//         for (var characteristic in service.characteristics) {
//           characteristicList.add("Characteristic UUID: ${characteristic.uuid}");
//           // Check for the Battery Level characteristic UUID
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             if (value.isNotEmpty) {
//               setState(() {
//                 batteryLevel = "${value[0]}%";
//               });
//             } else {
//               setState(() {
//                 batteryLevel = "Battery Level Unavailable";
//               });
//             }
//           }
//         }
//       }
//     } catch (e) {
//       setState(() {
//         connectionStatus = "Failed to connect: ${e.toString()}";
//       });
//       print("Error: ${e.toString()}");
//     }
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text("Device Name: ${widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device"}"),
//             Text("Device ID: ${widget.device.id}"),
//             Text("Connection Status: $connectionStatus"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Battery Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Battery Level: $batteryLevel"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Available Services",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             serviceList.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: serviceList.map((service) => Text(service)).toList(),
//                   )
//                 : const Text("No services found"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Characteristics",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             characteristicList.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: characteristicList.map((char) => Text(char)).toList(),
//                   )
//                 : const Text("No characteristics found"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Known Services (Predefined)",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildServiceDetails("Generic Access", "0x1800", true),
//                 _buildServiceDetails("Generic Attribute", "0x1801", true),
//                 _buildServiceDetails("Device Information", "0x180A", true),
//                 _buildServiceDetails("Battery Service", "0x180F", true),
//                 _buildServiceDetails("Unknown Service", "0xFDF3", true),
//                 _buildServiceDetails("Heart Rate", "0x180D", true),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceDetails(String name, String uuid, bool isPrimary) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(
//             Icons.info,
//             color: Colors.blue,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             "$name\nUUID: $uuid",
//             style: TextStyle(fontSize: 16),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             isPrimary ? "PRIMARY SERVICE" : "SECONDARY SERVICE",
//             style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// // Model to store service and its characteristics
// class BluetoothDeviceModel {
//   String deviceName;
//   String deviceId;
//   String connectionStatus;
//   List<BluetoothServiceModel> services;
//   String batteryLevel;

//   BluetoothDeviceModel({
//     required this.deviceName,
//     required this.deviceId,
//     required this.connectionStatus,
//     required this.services,
//     required this.batteryLevel,
//   });
// }

// class BluetoothServiceModel {
//   String uuid;
//   List<String> characteristics;

//   BluetoothServiceModel({required this.uuid, required this.characteristics});
// }

// class DeviceDetailsPage extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

//   @override
//   State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
// }

// class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
//   late BluetoothDeviceModel _deviceModel;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDeviceDetails();
//   }

//   Future<void> _fetchDeviceDetails() async {
//     try {
//       // Connect to the device
//       await widget.device.connect();
//       String connectionStatus = "Connected";

//       // Discover services
//       List<BluetoothService> services = await widget.device.discoverServices();
//       List<BluetoothServiceModel> serviceModels = [];

//       String batteryLevel = "Unavailable";

//       // Iterate through services and characteristics
//       for (var service in services) {
//         List<String> characteristicList = [];
//         for (var characteristic in service.characteristics) {
//           characteristicList.add(characteristic.uuid.toString());

//           // Check for the Battery Level characteristic UUID
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             batteryLevel = value.isNotEmpty ? "${value[0]}%" : "Battery Level Unavailable";
//           }
//         }

//         // Add the service and its characteristics to the list
//         serviceModels.add(BluetoothServiceModel(
//           uuid: service.uuid.toString(),
//           characteristics: characteristicList,
//         ));
//       }

//       setState(() {
//         _deviceModel = BluetoothDeviceModel(
//           deviceName: widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device",
//           deviceId: widget.device.id.toString(),
//           connectionStatus: connectionStatus,
//           services: serviceModels,
//           batteryLevel: batteryLevel,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _deviceModel = BluetoothDeviceModel(
//           deviceName: widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device",
//           deviceId: widget.device.id.toString(),
//           connectionStatus: "Failed to connect: ${e.toString()}",
//           services: [],
//           batteryLevel: "Battery Level Unavailable",
//         );
//       });
//       print("Error: ${e.toString()}");
//     }
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_deviceModel.deviceName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text("Device Name: ${_deviceModel.deviceName}"),
//             Text("Device ID: ${_deviceModel.deviceId}"),
//             Text("Connection Status: ${_deviceModel.connectionStatus}"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Battery Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Battery Level: ${_deviceModel.batteryLevel}"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Available Services",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             _deviceModel.services.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: _deviceModel.services.map((serviceModel) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Service UUID: ${serviceModel.uuid}"),
//                           const SizedBox(height: 8),
//                           ...serviceModel.characteristics
//                               .map((char) => Text("Characteristic UUID: $char"))
//                               .toList(),
//                           const SizedBox(height: 16),
//                         ],
//                       );
//                     }).toList(),
//                   )
//                 : const Text("No services found"),
//             const SizedBox(height: 16),
//             const Divider(),
//             const Text(
//               "Known Services (Predefined)",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildServiceDetails("Generic Access", "0x1800", true),
//                 _buildServiceDetails("Generic Attribute", "0x1801", true),
//                 _buildServiceDetails("Device Information", "0x180A", true),
//                 _buildServiceDetails("Battery Service", "0x180F", true),
//                 _buildServiceDetails("Unknown Service", "0xFDF3", true),
//                 _buildServiceDetails("Heart Rate", "0x180D", true),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceDetails(String name, String uuid, bool isPrimary) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(
//             Icons.info,
//             color: Colors.blue,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             "$name\nUUID: $uuid",
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             isPrimary ? "PRIMARY SERVICE" : "SECONDARY SERVICE",
//             style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Model to store service and its characteristics
class BluetoothDeviceModel {
  String deviceName;
  String deviceId;
  String connectionStatus;
  List<BluetoothServiceModel> services;
  String batteryLevel;

  BluetoothDeviceModel({
    required this.deviceName,
    required this.deviceId,
    required this.connectionStatus,
    required this.services,
    required this.batteryLevel,
  });
}

class BluetoothServiceModel {
  String uuid;
  List<String> characteristics;

  BluetoothServiceModel({required this.uuid, required this.characteristics});
}

class DeviceDetailsPage extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  late BluetoothDeviceModel _deviceModel;

  @override
  void initState() {
    super.initState();
    _fetchDeviceDetails();
  }

  Future<void> _fetchDeviceDetails() async {
    try {
      // Connect to the device
      await widget.device.connect();
      String connectionStatus = "Connected";

      // Discover services
      List<BluetoothService> services = await widget.device.discoverServices();
      List<BluetoothServiceModel> serviceModels = [];

      String batteryLevel = "Unavailable";

      // Iterate through services and characteristics
      for (var service in services) {
        List<String> characteristicList = [];
        for (var characteristic in service.characteristics) {
          characteristicList.add(characteristic.uuid.toString());

          // Check for the Battery Level characteristic UUID
          if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
            var value = await characteristic.read();
            batteryLevel = value.isNotEmpty ? "${value[0]}%" : "Battery Level Unavailable";
          }
        }

        // Add the service and its characteristics to the list
        serviceModels.add(BluetoothServiceModel(
          uuid: service.uuid.toString(),
          characteristics: characteristicList,
        ));
      }

      setState(() {
        _deviceModel = BluetoothDeviceModel(
          deviceName: widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device",
          deviceId: widget.device.id.toString(),
          connectionStatus: connectionStatus,
          services: serviceModels,
          batteryLevel: batteryLevel,
        );
      });
    } catch (e) {
      setState(() {
        _deviceModel = BluetoothDeviceModel(
          deviceName: widget.device.name.isNotEmpty ? widget.device.name : "Unnamed Device",
          deviceId: widget.device.id.toString(),
          connectionStatus: "Failed to connect: ${e.toString()}",
          services: [],
          batteryLevel: "Battery Level Unavailable",
        );
      });
      print("Error: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_deviceModel.deviceName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Device Name: ${_deviceModel.deviceName}"),
            Text("Device ID: ${_deviceModel.deviceId}"),
            Text("Connection Status: ${_deviceModel.connectionStatus}"),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              "Battery Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Battery Level: ${_deviceModel.batteryLevel}"),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              "Available Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _deviceModel.services.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _deviceModel.services.map((serviceModel) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Service UUID: ${serviceModel.uuid}"),
                          const SizedBox(height: 8),
                          ...serviceModel.characteristics
                              .map((char) => Text("Characteristic UUID: $char"))
                              .toList(),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  )
                : const Text("No services found"),
          ],
        ),
      ),
    );
  }
}
