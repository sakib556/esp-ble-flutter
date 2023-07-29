import 'dart:convert';

import 'package:ble_app/ble_data_model.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BleData extends StatefulWidget {
  const BleData({super.key});

  @override
  State<BleData> createState() => _BleDataState();
}

class _BleDataState extends State<BleData> {
  // var flutterBlue = FlutterBluePlus;
  BluetoothDevice? device;
  BluetoothCharacteristic? rxCharacteristic;
  BluetoothCharacteristic? txCharacteristic;
  String _message = "";
  bool isError = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    initBLE();
  }

  @override
  void dispose() {
    device?.disconnect();
    super.dispose();
  }

  void loading(bool value) {
    isError = false;
    isLoading = value;
    if (value) _message = "";
    setState(() {});
  }

  void error() {
    isLoading = false;
    isError = true;
    setState(() {});
  }

  void initBLE() async {
    loading(true);
    final isOn = await FlutterBluePlus.isOn;
    if (isOn) {
      print("On ble");
      await connectToDevice();
    } else {
      print("Off ble");
      EasyLoading.showError("Please turn on your bluetooth !!");
      error();
    }
  }

  BleDataModel? bleData;

  Future<void> connectToDevice() async {
    // Scan for available devices
    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
      final connectDevices = await FlutterBluePlus.connectedSystemDevices;
      if (connectDevices.isNotEmpty) {
        for (var dev in connectDevices) {
          if (dev.localName == "ESP BLE") {
            await dev.disconnect();
            break;
          }
        }
      }
      List<ScanResult> scanResults =
          await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      // await flutterBlue.startScan(timeout: const Duration(seconds: 4));

      // Find the device with the desired name ("LIDAR")
      for (ScanResult result in scanResults) {
        if (result.device.localName == "ESP BLE") {
          device = result.device;
          break;
        }
      }

      // Connect to the device
      if (device != null) {
        await device!.connect();
        print("requesting......");
        await device!.requestMtu(517);
        print("requested........");
        // Discover services and characteristics
        List<BluetoothService> services = await device!.discoverServices();
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            // Check if the characteristic UUID matches the receiving characteristic
            if (characteristic.uuid.toString() ==
                "beb5483e-36e1-4688-b7f5-ea07361b26a9") {
              txCharacteristic = characteristic;

              // Set up notification for receiving characteristic
              txCharacteristic!.setNotifyValue(true);
              txCharacteristic!.onValueReceived.listen((value) {
                // Handle received data here
                if (value.isNotEmpty && mounted) {
                  _message = String.fromCharCodes(value);
                  bleData = BleDataModel.fromJson(jsonDecode(_message));
                  loading(false);

                  print("\n----BLE Data get : $_message\n");
                  setState(() {});
                }
              });
            }

            // Check if the characteristic UUID matches the transmitting characteristic
            // if (characteristic.uuid.toString() ==
            //     "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
            //   rxCharacteristic = characteristic;
            // }
          }
        }
      } else {
        EasyLoading.showError("ESP BLE not found !");
        error();
      }
    } on Exception catch (e) {
      print("Error catch");
      error();
      print(e);
    }

    // void sendDataToBLE(String data) async {
    //   print("my data is : $data");
    //   if (rxCharacteristic != null) {
    //     List<int> value = data.codeUnits;
    //     await rxCharacteristic!.write(value, withoutResponse: true);
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _loadingData()
        : _message.isNotEmpty && !isError
            ? _loadedData()
            : _errorData();
  }

  Widget _loadedData() {
    return Column(
      children: [
        SensorCard(
          icon: Icons.speed,
          title: 'Accelerometer',
          data: 'Z: ${bleData!.accelerometer}',
        ),
        const SizedBox(height: 16),
        // Gyroscope data card
        SensorCard(
          icon: Icons.gas_meter,
          title: 'Gyroscope',
          data:
              'X: ${bleData!.gyroscopeX}\nY: ${bleData!.gyroscopeY}\nZ: ${bleData!.gyroscopeZ}',
        ),
        const SizedBox(height: 16),
        // Sensor 3 data card
        SensorCard(
          icon: Icons.signal_cellular_alt_rounded,
          title: 'Signal Strength',
          data: '${bleData!.signalStrength}',
        ),
        const SizedBox(height: 16),
        // Sensor 4 data card
        SensorCard(
          icon: Icons.phone_iphone_sharp,
          title: 'IMU-Accelerometer',
          data:
              'X: ${bleData!.imuAccX}\nY: ${bleData!.imuAccY}\nZ: ${bleData!.imuAccZ}',
        ),
        SensorCard(
          icon: Icons.phone_android_outlined,
          title: 'IMU-Gyroscope',
          data:
              'X: ${bleData!.imuGyrX}\nY: ${bleData!.imuGyrY}\nZ: ${bleData!.imuGyrZ}',
        ),
      ],
    );
  }

  Widget _loadingData() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Center(
          child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text("Scanning the ESP BLE ....."),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Refresh"),
              IconButton(
                  onPressed: () {
                    initBLE();
                  },
                  icon: Icon(Icons.refresh)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }

  Widget _errorData() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Center(
          child: Column(
        children: [
          IconButton(
              onPressed: () {
                initBLE();
              },
              icon: Icon(Icons.replay)),
          SizedBox(
            height: 20,
          ),
          Text("Something went wrong.\nReload please.")
        ],
      )),
    );
  }
}

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String data;

  const SensorCard({
    super.key,
    required this.icon,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          // Changed Column to Row
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // To distribute children evenly
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(
                width: 16), // Add some space between the icon and text
            Expanded(
              // To ensure the AnimatedTextKit takes the remaining space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                      height: 8), // Add some space between the title and data
                  Container(
                    //width: double.infinity, // Take the full width available
                    //  height: 50, // Set a fixed height for the AnimatedTextKit
                    decoration: BoxDecoration(
                      //color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(data,
                              textStyle: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
