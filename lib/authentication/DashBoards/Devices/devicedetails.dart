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

  // Variables to manage the list of values and the "Show More" functionality
  List<String> _characteristicValues = [];
  int _maxVisibleValues = 10;
  bool _showAllValues = false;

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
      String valueStr = String.fromCharCodes(value);

      setState(() {
        _characteristicValues.insert(0, valueStr); // Add new value to the beginning
        charModel.value = valueStr; // Set the latest value
      });

      // Start notifications if the characteristic supports them
      if (charModel.characteristic!.properties.notify) {
        await charModel.characteristic!.setNotifyValue(true);
        charModel.characteristic!.value.listen((value) {
          String newValue = String.fromCharCodes(value);
          setState(() {
            _characteristicValues.insert(0, newValue); // Add new value to the beginning
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
Widget _buildCharacteristicStream(BluetoothCharacteristicModel charModel) {
  return Column(
    children: [
      // Show the values
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _showAllValues ? _characteristicValues.length : _maxVisibleValues,
        itemBuilder: (context, index) {
          if (index < _characteristicValues.length) {
            return ListTile(
              title: Text("Value ${index + 1}: ${_characteristicValues[index]}"),
            );
          } else {
            return Container(); // Return an empty container if index is out of bounds
          }
        },
      ),
      // Add a "Show More" button if not showing all values
      if (!_showAllValues && _characteristicValues.length > _maxVisibleValues)
        TextButton(
          onPressed: () {
            setState(() {
              _showAllValues = true; // Show all the stored values
            });
          },
          child: Text("Show More"),
        ),
      // Add a "Show Less" button to revert the view to the latest 10 values
      if (_showAllValues)
        TextButton(
          onPressed: () {
            setState(() {
              _showAllValues = false; // Revert to showing only the latest 10 values
            });
          },
          child: Text("Show Less"),
        ),
    ],
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
