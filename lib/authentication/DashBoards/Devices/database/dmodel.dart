class BluetoothDeviceModel {
  final String id;
  final String name;
  final String connectionStatus;

  BluetoothDeviceModel({
    required this.id,
    required this.name,
    required this.connectionStatus,
  });

  // Convert a BluetoothDeviceModel into a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'connectionStatus': connectionStatus,
    };
  }

  // Extract a BluetoothDeviceModel from a map.
  factory BluetoothDeviceModel.fromMap(Map<String, dynamic> map) {
    return BluetoothDeviceModel(
      id: map['id'],
      name: map['name'],
      connectionStatus: map['connectionStatus'],
    );
  }
}
