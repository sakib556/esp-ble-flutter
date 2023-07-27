import 'package:ble_app/ble_data.dart';
import 'package:ble_app/speedometer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE Data & Speedometer"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accelerometer data card
            WalkingSpeedScreen(),
            SizedBox(height: 16),
            BleData()
          ],
        ),
      ),
    );
  }
}
