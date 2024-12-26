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
//   BluetoothDeviceModel? _deviceModel;
//   TextEditingController _writeController = TextEditingController();
//   BluetoothCharacteristicModel? _selectedCharacteristicForWrite;

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
//             descriptors: _fetchDescriptors(characteristic), // Fetch descriptors
//             value: null, // Start with no value
//             characteristic: characteristic, // Store reference to the characteristic
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

//   // Read the value of a characteristic
//   Future<void> _readCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       List<int> value = await charModel.characteristic!.read();
//       setState(() {
//         charModel.value = String.fromCharCodes(value);
//       });
//     } catch (e) {
//       setState(() {
//         charModel.value = 'Read failed: ${e.toString()}';
//       });
//     }
//   }

//   // Write the value to a characteristic
//   Future<void> _writeCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       // Convert the string to bytes
//       List<int> bytes = _writeController.text.codeUnits;

//       await charModel.characteristic!.write(bytes);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
//       setState(() {
//         charModel.value = _writeController.text; // Update the value with the written text
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
//     }
//   }

//   String _convertUuidToHex(Guid uuid) {
//     return '0x${uuid.toString().split('-').last.substring(0, 4)}'; // 0xXXXX
//   }

//   // Fetch properties for characteristics
//   String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
//     List<String> properties = [];
//     if (characteristic.properties.read) properties.add('READ');
//     if (characteristic.properties.write) properties.add('WRITE');
//     if (characteristic.properties.notify) properties.add('NOTIFY');
//     if (characteristic.properties.indicate) properties.add('INDICATE');
//     if (characteristic.properties.writeWithoutResponse)
//       properties.add('WRITE NO RESPONSE');
//     return properties.isEmpty
//         ? "No properties"
//         : properties.join(', ');
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
//         : [];
//   }

//   // Get service title based on UUID (updated to support dynamic titles)
//   String _getServiceTitle(Guid uuid) {
//     Map<String, String> services = {
//       "1800": "Generic Access", // Generic Access
//       "1801": "Generic Attribute", // Generic Attribute
//       "180A": "Device Information", // Device Information
//       "180F": "Battery Service", // Battery Service
//       "2A05": "Service Changed", // Service Changed
//       "2902": "Client Characteristic Configuration", // Client Characteristic Configuration
//       "184C": "ABX"
//       // Add more UUID mappings as required
//     };

//     // Convert UUID to a string without hyphens and in uppercase
//     String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');

//     // If the UUID exists in our predefined map, return the name
//     if (services.containsKey(serviceUuidString)) {
//       return services[serviceUuidString]!; 
//     }

