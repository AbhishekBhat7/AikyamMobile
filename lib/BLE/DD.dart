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
//           characteristicList.add(_convertUuidToHex(characteristic.uuid));

//           // Check for the Battery Level characteristic UUID
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             batteryLevel = value.isNotEmpty ? "${value[0]}%" : "Battery Level Unavailable";
//           }
//         }

//         // Add the service and its characteristics to the list
//         serviceModels.add(BluetoothServiceModel(
//           uuid: _convertUuidToHex(service.uuid),
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

//   // Convert UUID to Hexadecimal (shortened)
//   String _convertUuidToHex(Guid uuid) {
//     // Get the last 16 bits and display them as a short hexadecimal value
//     var hex = uuid.toString().split('-').last; // Get last 12 characters (after the dash)
//     var shortenedHex = hex.substring(0, 4); // Take the first 4 characters for a compact form
//     return '0x$shortenedHex'; // Format as 0xXXXX
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
//         List<BluetoothDescriptorModel> descriptorList = [];
//         for (var characteristic in service.characteristics) {
//           characteristicList.add(_convertUuidToHex(characteristic.uuid));

//           // Check for the Battery Level characteristic UUID
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             batteryLevel = value.isNotEmpty ? "${value[0]}%" : "Battery Level Unavailable";
//           }

//           // Add descriptors for the characteristic if available
//           for (var descriptor in characteristic.descriptors) {
//             descriptorList.add(BluetoothDescriptorModel(
//               uuid: _convertUuidToHex(descriptor.uuid),
//               // No property information is available directly for descriptors.
//               properties: "Descriptor available",  // Assuming descriptor presence as info
//             ));
//           }
//         }

//         // Add the service and its characteristics to the list
//         serviceModels.add(BluetoothServiceModel(
//           uuid: _convertUuidToHex(service.uuid),
//           characteristics: characteristicList,
//           descriptors: descriptorList,
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

//   // Convert UUID to Hexadecimal (shortened)
//   String _convertUuidToHex(Guid uuid) {
//     // Get the last 16 bits and display them as a short hexadecimal value
//     var hex = uuid.toString().split('-').last; // Get last 12 characters (after the dash)
//     var shortenedHex = hex.substring(0, 4); // Take the first 4 characters for a compact form
//     return '0x$shortenedHex'; // Format as 0xXXXX
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

//   // Build the main device information card
//   Widget _buildMainCard() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Device Name: ${_deviceModel.deviceName}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Device ID: ${_deviceModel.deviceId}"),
//             Text("Connection Status: ${_deviceModel.connectionStatus}"),
//           ],
//         ),
//       ),
//     );
//   }

//   // Battery Information Card
//   Widget _buildBatteryInfo() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Battery Level: ${_deviceModel.batteryLevel}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the Services list with each service as a card
//   Widget _buildServicesList() {
//     return _deviceModel.services.isNotEmpty
//         ? Column(
//             children: _deviceModel.services.map((serviceModel) {
//               return Card(
//                 elevation: 4.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ExpansionTile(
//                     title: Text("Service UUID: ${serviceModel.uuid}",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     children: [
//                       Column(
//                         children: serviceModel.characteristics.map((charUuid) {
//                           return _buildCharacteristicCard(charUuid);
//                         }).toList(),
//                       ),
//                       _buildDescriptors(serviceModel.descriptors),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           )
//         : const Text("No services found");
//   }

//   // Build the Characteristic card
//   Widget _buildCharacteristicCard(String characteristicUuid) {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Characteristic UUID: $characteristicUuid"),
//             // Add the properties of the characteristic here if needed
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the Descriptor cards
//   Widget _buildDescriptors(List<BluetoothDescriptorModel> descriptors) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: descriptors.isNotEmpty
//           ? descriptors.map((desc) {
//               return Card(
//                 elevation: 4.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Descriptor UUID: ${desc.uuid}"),
//                       Text("Properties: ${desc.properties}"),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList()
//           : [Text("No Descriptors found for this characteristic.")],
//     );
//   }
// }

// // Bluetooth Service Model
// class BluetoothServiceModel {
//   String uuid;
//   List<String> characteristics;
//   List<BluetoothDescriptorModel> descriptors;

//   BluetoothServiceModel({
//     required this.uuid,
//     required this.characteristics,
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
//         List<BluetoothDescriptorModel> descriptorList = [];
//         for (var characteristic in service.characteristics) {
//           characteristicList.add(_convertUuidToHex(characteristic.uuid));

//           // Check for the Battery Level characteristic UUID
//           if (characteristic.uuid.toString() == "00002a19-0000-1000-8000-00805f9b34fb") {
//             var value = await characteristic.read();
//             batteryLevel = value.isNotEmpty ? "${value[0]}%" : "Battery Level Unavailable";
//           }

//           // Add descriptors for the characteristic if available
//           for (var descriptor in characteristic.descriptors) {
//             descriptorList.add(BluetoothDescriptorModel(
//               uuid: _convertUuidToHex(descriptor.uuid),
//               // No property information is available directly for descriptors.
//               properties: "Descriptor available",  // Assuming descriptor presence as info
//             ));
//           }
//         }

//         // Add the service and its characteristics to the list
//         serviceModels.add(BluetoothServiceModel(
//           uuid: _convertUuidToHex(service.uuid),
//           characteristics: characteristicList,
//           descriptors: descriptorList,
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

