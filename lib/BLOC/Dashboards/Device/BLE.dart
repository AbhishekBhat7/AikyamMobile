// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:aikyamm/authentication/DashBoards/Devices/database/db_helper.dart';
// import 'package:aikyamm/authentication/Libraries/Colors.dart';
// import 'package:aikyamm/authentication/DashBoards/Devices/ex1.dart';

// // BLoC event definitions
// abstract class BluetoothEvent {}

// class StartScanEvent extends BluetoothEvent {}

// class ConnectToDeviceEvent extends BluetoothEvent {
//   final ScanResult result;

//   ConnectToDeviceEvent(this.result);
// }

// class RefreshDevicesEvent extends BluetoothEvent {}

// // BLoC state definitions
// abstract class BluetoothState {}

// class BluetoothInitialState extends BluetoothState {}

// class BluetoothScanningState extends BluetoothState {}

// class BluetoothScanResultsState extends BluetoothState {
//   final List<ScanResult> devices;
//   BluetoothScanResultsState(this.devices);
// }

// class BluetoothConnectedState extends BluetoothState {
//   final String deviceId;
//   BluetoothConnectedState(this.deviceId);
// }

// class BluetoothConnectionFailedState extends BluetoothState {
//   final String errorMessage;
//   BluetoothConnectionFailedState(this.errorMessage);
// }

// class BluetoothPermissionDeniedState extends BluetoothState {}

// class BluetoothPageBloc extends Bloc<BluetoothEvent, BluetoothState> {
//   BluetoothPageBloc() : super(BluetoothInitialState());

//   @override
//   Stream<BluetoothState> mapEventToState(BluetoothEvent event) async* {
//     if (event is StartScanEvent) {
//       yield BluetoothScanningState();
//       final hasPermission = await _checkPermissions();
//       if (!hasPermission) {
//         yield BluetoothPermissionDeniedState();
//         return;
//       }

//       final isBluetoothOn = await _isBluetoothOn();
//       if (!isBluetoothOn) {
//         yield BluetoothPermissionDeniedState();
//         return;
//       }

//       // Start scanning for Bluetooth devices
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
//       final devices = <ScanResult>[];
//       final scanSubscription = FlutterBluePlus.scanResults.listen((results) {
//         for (ScanResult result in results) {
//           if (devices.every((d) => d.device.id != result.device.id)) {
//             devices.add(result);
//           }
//         }
//       });

//       // After scanning, stop and emit devices list
//       await Future.delayed(const Duration(seconds: 5));
//       FlutterBluePlus.stopScan();
//       yield BluetoothScanResultsState(devices);
//       await scanSubscription.cancel();
//     } else if (event is ConnectToDeviceEvent) {
//       yield BluetoothScanningState();
//       try {
//         await event.result.device.connect();
//         // Save the device in the database
//         Device device = Device(id: event.result.device.id.toString(), name: event.result.device.name);
//         await DatabaseHelper.instance.insertDevice(device);
//         yield BluetoothConnectedState(event.result.device.id.toString());
//       } catch (e) {
//         yield BluetoothConnectionFailedState("Failed to connect to ${event.result.device.name}");
//       }
//     } else if (event is RefreshDevicesEvent) {
//       final savedDevices = await DatabaseHelper.instance.getDevices();
//       final devices = savedDevices
//           .map((device) {
//             return ScanResult(
//               device: BluetoothDevice(remoteId: DeviceIdentifier(device.id)),
//               advertisementData: AdvertisementData(
//                 advName: device.name,
//                 connectable: true,
//                 manufacturerData: {},
//                 serviceData: {},
//                 serviceUuids: [], txPowerLevel: null, appearance: null,
//               ),
//               rssi: -1,
//               timeStamp: DateTime.now(),
//             );
//           })
//           .toList();
//       yield BluetoothScanResultsState(devices);
//     }
//   }

//   Future<bool> _checkPermissions() async {
//     var locationPermissionStatus = await Permission.location.request();
//     var bluetoothScanPermissionStatus = await Permission.bluetoothScan.request();
//     var bluetoothConnectPermissionStatus = await Permission.bluetoothConnect.request();

//     if (locationPermissionStatus.isDenied ||
//         bluetoothScanPermissionStatus.isDenied ||
//         bluetoothConnectPermissionStatus.isDenied) {
//       return false;
//     }
//     return true;
//   }

//   Future<bool> _isBluetoothOn() async {
//     final bluetoothState = await FlutterBluePlus.adapterState.first;
//     return bluetoothState == BluetoothAdapterState.on;
//   }
// }

// // The BluetoothPage widget
// class BluetoothPage extends StatelessWidget {
//   const BluetoothPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => BluetoothPageBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: MainColors.primaryColor,
//           title: const Text(
//             "Devices BLE Connections",
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 20,
//               color: MainColors.white,
//               letterSpacing: 0.5,
//             ),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           elevation: 5,
//         ),
//         body: SafeArea(
//           child: BlocListener<BluetoothPageBloc, BluetoothState>(
//             listener: (context, state) {
//               if (state is BluetoothPermissionDeniedState) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Permissions are required.")),
//                 );
//               }
//               if (state is BluetoothConnectionFailedState) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.errorMessage)),
//                 );
//               }
//               if (state is BluetoothConnectedState) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Connected to ${state.deviceId}")),
//                 );
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () => context.read<BluetoothPageBloc>().add(StartScanEvent()),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color.fromRGBO(143, 0, 0, 1),
//                             Color.fromRGBO(220, 20, 60, 1),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             offset: const Offset(0, 4),
//                             blurRadius: 8,
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.add_circle_outline,
//                               color: MainColors.white, size: 22),
//                           SizedBox(width: 10),
//                           Text(
//                             "Connect New Device",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: MainColors.white,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   const Text(
//                     "Saved Devices",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: BlocBuilder<BluetoothPageBloc, BluetoothState>(
//                       builder: (context, state) {
//                         if (state is BluetoothScanningState) {
//                           return const Center(child: CircularProgressIndicator());
//                         }