//     // If not found in the map, try to return a more descriptive fallback
//     return "Unknown Service (UUID: $serviceUuidString)";
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     _writeController.dispose();  // Dispose the controller when done
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
//             if (_selectedCharacteristicForWrite != null) _buildWriteCharacteristicView(),
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
//             Row(
//               children: [
//                 if (charModel.properties.contains('READ'))
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (charModel.characteristic != null) {
//                         await _readCharacteristic(charModel);
//                       }
//                     },
//                     child: const Text("Read"),
//                   ),
//                 if (charModel.properties.contains('WRITE'))
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _selectedCharacteristicForWrite = charModel;
//                       });
//                     },
//                     child: const Text("Write"),
//                   ),
//               ],
//             ),
//             if (charModel.value != null)
//               Text("Value: ${charModel.value}", style: TextStyle(fontSize: 14)),
//             if (charModel.descriptors.isNotEmpty) ...[
//               const Divider(),
//               Text(
//                 "Descriptors:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: charModel.descriptors.map((descriptor) {
//                   return Card(
//                     elevation: 4.0,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Descriptor UUID: ${descriptor.uuid}",
//                               style: TextStyle(fontSize: 14)),
//                           Text("Properties: ${descriptor.properties}",
//                               style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWriteCharacteristicView() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _writeController,
//               decoration: InputDecoration(
//                 labelText: "Enter value to write",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_selectedCharacteristicForWrite != null) {
//                   await _writeCharacteristic(_selectedCharacteristicForWrite!);
//                 }
//               },
//               child: Text("Send"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Models remain the same...

// // Models for Service, Characteristic, and Descriptor remain the same
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
//   String? value;
//   BluetoothCharacteristic? characteristic;

//   BluetoothCharacteristicModel({
//     required this.uuid,
//     required this.properties,
//     required this.descriptors,
//     this.value,
//     this.characteristic,
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
//   BluetoothDeviceModel? _deviceModel;
//   TextEditingController _writeController = TextEditingController();
//   BluetoothCharacteristicModel? _selectedCharacteristicForWrite;

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
//             descriptors: _fetchDescriptors(characteristic), // Fetch descriptors
//             value: null, // Start with no value
//             characteristic: characteristic, // Store reference to the characteristic
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

//   // Read the value of a characteristic
//   Future<void> _readCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       List<int> value = await charModel.characteristic!.read();
//       setState(() {
//         charModel.value = String.fromCharCodes(value);
//       });
//     } catch (e) {
//       setState(() {
//         charModel.value = 'Read failed: ${e.toString()}';
//       });
//     }
//   }

//   // Write the value to a characteristic
//   Future<void> _writeCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       // Convert the string to bytes
//       List<int> bytes = _writeController.text.codeUnits;

//       await charModel.characteristic!.write(bytes);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
//       setState(() {
//         charModel.value = _writeController.text; // Update the value with the written text
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
//     }
//   }

//   // Read descriptor value
//   Future<void> _readDescriptor(BluetoothDescriptorModel descriptor) async {
//     try {
//       List<int> value = await descriptor.characteristic!.read();
//       setState(() {
//         descriptor.value = String.fromCharCodes(value);
//       });
//     } catch (e) {
//       setState(() {
//         descriptor.value = 'Read failed: ${e.toString()}';
//       });
//     }
//   }

//   String _convertUuidToHex(Guid uuid) {
//     return '0x${uuid.toString().split('-').last.substring(0, 4)}'; // 0xXXXX
//   }

//   // Fetch properties for characteristics
//   String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
//     List<String> properties = [];
//     if (characteristic.properties.read) properties.add('READ');
//     if (characteristic.properties.write) properties.add('WRITE');
//     if (characteristic.properties.notify) properties.add('NOTIFY');
//     if (characteristic.properties.indicate) properties.add('INDICATE');
//     if (characteristic.properties.writeWithoutResponse)
//       properties.add('WRITE NO RESPONSE');
//     return properties.isEmpty
//         ? "No properties"
//         : properties.join(', ');
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
//               characteristic: descriptor, // Store reference to the descriptor
//             );
//           }).toList()
//         : [];
//   }

//   // Get service title based on UUID (updated to support dynamic titles)
//   String _getServiceTitle(Guid uuid) {
//     Map<String, String> services = {
//       "1800": "Generic Access", // Generic Access
//       "1801": "Generic Attribute", // Generic Attribute
//       "180A": "Device Information", // Device Information
//       "180F": "Battery Service", // Battery Service
//       "2A05": "Service Changed", // Service Changed
//       "2902": "Client Characteristic Configuration", // Client Characteristic Configuration
//       "184C": "ABX"
//       // Add more UUID mappings as required
//     };

//     // Convert UUID to a string without hyphens and in uppercase
//     String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');

//     // If the UUID exists in our predefined map, return the name
//     if (services.containsKey(serviceUuidString)) {
//       return services[serviceUuidString]!; 
//     }

//     // If not found in the map, try to return a more descriptive fallback
//     return "Unknown Service (UUID: $serviceUuidString)";
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     _writeController.dispose();  // Dispose the controller when done
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
//             if (_selectedCharacteristicForWrite != null) _buildWriteCharacteristicView(),
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
//             Row(
//               children: [
//                 if (charModel.properties.contains('READ'))
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (charModel.characteristic != null) {
//                         await _readCharacteristic(charModel);
//                       }
//                     },
//                     child: const Text("Read"),
//                   ),
//                 if (charModel.properties.contains('WRITE'))
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _selectedCharacteristicForWrite = charModel;
//                       });
//                     },
//                     child: const Text("Write"),
//                   ),
//               ],
//             ),
//             if (charModel.value != null)
//               Text("Value: ${charModel.value}", style: TextStyle(fontSize: 14)),
//             if (charModel.descriptors.isNotEmpty) ...[
//               const Divider(),
//               Text(
//                 "Descriptors:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: charModel.descriptors.map((descriptor) {
//                   return Card(
//                     elevation: 4.0,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Descriptor UUID: ${descriptor.uuid}",
//                               style: TextStyle(fontSize: 14)),
//                           Text("Properties: ${descriptor.properties}",
//                               style: TextStyle(fontSize: 14)),
//                           ElevatedButton(
//                             onPressed: () async {
//                               await _readDescriptor(descriptor);
//                             },
//                             child: const Text("Read Descriptor"),
//                           ),
//                           if (descriptor.value != null)
//                             Text("Value: ${descriptor.value}",
//                                 style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWriteCharacteristicView() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _writeController,
//               decoration: InputDecoration(
//                 labelText: "Enter value to write",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_selectedCharacteristicForWrite != null) {
//                   await _writeCharacteristic(_selectedCharacteristicForWrite!);
//                 }
//               },
//               child: Text("Send"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Models remain the same...

// // Models for Service, Characteristic, and Descriptor remain the same
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
//   String? value;
//   BluetoothCharacteristic? characteristic;

//   BluetoothCharacteristicModel({
//     required this.uuid,
//     required this.properties,
//     required this.descriptors,
//     this.value,
//     this.characteristic,
//   });
// }

// // Bluetooth Descriptor Model
// class BluetoothDescriptorModel {
//   String uuid;
//   String properties;
//   String? value;
//   BluetoothDescriptor? characteristic;

//   BluetoothDescriptorModel({
//     required this.uuid,
//     required this.properties,
//     this.characteristic,
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
//   BluetoothDeviceModel? _deviceModel;
//   TextEditingController _writeController = TextEditingController();
//   BluetoothCharacteristicModel? _selectedCharacteristicForWrite;

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
//             descriptors: _fetchDescriptors(characteristic), // Fetch descriptors
//             value: null, // Start with no value
//             characteristic: characteristic, // Store reference to the characteristic
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

//   // Read the value of a characteristic
//   Future<void> _readCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       List<int> value = await charModel.characteristic!.read();
//       setState(() {
//         charModel.value = String.fromCharCodes(value);
//       });
//     } catch (e) {
//       setState(() {
//         charModel.value = 'Read failed: ${e.toString()}';
//       });
//     }
//   }

//   // Write the value to a characteristic
//   Future<void> _writeCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       // Convert the string to bytes
//       List<int> bytes = _writeController.text.codeUnits;

//       await charModel.characteristic!.write(bytes);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
//       setState(() {
//         charModel.value = _writeController.text; // Update the value with the written text
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
//     }
//   }

//   String _convertUuidToHex(Guid uuid) {
//     return '0x${uuid.toString().split('-').last.substring(0, 4)}'; // 0xXXXX
//   }

//   // Fetch properties for characteristics
//   String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
//     List<String> properties = [];
//     if (characteristic.properties.read) properties.add('READ');
//     if (characteristic.properties.write) properties.add('WRITE');
//     if (characteristic.properties.notify) properties.add('NOTIFY');
//     if (characteristic.properties.indicate) properties.add('INDICATE');
//     if (characteristic.properties.writeWithoutResponse)
//       properties.add('WRITE NO RESPONSE');
//     return properties.isEmpty
//         ? "No properties"
//         : properties.join(', ');
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
//         : [];
//   }

//   // Get service title based on UUID (updated to support dynamic titles)
//   String _getServiceTitle(Guid uuid) {
//     Map<String, String> services = {
//       "1800": "Generic Access", // Generic Access
//       "1801": "Generic Attribute", // Generic Attribute
//       "180A": "Device Information", // Device Information
//       "180F": "Battery Service", // Battery Service
//       "2A05": "Service Changed", // Service Changed
//       "2902": "Client Characteristic Configuration", // Client Characteristic Configuration
//       "184C": "ABX"
//       // Add more UUID mappings as required
//     };

//     // Convert UUID to a string without hyphens and in uppercase
//     String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');

//     // If the UUID exists in our predefined map, return the name
//     if (services.containsKey(serviceUuidString)) {
//       return services[serviceUuidString]!; 
//     }

//     // If not found in the map, try to return a more descriptive fallback
//     return "Unknown Service (UUID: $serviceUuidString)";
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     _writeController.dispose();  // Dispose the controller when done
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
//             if (_selectedCharacteristicForWrite != null) _buildWriteCharacteristicView(),
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
//             Row(
//               children: [
//                 if (charModel.properties.contains('READ'))
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (charModel.characteristic != null) {
//                         await _readCharacteristic(charModel);
//                       }
//                     },
//                     child: const Text("Read"),
//                   ),
//                 if (charModel.properties.contains('WRITE'))
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _selectedCharacteristicForWrite = charModel;
//                       });
//                     },
//                     child: const Text("Write"),
//                   ),
//                 if (charModel.properties.contains('INDICATE'))
//                   ElevatedButton(
//                     onPressed: () {
//                       _handleIndicateAction(charModel);
//                     },
//                     child: const Text("Indicate"),
//                   ),
//               ],
//             ),
//             if (charModel.value != null)
//               Text("Value: ${charModel.value}", style: TextStyle(fontSize: 14)),
//             if (charModel.descriptors.isNotEmpty) ...[
//               const Divider(),
//               Text(
//                 "Descriptors:",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: charModel.descriptors.map((descriptor) {
//                   return Card(
//                     elevation: 4.0,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Descriptor UUID: ${descriptor.uuid}",
//                               style: TextStyle(fontSize: 14)),
//                           Text("Properties: ${descriptor.properties}",
//                               style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // Handle INDICATE action and modify descriptor
//   void _handleIndicateAction(BluetoothCharacteristicModel charModel) {
//     if (charModel.descriptors.isNotEmpty) {
//       // Simulate an action like updating the descriptor
//       BluetoothDescriptorModel descriptor = charModel.descriptors.first;
//       setState(() {
//         descriptor.properties = "Updated Descriptor Value"; // Modify descriptor properties
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indicate action triggered!')));
//     }
//   }

//   Widget _buildWriteCharacteristicView() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _writeController,
//               decoration: InputDecoration(
//                 labelText: "Enter value to write",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_selectedCharacteristicForWrite != null) {
//                   await _writeCharacteristic(_selectedCharacteristicForWrite!);
//                 }
//               },
//               child: Text("Send"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Models remain the same...

// // Models for Service, Characteristic, and Descriptor remain the same
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

// class BluetoothCharacteristicModel {
//   String uuid;
//   String properties;
//   List<BluetoothDescriptorModel> descriptors;
//   String? value;
//   BluetoothCharacteristic? characteristic;

//   BluetoothCharacteristicModel({
//     required this.uuid,
//     required this.properties,
//     required this.descriptors,
//     this.value,
//     this.characteristic,
//   });
// }

// class BluetoothDescriptorModel {
//   String uuid;
//   String properties;

//   BluetoothDescriptorModel({
//     required this.uuid,
//     required this.properties,
//   });
// }

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
  TextEditingController _writeController = TextEditingController();
  BluetoothCharacteristicModel? _selectedCharacteristicForWrite;

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
            descriptors: _fetchDescriptors(characteristic), // Fetch descriptors
            value: null, // Start with no value
            characteristic: characteristic, // Store reference to the characteristic
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

  // Read the value of a characteristic
  Future<void> _readCharacteristic(BluetoothCharacteristicModel charModel) async {
    try {
      List<int> value = await charModel.characteristic!.read();
      setState(() {
        charModel.value = String.fromCharCodes(value);
      });
    } catch (e) {
      setState(() {
        charModel.value = 'Read failed: ${e.toString()}';
      });
    }
  }

  // Write the value to a characteristic
  Future<void> _writeCharacteristic(BluetoothCharacteristicModel charModel) async {
    try {
      // Convert the string to bytes
      List<int> bytes = _writeController.text.codeUnits;

      await charModel.characteristic!.write(bytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
      setState(() {
        charModel.value = _writeController.text; // Update the value with the written text
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
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
              characteristic: descriptor, // Store reference to the descriptor
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
      "184C": "ABX"
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
    _writeController.dispose();  // Dispose the controller when done
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
            if (_selectedCharacteristicForWrite != null) _buildWriteCharacteristicView(),
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
            Row(
              children: [
                if (charModel.properties.contains('READ'))
                  ElevatedButton(
                    onPressed: () async {
                      if (charModel.characteristic != null) {
                        await _readCharacteristic(charModel);
                      }
                    },
                    child: const Text("Read"),
                  ),
                if (charModel.properties.contains('WRITE'))
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCharacteristicForWrite = charModel;
                      });
                    },
                    child: const Text("Write"),
                  ),
                if (charModel.properties.contains('INDICATE'))
                  ElevatedButton(
                    onPressed: () {
                      _handleIndicateAction(charModel);
                    },
                    child: const Text("Indicate"),
                  ),
              ],
            ),
            if (charModel.value != null)
              Text("Value: ${charModel.value}", style: TextStyle(fontSize: 14)),
            if (charModel.descriptors.isNotEmpty) ...[
              const Divider(),
              Text(
                "Descriptors:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                children: charModel.descriptors.map((descriptor) {
                  return Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Descriptor UUID: ${descriptor.uuid}",
                              style: TextStyle(fontSize: 14)),
                          Text("Properties: ${descriptor.properties}",
                              style: TextStyle(fontSize: 14)),
                          ElevatedButton(
                            onPressed: () async {
                              await _readDescriptor(descriptor);
                            },
                            child: const Text("Read Descriptor"),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Handle INDICATE action and modify descriptor
  void _handleIndicateAction(BluetoothCharacteristicModel charModel) {
    if (charModel.descriptors.isNotEmpty) {
      // Simulate an action like updating the descriptor
      BluetoothDescriptorModel descriptor = charModel.descriptors.first;
      setState(() {
        descriptor.properties = "Updated Descriptor Value"; // Modify descriptor properties
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indicate action triggered!')));
    }
  }

  // Read the value of a descriptor
  Future<void> _readDescriptor(BluetoothDescriptorModel descriptor) async {
    try {
      List<int> value = await descriptor.characteristic!.read();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Descriptor value: ${String.fromCharCodes(value)}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to read descriptor: ${e.toString()}')));
    }
  }

  Widget _buildWriteCharacteristicView() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _writeController,
              decoration: InputDecoration(
                labelText: "Enter value to write",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_selectedCharacteristicForWrite != null) {
                  await _writeCharacteristic(_selectedCharacteristicForWrite!);
                }
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}

// Models remain the same...

// Models for Service, Characteristic, and Descriptor remain the same
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

class BluetoothCharacteristicModel {
  String uuid;
  String properties;
  List<BluetoothDescriptorModel> descriptors;
  String? value;
  BluetoothCharacteristic? characteristic;

  BluetoothCharacteristicModel({
    required this.uuid,
    required this.properties,
    required this.descriptors,
    this.value,
    this.characteristic,
  });
}

class BluetoothDescriptorModel {
  String uuid;
  String properties;
  BluetoothDescriptor? characteristic;

  BluetoothDescriptorModel({
    required this.uuid,
    required this.properties,
    this.characteristic,
  });
}

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
