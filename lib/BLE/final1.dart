// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class DeviceDetailsPage extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

//   @override
//   _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
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
//       await widget.device.connect();
//       String connectionStatus = "Connected";

//       List<BluetoothService> services = await widget.device.discoverServices();
//       List<BluetoothServiceModel> serviceModels = [];

//       // Define the specific UUID you're interested in
//       String targetServiceUuid = "123456781234123412341234567890ab".toUpperCase();

//       for (var service in services) {
//         // Convert service UUID to string format and check if it matches the target UUID
//         String serviceUuidString = service.uuid.toString().toUpperCase().replaceAll('-', '');
//         if (serviceUuidString == targetServiceUuid) {
//           List<BluetoothCharacteristicModel> characteristicList = [];
//           for (var characteristic in service.characteristics) {
//             characteristicList.add(BluetoothCharacteristicModel(
//               uuid: _convertUuidToHex(characteristic.uuid),
//               properties: _getCharacteristicProperties(characteristic),
//               descriptors: _fetchDescriptors(characteristic),
//               value: null,
//               characteristic: characteristic,
//             ));
//           }

//           // Add the matched service to the serviceModels list
//           serviceModels.add(BluetoothServiceModel(
//             title: _getServiceTitle(service.uuid),
//             uuid: _convertUuidToHex(service.uuid),
//             type: "PRIMARY SERVICE",
//             characteristics: characteristicList,
//           ));
//         }
//       }

//       setState(() {
//         _deviceModel = BluetoothDeviceModel(
//           deviceName: widget.device.name.isNotEmpty
//               ? widget.device.name
//               : "Unnamed Device",
//           deviceId: widget.device.id.toString(),
//           connectionStatus: connectionStatus,
//           services: serviceModels,
//           batteryLevel: "Unavailable", // Battery level not available
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
//       List<int> bytes = _writeController.text.codeUnits;
//       await charModel.characteristic!.write(bytes);
//       setState(() {
//         charModel.value = _writeController.text;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
//     }
//   }

//   // Read the value of a descriptor
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

//   // Handle INDICATE action for a characteristic
//   Future<void> _handleIndicateAction(BluetoothCharacteristicModel charModel) async {
//     try {
//       // Toggle between Indication Enabled and Indication Disabled
//       if (charModel.value == "Indication Enabled") {
//         setState(() {
//           charModel.value = "Indication Disabled";  // Disable indication
//           // Update the descriptor values
//           for (var descriptor in charModel.descriptors) {
//             descriptor.value = "Indication Disabled"; // Update descriptor value
//           }
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indication Disabled!')));
//       } else {
//         setState(() {
//           charModel.value = "Indication Enabled";  // Enable indication
//           // Update the descriptor values
//           for (var descriptor in charModel.descriptors) {
//             descriptor.value = "Indication Enabled"; // Update descriptor value
//           }
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indication Enabled!')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indicate failed: ${e.toString()}')));
//     }
//   }

//   // Handle NOTIFY action for a characteristic
//   Future<void> _handleNotifyAction(BluetoothCharacteristicModel charModel) async {
//     try {
//       if (charModel.characteristic != null) {
//         if (charModel.value == "Notify Enabled") {
//           await charModel.characteristic!.setNotifyValue(false); // Disable notifications
//           setState(() {
//             charModel.value = "Notify Disabled";  // Update UI state
//             // Update the descriptor values
//             for (var descriptor in charModel.descriptors) {
//               descriptor.value = "Notify Disabled"; // Update descriptor value
//             }
//           });
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notify Disabled!')));
//         } else {
//           await charModel.characteristic!.setNotifyValue(true); // Enable notifications
//           setState(() {
//             charModel.value = "Notify Enabled";  // Update UI state
//             // Update the descriptor values
//             for (var descriptor in charModel.descriptors) {
//               descriptor.value = "Notify Enabled"; // Update descriptor value
//             }
//           });
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notify Enabled!')));
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notify failed: ${e.toString()}')));
//     }
//   }

//   String _convertUuidToHex(Guid uuid) {
//     return '0x${uuid.toString().split('-').last.substring(0, 4)}';
//   }

//   String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
//     List<String> properties = [];
//     if (characteristic.properties.read) properties.add('READ');
//     if (characteristic.properties.write) properties.add('WRITE');
//     if (characteristic.properties.notify) properties.add('NOTIFY');
//     if (characteristic.properties.indicate) properties.add('INDICATE');
//     if (characteristic.properties.writeWithoutResponse) properties.add('WRITE NO RESPONSE');
//     return properties.isEmpty ? "No properties" : properties.join(', ');
//   }