//                         if (state is BluetoothScanResultsState) {
//                           final devices = state.devices;

//                           return ListView.builder(
//                             itemCount: devices.length,
//                             itemBuilder: (context, index) {
//                               final result = devices[index];
//                               return ListTile(
//                                 title: Text(result.device.name),
//                                 subtitle: Text(result.device.id.toString()),
//                                 trailing: ElevatedButton(
//                                   onPressed: () {
//                                     context.read<BluetoothPageBloc>().add(ConnectToDeviceEvent(result));
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     foregroundColor: MainColors.white,
//                                     backgroundColor: MainColors.primaryColor,
//                                   ),
//                                   child: const Text("Connect"),
//                                 ),
//                               );
//                             },
//                           );
//                         }

//                         return const Center(child: Text("No devices found."));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/database/db_helper.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/ex1.dart';

// Define events
abstract class BluetoothEvent {}

class StartScanEvent extends BluetoothEvent {}

class StopScanEvent extends BluetoothEvent {}

class ConnectDeviceEvent extends BluetoothEvent {
  final ScanResult device;

  ConnectDeviceEvent(this.device);
}

class RefreshDevicesEvent extends BluetoothEvent {}

// Define states
abstract class BluetoothState {}

class BluetoothInitialState extends BluetoothState {}

class BluetoothScanningState extends BluetoothState {}

class BluetoothScanResultsState extends BluetoothState {
  final List<ScanResult> devices;
  final Map<String, String> connectionStatus;

  BluetoothScanResultsState({required this.devices, required this.connectionStatus});
}

class BluetoothConnectedState extends BluetoothState {
  final ScanResult device;

  BluetoothConnectedState(this.device);
}

class BluetoothConnectionFailedState extends BluetoothState {
  final String message;

  BluetoothConnectionFailedState(this.message);
}

// Define the BLoC
class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final List<ScanResult> _devices = [];
  final Map<String, String> _connectionStatus = {};
  StreamSubscription? _scanSubscription;
  bool _isScanning = false;

  BluetoothBloc() : super(BluetoothInitialState());

  @override
  Stream<BluetoothState> mapEventToState(BluetoothEvent event) async* {
    if (event is StartScanEvent) {
      yield* _mapStartScanEventToState();
    } else if (event is StopScanEvent) {
      yield* _mapStopScanEventToState();
    } else if (event is ConnectDeviceEvent) {
      yield* _mapConnectDeviceEventToState(event.device);
    } else if (event is RefreshDevicesEvent) {
      yield* _mapRefreshDevicesEventToState();
    }
  }

  Stream<BluetoothState> _mapStartScanEventToState() async* {
    bool hasPermission = await _checkPermissions();
    if (!hasPermission) {
      return;
    }

    bool isBluetoothEnabled = await _isBluetoothOn();
    if (!isBluetoothEnabled) {
      return;
    }

    _devices.clear();
    yield BluetoothScanningState();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (_devices.every((d) => d.device.id != result.device.id)) {
          _devices.add(result);
          _connectionStatus[result.device.id.toString()] = 'Connect';
        }
      }
      add(RefreshDevicesEvent());
    });

    // After 5 seconds, stop the scan
    Timer(const Duration(seconds: 5), () => add(StopScanEvent()));
  }

  Stream<BluetoothState> _mapStopScanEventToState() async* {
    FlutterBluePlus.stopScan();
    yield BluetoothScanResultsState(devices: _devices, connectionStatus: _connectionStatus);
  }

  Stream<BluetoothState> _mapConnectDeviceEventToState(ScanResult result) async* {
    _connectionStatus[result.device.id.toString()] = 'Connecting...';
    yield BluetoothScanResultsState(devices: _devices, connectionStatus: _connectionStatus);

    try {
      await result.device.connect();
      _connectionStatus[result.device.id.toString()] = 'Connected';

      Device device = Device(id: result.device.id.toString(), name: result.device.name);
      await DatabaseHelper.instance.insertDevice(device);

      yield BluetoothConnectedState(result);
      
    
    } catch (e) {
      _connectionStatus[result.device.id.toString()] = 'Connection Failed';
      yield BluetoothConnectionFailedState("Failed to connect to ${result.device.name}");
    }
  }

  Stream<BluetoothState> _mapRefreshDevicesEventToState() async* {
    final devices = await DatabaseHelper.instance.getDevices();
    _devices.clear();
    for (var device in devices) {
      final bluetoothDevice = BluetoothDevice(remoteId: DeviceIdentifier(device.id));

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

    yield BluetoothScanResultsState(devices: _devices, connectionStatus: _connectionStatus);
  }

  Future<bool> _checkPermissions() async {
    var locationPermissionStatus = await Permission.location.request();
    var bluetoothScanPermissionStatus = await Permission.bluetoothScan.request();
    var bluetoothConnectPermissionStatus = await Permission.bluetoothConnect.request();

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
}
