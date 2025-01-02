import 'dart:async';
import 'package:aikyamm/authentication/DashBoards/Devices/devicedetails.dart';
import 'package:aikyamm/authentication/DashBoards/Devices/ex2.dart';
import 'package:aikyamm/authentication/Libraries/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

//--------- Event -----------
class DeviceEvent {}

class DeviceLoadedEvent extends DeviceEvent {
  final dynamic device;

  DeviceLoadedEvent(this.device);
}

//--------- State -----------
class DeviceState {}

class DeviceInitialState extends DeviceState {}

class DeviceLoadedState extends DeviceState {
  final dynamic device;

  DeviceLoadedState(this.device);
}

class DeviceErrorState extends DeviceState {
  final String errorMessage;

  DeviceErrorState(this.errorMessage);
}


//--------- Bloc -----------
class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitialState());

  @override
  Stream<DeviceState> mapEventToState(DeviceEvent event) async* {
    if (event is DeviceLoadedEvent) {
      try {
        // Simulating a loading delay (e.g., from a database or API)
        await Future.delayed(Duration(seconds: 2));
        yield DeviceLoadedState(event.device);
      } catch (e) {
        yield DeviceErrorState("Failed to load device data.");
      }
    }
  }
}

//--------- UI -----------

class DeviceConfigurationsPage extends StatelessWidget {
  final dynamic device; // The 'device' that was passed from the previous screen

  const DeviceConfigurationsPage({Key? key, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceBloc()..add(DeviceLoadedEvent(device)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: MainColors.white),
            onPressed: () {
              Navigator.pop(context); // Should correctly pop the current route
              print("We Back to the page");
            },
          ),
          title: Text("Device Configurations",
              style: TextStyle(color: MainColors.white)),
          actions: [Icon(Icons.more_vert, color: MainColors.white)],
          elevation: 4,
          backgroundColor: MainColors.primaryColor,
        ),
        body: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            if (state is DeviceInitialState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DeviceErrorState) {
              return Center(child: Text(state.errorMessage));
            } else if (state is DeviceLoadedState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Here, you can use the 'device' data to display relevant information
                    Text(
                        'Device Data: ${state.device.toString()}'), // Displaying the device info as a string

                    ConfigurationCard(
                      title: "Create New Configuration",
                      icon: Icons.add_circle_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateNewConfigurationPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    ConfigurationCard(
                      title: "4 Gate Sprint Run",
                      subtitle: "4 Gates\nLast Used 23 Oct\nAttributes 1\nAttributes 2",
                      icon: Icons.speed,
                    ),
                    SizedBox(height: 16),
                    ConfigurationCard(
                      title: "Device Debug",
                      icon: Icons.settings_input_component,
                      onTap: () {
                        // Passing the `device` data to DeviceDetailsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeviceDetailsPage(device: state.device),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ConfigurationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const ConfigurationCard({
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MainColors.primaryColor, LinearColors.Mixer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: MainColors.white,
              radius: 35,
              child: Icon(
                icon,
                color: MainColors.primaryColor,
                size: 32,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: MainColors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          color: MainColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 24, color: MainColors.white),
          ],
        ),
      ),
    );
  }
}