//   List<BluetoothDescriptorModel> _fetchDescriptors(BluetoothCharacteristic characteristic) {
//     return characteristic.descriptors.isNotEmpty
//         ? characteristic.descriptors.map((descriptor) {
//             return BluetoothDescriptorModel(
//               uuid: _convertUuidToHex(descriptor.uuid),
//               properties: "Client Characteristic Configuration",
//               characteristic: descriptor,
//               value: "Indication Disabled",  // Default state is "Indication Disabled"
//             );
//           }).toList()
//         : [];
//   }

//   String _getServiceTitle(Guid uuid) {
//     Map<String, String> services = {
//       "1800": "Generic Access",
//       "1801": "Generic Attribute",
//       "180A": "Device Information",
//       "180F": "Battery Service",
//       "2A05": "Service Changed",
//       "2A00": "Device Name",
//       "2902": "Client Characteristic Configuration",
//     };

//     String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');
//     if (services.containsKey(serviceUuidString)) {
//       return services[serviceUuidString]!; 
//     }

//     return "Unknown Service (UUID: $serviceUuidString)";
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     _writeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_deviceModel?.deviceName ?? "Unnamed Device"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _deviceModel == null
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   _buildDeviceInfo(),
//                   _buildServicesList(),
//                   if (_selectedCharacteristicForWrite != null)
//                     _buildWriteCharacteristicView(),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildDeviceInfo() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Device ID: ${_deviceModel?.deviceId ?? "N/A"}'),
//             Text('Connection Status: ${_deviceModel?.connectionStatus ?? "N/A"}'),
//             Text('Battery Level: ${_deviceModel?.batteryLevel ?? "N/A"}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServicesList() {
//     if (_deviceModel?.services == null || _deviceModel?.services?.isEmpty == true) {
//       return const Center(child: Text("No services found"));
//     }
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: _deviceModel?.services?.length,
//       itemBuilder: (context, index) {
//         final service = _deviceModel!.services![index];
//         return Card(
//           elevation: 4.0,
//           margin: const EdgeInsets.only(bottom: 16.0),
//           child: ListTile(
//             title: Text(service.title),
//             subtitle: Text('UUID: ${service.uuid}'),
//             onTap: () {
//               _showCharacteristics(service);
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showCharacteristics(BluetoothServiceModel service) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return ListView.builder(
//           itemCount: service.characteristics.length,
//           itemBuilder: (context, index) {
//             final characteristic = service.characteristics[index];
//             return ListTile(
//               title: Text(characteristic.uuid),
//               subtitle: Text("Properties: ${characteristic.properties}"),
//               onTap: () {
//                 _selectCharacteristicForWrite(characteristic);
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   // This method is what was missing from your code
//   void _selectCharacteristicForWrite(BluetoothCharacteristicModel characteristic) {
//     setState(() {
//       _selectedCharacteristicForWrite = characteristic;
//     });
//   }

//   Widget _buildWriteCharacteristicView() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Write to: ${_selectedCharacteristicForWrite?.uuid ?? "N/A"}"),
//             TextField(
//               controller: _writeController,
//               decoration: const InputDecoration(labelText: "Enter data to write"),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () {
//                 if (_selectedCharacteristicForWrite != null) {
//                   _writeCharacteristic(_selectedCharacteristicForWrite!);
//                 }
//               },
//               child: const Text("Write Data"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BluetoothDeviceModel {
//   final String deviceName;
//   final String deviceId;
//   final String connectionStatus;
//   final String batteryLevel;
//   final List<BluetoothServiceModel> services;

//   BluetoothDeviceModel({
//     required this.deviceName,
//     required this.deviceId,
//     required this.connectionStatus,
//     required this.services,
//     required this.batteryLevel,
//   });
// }

// class BluetoothServiceModel {
//   final String title;
//   final String uuid;
//   final String type;
//   final List<BluetoothCharacteristicModel> characteristics;

//   BluetoothServiceModel({
//     required this.title,
//     required this.uuid,
//     required this.type,
//     required this.characteristics,
//   });
// }

// class BluetoothCharacteristicModel {
//   final String uuid;
//   final String properties;
//   final List<BluetoothDescriptorModel> descriptors;
//   final BluetoothCharacteristic? characteristic;
//   String? value;

//   BluetoothCharacteristicModel({
//     required this.uuid,
//     required this.properties,
//     required this.descriptors,
//     required this.characteristic,
//     this.value,
//   });
// }

// class BluetoothDescriptorModel {
//   final String uuid;
//   final String properties;
//   final BluetoothDescriptor characteristic;
//   String? value;

//   BluetoothDescriptorModel({
//     required this.uuid,
//     required this.properties,
//     required this.characteristic,
//     this.value,
//   });
// }


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class DeviceDetailsPage extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

//   @override
//   _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
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
//       await widget.device.connect();
//       String connectionStatus = "Connected";

//       List<BluetoothService> services = await widget.device.discoverServices();
//       List<BluetoothServiceModel> serviceModels = [];

//       String targetServiceUuid = "123456781234123412341234567890ab".toUpperCase();

//       for (var service in services) {
//         String serviceUuidString = service.uuid.toString().toUpperCase().replaceAll('-', '');
//         if (serviceUuidString == targetServiceUuid) {
//           List<BluetoothCharacteristicModel> characteristicList = [];
//           for (var characteristic in service.characteristics) {
//             characteristicList.add(BluetoothCharacteristicModel(
//               uuid: _convertUuidToHex(characteristic.uuid),
//               properties: _getCharacteristicProperties(characteristic),
//               descriptors: _fetchDescriptors(characteristic),
//               value: null,
//               characteristic: characteristic,
//             ));
//           }

//           serviceModels.add(BluetoothServiceModel(
//             title: _getServiceTitle(service.uuid),
//             uuid: _convertUuidToHex(service.uuid),
//             type: "PRIMARY SERVICE",
//             characteristics: characteristicList,
//           ));
//         }
//       }

//       setState(() {
//         _deviceModel = BluetoothDeviceModel(
//           deviceName: widget.device.name.isNotEmpty
//               ? widget.device.name
//               : "Unnamed Device",
//           deviceId: widget.device.id.toString(),
//           connectionStatus: connectionStatus,
//           services: serviceModels,
//           batteryLevel: "Unavailable",
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
//     }
//   }

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

//   Future<void> _writeCharacteristic(BluetoothCharacteristicModel charModel) async {
//     try {
//       List<int> bytes = _writeController.text.codeUnits;
//       await charModel.characteristic!.write(bytes);
//       setState(() {
//         charModel.value = _writeController.text;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
//     }
//   }

//   String _convertUuidToHex(Guid uuid) {
//     return '0x${uuid.toString().split('-').last.substring(0, 4)}';
//   }

//   String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
//     List<String> properties = [];
//     if (characteristic.properties.read) properties.add('READ');
//     if (characteristic.properties.write) properties.add('WRITE');
//     if (characteristic.properties.notify) properties.add('NOTIFY');
//     if (characteristic.properties.indicate) properties.add('INDICATE');
//     if (characteristic.properties.writeWithoutResponse) properties.add('WRITE NO RESPONSE');
//     return properties.isEmpty ? "No properties" : properties.join(', ');
//   }

//   List<BluetoothDescriptorModel> _fetchDescriptors(BluetoothCharacteristic characteristic) {
//     return characteristic.descriptors.isNotEmpty
//         ? characteristic.descriptors.map((descriptor) {
//             return BluetoothDescriptorModel(
//               uuid: _convertUuidToHex(descriptor.uuid),
//               properties: "Client Characteristic Configuration",
//               characteristic: descriptor,
//               value: "Indication Disabled",
//             );
//           }).toList()
//         : [];
//   }

//   String _getServiceTitle(Guid uuid) {
//     Map<String, String> services = {
//       "1800": "Generic Access",
//       "1801": "Generic Attribute",
//       "180A": "Device Information",
//       "180F": "Battery Service",
//       "2A05": "Service Changed",
//       "2A00": "Device Name",
//       "2902": "Client Characteristic Configuration",
//     };

//     String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');
//     if (services.containsKey(serviceUuidString)) {
//       return services[serviceUuidString]!; 
//     }

//     return "Unknown Service (UUID: $serviceUuidString)";
//   }

//   @override
//   void dispose() {
//     widget.device.disconnect();
//     _writeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_deviceModel?.deviceName ?? "Unnamed Device"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _deviceModel == null
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   _buildDeviceInfo(),
//                   _buildServicesList(),
//                   if (_selectedCharacteristicForWrite != null)
//                     _buildWriteCharacteristicView(),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildDeviceInfo() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Device ID: ${_deviceModel?.deviceId ?? "N/A"}'),
//             Text('Connection Status: ${_deviceModel?.connectionStatus ?? "N/A"}'),
//             Text('Battery Level: ${_deviceModel?.batteryLevel ?? "N/A"}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServicesList() {
//     if (_deviceModel?.services == null || _deviceModel?.services?.isEmpty == true) {
//       return const Center(child: Text("No services found"));
//     }
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: _deviceModel?.services?.length,
//       itemBuilder: (context, index) {
//         final service = _deviceModel!.services![index];
//         return Card(
//           elevation: 4.0,
//           margin: const EdgeInsets.only(bottom: 16.0),
//           child: ListTile(
//             title: Text(service.title),
//             subtitle: Text('UUID: ${service.uuid}'),
//             onTap: () {
//               _showCharacteristics(service);
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showCharacteristics(BluetoothServiceModel service) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return ListView.builder(
//           itemCount: service.characteristics.length,
//           itemBuilder: (context, index) {
//             final characteristic = service.characteristics[index];
//             return ListTile(
//               title: Text(characteristic.uuid),
//               subtitle: Text("Properties: ${characteristic.properties}"),
//               onTap: () {
//                 _selectCharacteristicForWrite(characteristic);
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   void _selectCharacteristicForWrite(BluetoothCharacteristicModel characteristic) {
//     setState(() {
//       _selectedCharacteristicForWrite = characteristic;
//     });
//   }

//   Widget _buildWriteCharacteristicView() {
//     return Card(
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Write to: ${_selectedCharacteristicForWrite?.uuid ?? "N/A"}"),
//             TextField(
//               controller: _writeController,
//               decoration: const InputDecoration(labelText: "Enter data to write"),
//             ),
//             const SizedBox(height: 8),
//             if (_selectedCharacteristicForWrite?.properties.contains("READ") ?? false)
//               ElevatedButton(
//                 onPressed: () {
//                   if (_selectedCharacteristicForWrite != null) {
//                     _readCharacteristic(_selectedCharacteristicForWrite!);
//                   }
//                 },
//                 child: const Text("Read Data"),
//               ),
//             const SizedBox(height: 8),
//             if (_selectedCharacteristicForWrite?.properties.contains("WRITE") ?? false)
//               ElevatedButton(
//                 onPressed: () {
//                   if (_selectedCharacteristicForWrite != null) {
//                     _writeCharacteristic(_selectedCharacteristicForWrite!);
//                   }
//                 },
//                 child: const Text("Write Data"),
//               ),
//             if (_selectedCharacteristicForWrite?.value != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text("Current Value: ${_selectedCharacteristicForWrite?.value ?? 'N/A'}"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BluetoothDeviceModel {
//   final String deviceName;
//   final String deviceId;
//   final String connectionStatus;
//   final String batteryLevel;
//   final List<BluetoothServiceModel> services;

//   BluetoothDeviceModel({
//     required this.deviceName,
//     required this.deviceId,
//     required this.connectionStatus,
//     required this.services,
//     required this.batteryLevel,
//   });
// }

// class BluetoothServiceModel {
//   final String title;
//   final String uuid;
//   final String type;
//   final List<BluetoothCharacteristicModel> characteristics;

//   BluetoothServiceModel({
//     required this.title,
//     required this.uuid,
//     required this.type,
//     required this.characteristics,
//   });
// }

// class BluetoothCharacteristicModel {
//   final String uuid;
//   final String properties;
//   final List<BluetoothDescriptorModel> descriptors;
//   final BluetoothCharacteristic? characteristic;
//   String? value;

//   BluetoothCharacteristicModel({
//     required this.uuid,
//     required this.properties,
//     required this.descriptors,
//     required this.characteristic,
//     this.value,
//   });
// }

// class BluetoothDescriptorModel {
//   final String uuid;
//   final String properties;
//   final BluetoothDescriptor characteristic;
//   String? value;

//   BluetoothDescriptorModel({
//     required this.uuid,
//     required this.properties,
//     required this.characteristic,
//     this.value,
//   });
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDetailsPage extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceDetailsPage({Key? key, required this.device}) : super(key: key);

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
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
      await widget.device.connect();
      String connectionStatus = "Connected";

      List<BluetoothService> services = await widget.device.discoverServices();
      List<BluetoothServiceModel> serviceModels = [];

      String targetServiceUuid = "123456781234123412341234567890ab".toUpperCase();

      for (var service in services) {
        String serviceUuidString = service.uuid.toString().toUpperCase().replaceAll('-', '');
        if (serviceUuidString == targetServiceUuid) {
          List<BluetoothCharacteristicModel> characteristicList = [];
          for (var characteristic in service.characteristics) {
            characteristicList.add(BluetoothCharacteristicModel(
              uuid: _convertUuidToHex(characteristic.uuid),
              properties: _getCharacteristicProperties(characteristic),
              descriptors: _fetchDescriptors(characteristic),
              value: null,
              characteristic: characteristic,
            ));
          }

          serviceModels.add(BluetoothServiceModel(
            title: _getServiceTitle(service.uuid),
            uuid: _convertUuidToHex(service.uuid),
            type: "PRIMARY SERVICE",
            characteristics: characteristicList,
          ));
        }
      }

      setState(() {
        _deviceModel = BluetoothDeviceModel(
          deviceName: widget.device.name.isNotEmpty
              ? widget.device.name
              : "Unnamed Device",
          deviceId: widget.device.id.toString(),
          connectionStatus: connectionStatus,
          services: serviceModels,
          batteryLevel: "Unavailable",
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
    }
  }

  Future<void> _readCharacteristic(BluetoothCharacteristicModel charModel) async {
    try {
      // Initial read
      List<int> value = await charModel.characteristic!.read();
      setState(() {
        charModel.value = String.fromCharCodes(value);
      });

      // Start notifications if the characteristic supports them
      if (charModel.characteristic!.properties.notify) {
        await charModel.characteristic!.setNotifyValue(true);
        charModel.characteristic!.value.listen((value) {
          setState(() {
            charModel.value = String.fromCharCodes(value);
          });
        });
      }

    } catch (e) {
      setState(() {
        charModel.value = 'Read failed: ${e.toString()}';
      });
    }
  }

  Future<void> _writeCharacteristic(BluetoothCharacteristicModel charModel) async {
    try {
      List<int> bytes = _writeController.text.codeUnits;
      await charModel.characteristic!.write(bytes);
      setState(() {
        charModel.value = _writeController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write successful!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Write failed: ${e.toString()}')));
    }
  }

  String _convertUuidToHex(Guid uuid) {
    return '0x${uuid.toString().split('-').last.substring(0, 4)}';
  }

  String _getCharacteristicProperties(BluetoothCharacteristic characteristic) {
    List<String> properties = [];
    if (characteristic.properties.read) properties.add('READ');
    if (characteristic.properties.write) properties.add('WRITE');
    if (characteristic.properties.notify) properties.add('NOTIFY');
    if (characteristic.properties.indicate) properties.add('INDICATE');
    if (characteristic.properties.writeWithoutResponse) properties.add('WRITE NO RESPONSE');
    return properties.isEmpty ? "No properties" : properties.join(', ');
  }

  List<BluetoothDescriptorModel> _fetchDescriptors(BluetoothCharacteristic characteristic) {
    return characteristic.descriptors.isNotEmpty
        ? characteristic.descriptors.map((descriptor) {
            return BluetoothDescriptorModel(
              uuid: _convertUuidToHex(descriptor.uuid),
              properties: "Client Characteristic Configuration",
              characteristic: descriptor,
              value: "Indication Disabled",
            );
          }).toList()
        : [];
  }

  String _getServiceTitle(Guid uuid) {
    Map<String, String> services = {
      "1800": "Generic Access",
      "1801": "Generic Attribute",
      "180A": "Device Information",
      "180F": "Battery Service",
      "2A05": "Service Changed",
      "2A00": "Device Name",
      "2902": "Client Characteristic Configuration",
    };

    String serviceUuidString = uuid.toString().toUpperCase().replaceAll('-', '');
    if (services.containsKey(serviceUuidString)) {
      return services[serviceUuidString]!; 
    }

    return "Unknown Service (UUID: $serviceUuidString)";
  }

  @override
  void dispose() {
    widget.device.disconnect();
    _writeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_deviceModel?.deviceName ?? "Unnamed Device"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _deviceModel == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _buildDeviceInfo(),
                  const SizedBox(height: 16),
                  _buildServicesList(),
                  const SizedBox(height: 16),
                  if (_selectedCharacteristicForWrite != null) _buildWriteCharacteristicView(),
                ],
              ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device ID: ${_deviceModel?.deviceId ?? "N/A"}'),
            Text('Connection Status: ${_deviceModel?.connectionStatus ?? "N/A"}'),
            Text('Battery Level: ${_deviceModel?.batteryLevel ?? "N/A"}'),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    if (_deviceModel?.services == null || _deviceModel?.services?.isEmpty == true) {
      return const Center(child: Text("No services found"));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _deviceModel?.services?.length,
      itemBuilder: (context, index) {
        final service = _deviceModel!.services![index];
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(service.title),
            subtitle: Text('UUID: ${service.uuid}'),
            onTap: () {
              _showCharacteristics(service);
            },
          ),
        );
      },
    );
  }

  void _showCharacteristics(BluetoothServiceModel service) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: service.characteristics.length,
          itemBuilder: (context, index) {
            final characteristic = service.characteristics[index];
            return ListTile(
              title: Text(characteristic.uuid),
              subtitle: Text("Properties: ${characteristic.properties}"),
              onTap: () {
                _selectCharacteristicForWrite(characteristic);
              },
            );
          },
        );
      },
    );
  }

  void _selectCharacteristicForWrite(BluetoothCharacteristicModel characteristic) {
    setState(() {
      _selectedCharacteristicForWrite = characteristic;
    });
  }

  Widget _buildWriteCharacteristicView() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Write to: ${_selectedCharacteristicForWrite?.uuid ?? "N/A"}"),
            TextField(
              controller: _writeController,
              decoration: const InputDecoration(labelText: "Enter data to write"),
            ),
            const SizedBox(height: 8),
            if (_selectedCharacteristicForWrite?.properties.contains("READ") ?? false)
              ElevatedButton(
                onPressed: (_selectedCharacteristicForWrite?.value == null)
                    ? () {
                        if (_selectedCharacteristicForWrite != null) {
                          _readCharacteristic(_selectedCharacteristicForWrite!);
                        }
                      }
                    : null,
                child: Text(
                    (_selectedCharacteristicForWrite?.value == null) ? "Read Data" : "Data Read"),
              ),
            const SizedBox(height: 8),
            if (_selectedCharacteristicForWrite?.properties.contains("WRITE") ?? false)
              ElevatedButton(
                onPressed: () {
                  if (_selectedCharacteristicForWrite != null) {
                    _writeCharacteristic(_selectedCharacteristicForWrite!);
                  }
                },
                child: const Text("Write Data"),
              ),
            if (_selectedCharacteristicForWrite?.value != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildCharacteristicStream(_selectedCharacteristicForWrite!),
              ),
          ],
        ),
      ),
    );
  }

  // StreamBuilder for real-time data updates
  StreamBuilder<List<int>> _buildCharacteristicStream(BluetoothCharacteristicModel charModel) {
    return StreamBuilder<List<int>>(
      stream: charModel.characteristic!.value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          charModel.value = String.fromCharCodes(snapshot.data!);
          return Text("Current Value: ${charModel.value}");
        } else {
          return const Text("No Data");
        }
      },
    );
  }
}

