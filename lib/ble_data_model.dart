class BleDataModel {
  // final double accelerometer;
  // final double gyroscopeX;
  // final double gyroscopeY;
  // final double gyroscopeZ;
  final double signalStrength;
  final double iotAccX;
  final double iotAccY;
  final double iotAccZ;
  final double iotGyrX;
  final double iotGyrY;
  final double iotGyrZ;

  BleDataModel({
    // required this.accelerometer,
    // required this.gyroscopeX,
    // required this.gyroscopeY,
    // required this.gyroscopeZ,
    required this.signalStrength,
    required this.iotAccX,
    required this.iotAccY,
    required this.iotAccZ,
    required this.iotGyrX,
    required this.iotGyrY,
    required this.iotGyrZ,
  });

  factory BleDataModel.fromJson(Map<String, dynamic> json) {
    return BleDataModel(
      // accelerometer: (json['accelerometer'] as num).toDouble(),
      // gyroscopeX: (json['gyroscopeX'] as num).toDouble(),
      // gyroscopeY: (json['gyroscopeY'] as num).toDouble(),
      // gyroscopeZ: (json['gyroscopeZ'] as num).toDouble(),
      signalStrength: (json['signalStrength'] as num).toDouble(),
      iotAccX: (json['iotAccX'] as num).toDouble(),
      iotAccY: (json['iotAccY'] as num).toDouble(),
      iotAccZ: (json['iotAccZ'] as num).toDouble(),
      iotGyrX: (json['iotGyrX'] as num).toDouble(),
      iotGyrY: (json['iotGyrY'] as num).toDouble(),
      iotGyrZ: (json['iotGyrZ'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'accelerometer': accelerometer,
      // 'gyroscopeX': gyroscopeX,
      // 'gyroscopeY': gyroscopeY,
      // 'gyroscopeZ': gyroscopeZ,
      'signalStrength': signalStrength,
      'iotAccX': iotAccX,
      'iotAccY': iotAccY,
      'iotAccZ': iotAccZ,
      'iotGyrX': iotGyrX,
      'iotGyrY': iotGyrY,
      'iotGyrZ': iotGyrZ,
    };
  }
}
