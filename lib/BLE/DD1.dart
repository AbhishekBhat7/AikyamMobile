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
//   BluetoothDeviceModel? _deviceModel; // Make it nullable

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
//         List<BluetoothCharacteristicModel> characteristicList = [];
//         for (var characteristic in service.characteristics) {
//           characteristicList.add(BluetoothCharacteristicModel(
//             uuid: _convertUuidToHex(characteristic.uuid),
//             properties: _getCharacteristicProperties(characteristic),
//             descriptors: _fetchDescriptors(characteristic),
//           ));
//         }

//         // Add the service and its characteristics to the list
//         serviceModels.add(BluetoothServiceModel(
//           title: _getServiceTitle(service.uuid),
//           uuid: _convertUuidToHex(service.uuid),
//           type: "PRIMARY SERVICE",
//           characteristics: characteristicList,
//         ));
//       }

//       setState(() {
//         _deviceModel = BluetoothDeviceModel(
//           deviceName: widget.device.name.isNotEmpty
//               ? widget.device.name
//               : "Unnamed Device",
//           deviceId: widget.device.id.toString(),
//           connectionStatus: connectionStatus,
//           services: serviceModels,
//           batteryLevel: batteryLevel,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _deviceModel = BluetoothDeviceModel(
//           deviceName: widget.device.name.isNotEmpty
//               ? widget.device.name
//               : "Unnamed Device",
//           deviceId: widget.device.id.toString(),
//           connectionStatus: "Failed to connect: ${e.toString()}",
//           services: [],
//           batteryLevel: "Battery Level Unavailable",
//         );
//       });
//       print("Error: ${e.toString()}");
//     }
//   }

//   String _convertUuidToHex(Guid uuid) {
//     return '0x${uuid.toString().split('-').last.substring(0, 4)}'; // 0xXXXX
//   }

//   // Fetch properties for characteristics
//   String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
//     List<String> properties = []; // Use a List to collect properties
//     if (characteristic.properties.read) properties.add('READ');
//     if (characteristic.properties.write) properties.add('WRITE');
//     if (characteristic.properties.notify) properties.add('NOTIFY');
//     if (characteristic.properties.indicate) properties.add('INDICATE');
//     if (characteristic.properties.writeWithoutResponse)
//       properties.add('WRITE NO RESPONSE'); // Added WRITE NO RESPONSE
//     return properties.isEmpty
//         ? "No properties"
//         : properties.join(', '); // Join list into a string
//   }

//   // Fetch descriptors for a characteristic
//   List<BluetoothDescriptorModel> _fetchDescriptors(
//       BluetoothCharacteristic characteristic) {
//     return characteristic.descriptors.isNotEmpty
//         ? characteristic.descriptors.map((descriptor) {
//             return BluetoothDescriptorModel(
//               uuid: _convertUuidToHex(descriptor.uuid),
//               properties:
//                   "Client Characteristic Configuration", // Default descriptor property
//             );
//           }).toList()
//         : []; // Return an empty list if no descriptors exist
//   }

//   // Get service title based on UUID
//   String _getServiceTitle(Guid uuid) {
//     Map<String, String> services = {
//       "0x1800": "Generic Access",
//       "0x1801": "Generic Attribute",
//       "0x180A": "Device Information",
//       "0x180F": "Battery Service",
//       "0x2A05": "Service Changed",
//       "0x2902": "Client Characteristic Configuration",
//     };
//     return services[uuid.toString()] ?? "Unknown Service";
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
//         title: Text(_deviceModel?.deviceName ?? "Unnamed Device"), // Null check
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildMainCard(),
//             const SizedBox(height: 16),
//             _buildBatteryInfo(),
//             const SizedBox(height: 16),
//             _buildServicesList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainCard() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Device Name: ${_deviceModel?.deviceName ?? "Loading..."}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Device ID: ${_deviceModel?.deviceId ?? "Loading..."}"),
//             Text("Connection Status: ${_deviceModel?.connectionStatus ?? "Loading..."}"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBatteryInfo() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Battery Level: ${_deviceModel?.batteryLevel ?? "Loading..."}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServicesList() {
//     return _deviceModel?.services.isNotEmpty ?? false
//         ? Column(
//             children: _deviceModel!.services.map((serviceModel) {
//               return Card(
//                 elevation: 4.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ExpansionTile(
//                     title: Text(
//                         "Title: ${serviceModel.title}\nUUID: ${serviceModel.uuid}\nType: ${serviceModel.type}",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     children: [
//                       Column(
//                         children: serviceModel.characteristics.map((charModel) {
//                           return _buildCharacteristicCard(charModel);
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           )
//         : const Text("No services found");
//   }

