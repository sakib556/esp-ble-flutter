import 'dart:async';

import 'package:alxgration_speedometer/speedometer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WalkingSpeedScreen extends StatefulWidget {
  const WalkingSpeedScreen({super.key});

  @override
  _WalkingSpeedScreenState createState() => _WalkingSpeedScreenState();
}

class _WalkingSpeedScreenState extends State<WalkingSpeedScreen> {
  double currentSpeed = 0.0;
  StreamSubscription<Position>?
      positionStreamSubscription; // Store the subscription here

  @override
  void initState() {
    super.initState();
    _getCurrentSpeed();
  }

  @override
  void dispose() {
    // Cancel the stream subscription to avoid memory leaks
    print("Dispose called");
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _getCurrentSpeed() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle case when location services are disabled
      return;
    }

    // Check if the app has permission to access the location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Handle case when location permissions are permanently denied
      return;
    } else if (permission == LocationPermission.denied) {
      // Request location permissions if not granted
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle case when location permissions are denied
        return;
      }
    }

    // Get the current position (location)
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      // Calculate the current speed using the location data
      double speed = position.speed;
      if (mounted) {
        setState(() {
          currentSpeed = speed;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display Speedometer
        SpeedometerDisplay(speed: currentSpeed.toInt()),
        const SizedBox(height: 16),
        Text(
          'Current Speed: ${currentSpeed.toStringAsFixed(2)} m/s',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SpeedometerDisplay extends StatelessWidget {
  final int speed;

  const SpeedometerDisplay({super.key, required this.speed});

  void showSnackbar() {
    // You can show a snackbar here when the animation is complete.
    print('Animation Complete');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Speedometer(
        size: 200,
        currentValue: speed,
        barColor: Colors.blue,
        // pointerColor: Colors.black,
        displayText: "km/h",
        // displayTextStyle:
        //     const TextStyle(fontSize: 24, color: Colors.deepOrange),
        // displayNumericStyle: const TextStyle(fontSize: 24, color: Colors.red),
        onComplete: () {
          showSnackbar();
        },
      ),
    );
  }
}