// Data models for Bluetooth device, service, characteristic, and descriptor
class BluetoothDeviceModel {
  final String deviceName;
  final String deviceId;
  final String connectionStatus;
  final String batteryLevel;
  final List<BluetoothServiceModel> services;

  BluetoothDeviceModel({
    required this.deviceName,
    required this.deviceId,
    required this.connectionStatus,
    required this.services,
    required this.batteryLevel,
  });
}

class BluetoothServiceModel {
  final String title;
  final String uuid;
  final String type;
  final List<BluetoothCharacteristicModel> characteristics;

  BluetoothServiceModel({
    required this.title,
    required this.uuid,
    required this.type,
    required this.characteristics,
  });
}

class BluetoothCharacteristicModel {
  final String uuid;
  final String properties;
  final List<BluetoothDescriptorModel> descriptors;
  final BluetoothCharacteristic? characteristic;
  String? value;

  BluetoothCharacteristicModel({
    required this.uuid,
    required this.properties,
    required this.descriptors,
    required this.characteristic,
    this.value,
  });
}

class BluetoothDescriptorModel {
  final String uuid;
  final String properties;
  final BluetoothDescriptor characteristic;
  String? value;

  BluetoothDescriptorModel({
    required this.uuid,
    required this.properties,
    required this.characteristic,
    this.value,
  });
}


