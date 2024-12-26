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
//       await widget.device.connect();
//       String connectionStatus = "Connected";

//       List<BluetoothService> services = await widget.device.discoverServices();
//       List<BluetoothServiceModel> serviceModels = [];

//       for (var service in services) {
//         List<BluetoothCharacteristicModel> characteristicList = [];
//         for (var characteristic in service.characteristics) {
//           characteristicList.add(BluetoothCharacteristicModel(
//             uuid: _convertUuidToHex(characteristic.uuid),
//             properties: _getCharacteristicProperties(characteristic),
//             descriptors: _fetchDescriptors(characteristic),
//             value: null,
//             characteristic: characteristic,
//           ));
//         }

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
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indication Disabled!')));
//       } else {
//         setState(() {
//           charModel.value = "Indication Enabled";  // Enable indication
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indication Enabled!')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indicate failed: ${e.toString()}')));
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
//         child: ListView(
//           children: [
//             _buildMainCard(),
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
//                     onPressed: () async {
//                       await _handleIndicateAction(charModel);
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

// // Models for Service, Characteristic, and Descriptor remain the same as before

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
//   BluetoothDescriptor? characteristic;
//   String value;

//   BluetoothDescriptorModel({
//     required this.uuid,
//     required this.properties,
//     this.characteristic,
//     required this.value,
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
      await widget.device.connect();
      String connectionStatus = "Connected";

      List<BluetoothService> services = await widget.device.discoverServices();
      List<BluetoothServiceModel> serviceModels = [];

      for (var service in services) {
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

  // Read the value of a descriptor
  Future<void> _readDescriptor(BluetoothDescriptorModel descriptor) async {
    try {
      List<int> value = await descriptor.characteristic!.read();
      setState(() {
        descriptor.value = String.fromCharCodes(value);
      });
    } catch (e) {
      setState(() {
        descriptor.value = 'Read failed: ${e.toString()}';
      });
    }
  }

  // Handle INDICATE action for a characteristic
  Future<void> _handleIndicateAction(BluetoothCharacteristicModel charModel) async {
    try {
      // Toggle between Indication Enabled and Indication Disabled
      if (charModel.value == "Indication Enabled") {
        setState(() {
          charModel.value = "Indication Disabled";  // Disable indication
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indication Disabled!')));
      } else {
        setState(() {
          charModel.value = "Indication Enabled";  // Enable indication
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indication Enabled!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indicate failed: ${e.toString()}')));
    }
  }

  // Handle NOTIFY action for a characteristic
  Future<void> _handleNotifyAction(BluetoothCharacteristicModel charModel) async {
  try {
    if (charModel.characteristic != null) {
      if (charModel.value == "Notify Enabled") {
        await charModel.characteristic!.setNotifyValue(false); // Disable notifications
        setState(() {
          charModel.value = "Notify Disabled";  // Update UI state
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notify Disabled!')));
      } else {
        await charModel.characteristic!.setNotifyValue(true); // Enable notifications
        setState(() {
          charModel.value = "Notify Enabled";  // Update UI state
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notify Enabled!')));
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notify failed: ${e.toString()}')));
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
              value: "Indication Disabled",  // Default state is "Indication Disabled"
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
        child: ListView(
          children: [
            _buildMainCard(),
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
                    onPressed: () async {
                      await _handleIndicateAction(charModel);
                    },
                    child: const Text("Indicate"),
                  ),
                if (charModel.properties.contains('NOTIFY'))
                  ElevatedButton(
                    onPressed: () async {
                      await _handleNotifyAction(charModel);
                    },
                    child: const Text("Notify"),
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
                          if (descriptor.value != null)
                            Text("Value: ${descriptor.value}",
                                style: TextStyle(fontSize: 14)),
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

// Models for Service, Characteristic, and Descriptor remain the same as before

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
  String value;

  BluetoothDescriptorModel({
    required this.uuid,
    required this.properties,
    this.characteristic,
    required this.value,
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