//   // Convert UUID to Hexadecimal (shortened)
//   String _convertUuidToHex(Guid uuid) {
//     // Get the last 16 bits and display them as a short hexadecimal value
//     var hex = uuid.toString().split('-').last; // Get last 12 characters (after the dash)
//     var shortenedHex = hex.substring(0, 4); // Take the first 4 characters for a compact form
//     return '0x$shortenedHex'; // Format as 0xXXXX
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

//   // Build the main device information card
//   Widget _buildMainCard() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Device Name: ${_deviceModel.deviceName}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Device ID: ${_deviceModel.deviceId}"),
//             Text("Connection Status: ${_deviceModel.connectionStatus}"),
//           ],
//         ),
//       ),
//     );
//   }

//   // Battery Information Card
//   Widget _buildBatteryInfo() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Battery Level: ${_deviceModel.batteryLevel}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the Services list with each service as a card
//   Widget _buildServicesList() {
//     return _deviceModel.services.isNotEmpty
//         ? Column(
//             children: _deviceModel.services.map((serviceModel) {
//               return Card(
//                 elevation: 4.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ExpansionTile(
//                     title: Text("Service UUID: ${serviceModel.uuid}",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     children: [
//                       Column(
//                         children: serviceModel.characteristics.map((charUuid) {
//                           return _buildCharacteristicCard(charUuid);
//                         }).toList(),
//                       ),
//                       _buildDescriptors(serviceModel.descriptors),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           )
//         : const Text("No services found");
//   }

//   // Build the Characteristic card
//   Widget _buildCharacteristicCard(String characteristicUuid) {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Characteristic UUID: $characteristicUuid"),
//             // Add the properties of the characteristic here if needed
//           ],
//         ),
//       ),
//     );
//   }

//   // Build the Descriptor cards
//   Widget _buildDescriptors(List<BluetoothDescriptorModel> descriptors) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: descriptors.isNotEmpty
//           ? descriptors.map((desc) {
//               return Card(
//                 elevation: 4.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Descriptor UUID: ${desc.uuid}"),
//                       Text("Properties: ${desc.properties}"),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList()
//           : [Text("No Descriptors found for this characteristic.")],
//     );
//   }
// }

// // Bluetooth Service Model
// class BluetoothServiceModel {
//   String uuid;
//   List<String> characteristics;
//   List<BluetoothDescriptorModel> descriptors;

//   BluetoothServiceModel({
//     required this.uuid,
//     required this.characteristics,
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

  String _convertUuidToHex(Guid uuid) {
    return '0x${uuid.toString().split('-').last.substring(0, 4)}'; // 0xXXXX
  }

  // Fetch properties for characteristics
  String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
    List<String> properties = [];  // Use a List to collect properties
    if (characteristic.properties.read) properties.add('READ');
    if (characteristic.properties.write) properties.add('WRITE');
    if (characteristic.properties.notify) properties.add('NOTIFY');
    if (characteristic.properties.indicate) properties.add('INDICATE');
    if (characteristic.properties.writeWithoutResponse) properties.add('WRITE NO RESPONSE');  // Added WRITE NO RESPONSE
    return properties.isEmpty ? "No properties" : properties.join(', ');  // Join list into a string
  }

  // Fetch descriptors for a characteristic
  List<BluetoothDescriptorModel> _fetchDescriptors(BluetoothCharacteristic characteristic) {
    return characteristic.descriptors.isNotEmpty
        ? characteristic.descriptors.map((descriptor) {
            return BluetoothDescriptorModel(
              uuid: _convertUuidToHex(descriptor.uuid),
              properties: "Client Characteristic Configuration", // Default descriptor property
            );
          }).toList()
        : []; // Return an empty list if no descriptors exist
  }

  // Get service title based on UUID
  String _getServiceTitle(Guid uuid) {
    Map<String, String> services = {
      "0x1800": "Generic Access",
      "0x1801": "Generic Attribute",
      "0x180A": "Device Information",
      "0x180F": "Battery Service",
      "0x2A05": "Service Changed",
      "0x2902": "Client Characteristic Configuration",
    };
    return services[uuid.toString()] ?? "Unknown Service";
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
        title: Text(_deviceModel.deviceName.isNotEmpty ? _deviceModel.deviceName : "Unnamed Device"),  // Fix for device name issue
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
            Text("Device Name: ${_deviceModel.deviceName}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Device ID: ${_deviceModel.deviceId}"),
            Text("Connection Status: ${_deviceModel.connectionStatus}"),
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
            Text("Battery Level: ${_deviceModel.batteryLevel}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return _deviceModel.services.isNotEmpty
        ? Column(
            children: _deviceModel.services.map((serviceModel) {
              return Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ExpansionTile(
                    title: Text(
                        "Title: ${serviceModel.title}\nUUID: ${serviceModel.uuid}\nType: ${serviceModel.type}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  // Widget _buildDescriptors(List<BluetoothDescriptorModel> descriptors) {
  //   return descriptors.isNotEmpty
  //       ? Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: descriptors.map((desc) {
  //             return Card(
  //               elevation: 4.0,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text("Descriptor UUID: ${desc.uuid}"),
  //                     Text("Properties: ${desc.properties}"),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         )
  //       : [Text("No Descriptors found for this characteristic.")]; // Only show if descriptors exist
  // }
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
    // Return a Column with a Text widget saying "No Descriptors found"
    return Column(
      children: [
        Text(
          "No Descriptors found for this characteristic.",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

}

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
