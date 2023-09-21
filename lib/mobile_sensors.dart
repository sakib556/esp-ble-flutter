import 'dart:async';
import 'package:ble_app/ble_data.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MobileSensors extends StatefulWidget {
  const MobileSensors({super.key});

  @override
  State<MobileSensors> createState() => _MobileSensorsState();
}

class _MobileSensorsState extends State<MobileSensors> {
  double accMeterX = 0.0;
  double accMeterY = 0.0;
  double accMeterZ = 0.0;
  double gyrX = 0.0;
  double gyrY = 0.0;
  double gyrZ = 0.0;
  final _updateInterval =
      const Duration(seconds: 3); // Update interval: 1 second

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  bool updated = false;
  @override
  void initState() {
    super.initState();
    initMobileSensor();
  }

  @override
  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void initMobileSensor() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        // ignore: curly_braces_in_flow_control_structures
        (AccelerometerEvent event) {
          accMeterX = event.x;
          accMeterY = event.y;
          accMeterZ = event.z;
          if (!updated) setState(() {});
          updated = true;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Accelerometer Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );

    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          gyrX = event.x;
          gyrY = event.y;
          gyrZ = event.z;
          if (!updated) setState(() {});
          updated = true;
        },
        onError: (e) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Gyroscope Sensor"),
              );
            },
          );
        },
        cancelOnError: true,
      ),
    );

    setState(() {});
    Timer.periodic(_updateInterval, (timer) {
      setState(() {});
    });
  }

  String formatDouble(double value) {
    return value.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    print("\nbuild called.......\n");
    return Column(
      children: [
        SensorCard(
          icon: Icons.phone_android_rounded,
          title: 'Accelerometer',
          data:
              'X: ${formatDouble(accMeterX)}\nY: ${formatDouble(accMeterY)}\nZ: ${formatDouble(accMeterZ)}',
        ),
        const SizedBox(height: 16),
        // Gyroscope data card
        SensorCard(
          icon: Icons.phone_android_rounded,
          title: 'Gyroscope',
          data:
              'X: ${formatDouble(gyrX)}\nY: ${formatDouble(gyrY)}\nZ: ${formatDouble(gyrZ)}',
        ),
      ],
    );
  }
}