//   Widget _buildCharacteristicCard(BluetoothCharacteristicModel charModel) {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ExpansionTile(
//           title: Text(
//               "Characteristic UUID: ${charModel.uuid}\nProperties: ${charModel.properties}",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           children: [
//             _buildDescriptors(charModel.descriptors),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDescriptors(List<BluetoothDescriptorModel> descriptors) {
//     if (descriptors.isNotEmpty) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: descriptors.map((desc) {
//           return Card(
//             elevation: 4.0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Descriptor UUID: ${desc.uuid}"),
//                   Text("Properties: ${desc.properties}"),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       );
//     } else {
//       return const SizedBox.shrink(); // Return empty widget if no descriptors
//     }
//   }
// }

// // Bluetooth Service Model
// class BluetoothServiceModel {
//   String title;
//   String uuid;
//   String type;
//   List<BluetoothCharacteristicModel> characteristics;

//   BluetoothServiceModel({
//     required this.title,
//     required this.uuid,
//     required this.type,
//     required this.characteristics,
//   });
// }

// // Bluetooth Characteristic Model
// class BluetoothCharacteristicModel {
//   String uuid;
//   String properties;
//   List<BluetoothDescriptorModel> descriptors;

//   BluetoothCharacteristicModel({
//     required this.uuid,
//     required this.properties,
//     required this.descriptors,
//   });
// }

// // Bluetooth Descriptor Model
// class BluetoothDescriptorModel {
//   String uuid;
//   String properties;

//   BluetoothDescriptorModel({
//     required this.uuid,
//     required this.properties,
//   });
// }

// // Bluetooth Device Model
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


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDetailsPage extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  BluetoothDeviceModel? _deviceModel;

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
        List<BluetoothCharacteristicModel> characteristicList = [];
        for (var characteristic in service.characteristics) {
          characteristicList.add(BluetoothCharacteristicModel(
            uuid: _convertUuidToHex(characteristic.uuid),
            properties: _getCharacteristicProperties(characteristic),
            descriptors: _fetchDescriptors(characteristic),
          ));
        }

        // Add the service and its characteristics to the list
        serviceModels.add(BluetoothServiceModel(
          title: _getServiceTitle(service.uuid),
          uuid: _convertUuidToHex(service.uuid),
          type: "PRIMARY SERVICE",
          characteristics: characteristicList,
        ));
      }

      setState(() {
        _deviceModel = BluetoothDeviceModel(
          deviceName: widget.device.name.isNotEmpty
              ? widget.device.name
              : "Unnamed Device",
          deviceId: widget.device.id.toString(),
          connectionStatus: connectionStatus,
          services: serviceModels,
          batteryLevel: batteryLevel,
        );
      });
    } catch (e) {
      setState(() {
        _deviceModel = BluetoothDeviceModel(
          deviceName: widget.device.name.isNotEmpty
              ? widget.device.name
              : "Unnamed Device",
          deviceId: widget.device.id.toString(),
          connectionStatus: "Failed to connect: ${e.toString()}",
          services: [],
          batteryLevel: "Battery Level Unavailable",
        );
      });
      print("Error: ${e.toString()}");
    }
  }

  String _convertUuidToHex(Guid uuid) {
    return '0x${uuid.toString().split('-').last.substring(0, 4)}'; // 0xXXXX
  }

  // Fetch properties for characteristics
  String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
    List<String> properties = [];
    if (characteristic.properties.read) properties.add('READ');
    if (characteristic.properties.write) properties.add('WRITE');
    if (characteristic.properties.notify) properties.add('NOTIFY');
    if (characteristic.properties.indicate) properties.add('INDICATE');
    if (characteristic.properties.writeWithoutResponse)
      properties.add('WRITE NO RESPONSE');
    return properties.isEmpty
        ? "No properties"
        : properties.join(', ');
  }

  // Fetch descriptors for a characteristic
  List<BluetoothDescriptorModel> _fetchDescriptors(
      BluetoothCharacteristic characteristic) {
    return characteristic.descriptors.isNotEmpty
        ? characteristic.descriptors.map((descriptor) {
            return BluetoothDescriptorModel(
              uuid: _convertUuidToHex(descriptor.uuid),
              properties:
                  "Client Characteristic Configuration", // Default descriptor property
            );
          }).toList()
        : [];
  }

  // Get service title based on UUID (updated to support dynamic titles)
  String _getServiceTitle(Guid uuid) {
    Map<String, String> services = {
      "1800": "Generic Access", // Generic Access
      "1801": "Generic Attribute", // Generic Attribute
      "180A": "Device Information", // Device Information
      "180F": "Battery Service", // Battery Service
      "2A05": "Service Changed", // Service Changed
      "2902": "Client Characteristic Configuration", // Client Characteristic Configuration
      "184C": " ABX"
      // Add more UUID mappings as required
    };

    // Convert UUID to a string without hyphens and in uppercase
    String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');

    // If the UUID exists in our predefined map, return the name
    if (services.containsKey(serviceUuidString)) {
      return services[serviceUuidString]!;
    }

    // If not found in the map, try to return a more descriptive fallback
    return "Unknown Service (UUID: $serviceUuidString)";
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
        title: Text(_deviceModel?.deviceName ?? "Unnamed Device"), // Null check
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMainCard(),
            const SizedBox(height: 16),
            _buildBatteryInfo(),
            const SizedBox(height: 16),
            _buildServicesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Device Name: ${_deviceModel?.deviceName ?? "Loading..."}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Device ID: ${_deviceModel?.deviceId ?? "Loading..."}"),
            Text("Connection Status: ${_deviceModel?.connectionStatus ?? "Loading..."}"),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryInfo() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Battery Level: ${_deviceModel?.batteryLevel ?? "Loading..."}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return _deviceModel?.services.isNotEmpty ?? false
        ? Column(
            children: _deviceModel!.services.map((serviceModel) {
              return Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ExpansionTile(
                    title: Text(
                        "Title: ${serviceModel.title}\nUUID: ${serviceModel.uuid}\nType: ${serviceModel.type}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      Column(
                        children: serviceModel.characteristics.map((charModel) {
                          return _buildCharacteristicCard(charModel);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : const Text("No services found");
  }

  Widget _buildCharacteristicCard(BluetoothCharacteristicModel charModel) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Text(
              "Characteristic UUID: ${charModel.uuid}\nProperties: ${charModel.properties}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          children: [
            _buildDescriptors(charModel.descriptors),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptors(List<BluetoothDescriptorModel> descriptors) {
    if (descriptors.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: descriptors.map((desc) {
          return Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Descriptor UUID: ${desc.uuid}"),
                  Text("Properties: ${desc.properties}"),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

// Models for Service, Characteristic, and Descriptor remain the same
// Bluetooth Service Model
class BluetoothServiceModel {
  String title;
  String uuid;
  String type;
  List<BluetoothCharacteristicModel> characteristics;

  BluetoothServiceModel({
    required this.title,
    required this.uuid,
    required this.type,
    required this.characteristics,
  });
}

// Bluetooth Characteristic Model
class BluetoothCharacteristicModel {
  String uuid;
  String properties;
  List<BluetoothDescriptorModel> descriptors;

  BluetoothCharacteristicModel({
    required this.uuid,
    required this.properties,
    required this.descriptors,
  });
}

// Bluetooth Descriptor Model
class BluetoothDescriptorModel {
  String uuid;
  String properties;

  BluetoothDescriptorModel({
    required this.uuid,
    required this.properties,
  });
}

// Bluetooth Device Model
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

