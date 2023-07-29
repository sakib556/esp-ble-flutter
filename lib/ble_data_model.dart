class BleDataModel {
  final double accelerometer;
  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;
  final double signalStrength;
  final double imuAccX;
  final double imuAccY;
  final double imuAccZ;
  final double imuGyrX;
  final double imuGyrY;
  final double imuGyrZ;

  BleDataModel({
    required this.accelerometer,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
    required this.signalStrength,
    required this.imuAccX,
    required this.imuAccY,
    required this.imuAccZ,
    required this.imuGyrX,
    required this.imuGyrY,
    required this.imuGyrZ,
  });

  factory BleDataModel.fromJson(Map<String, dynamic> json) {
    return BleDataModel(
      accelerometer: (json['accelerometer'] as num).toDouble(),
      gyroscopeX: (json['gyroscopeX'] as num).toDouble(),
      gyroscopeY: (json['gyroscopeY'] as num).toDouble(),
      gyroscopeZ: (json['gyroscopeZ'] as num).toDouble(),
      signalStrength: (json['signalStrength'] as num).toDouble(),
      imuAccX: (json['imuAccX'] as num).toDouble(),
      imuAccY: (json['imuAccY'] as num).toDouble(),
      imuAccZ: (json['imuAccZ'] as num).toDouble(),
      imuGyrX: (json['imuGyrX'] as num).toDouble(),
      imuGyrY: (json['imuGyrY'] as num).toDouble(),
      imuGyrZ: (json['imuGyrZ'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accelerometer': accelerometer,
      'gyroscopeX': gyroscopeX,
      'gyroscopeY': gyroscopeY,
      'gyroscopeZ': gyroscopeZ,
      'signalStrength': signalStrength,
      'imuAccX': imuAccX,
      'imuAccY': imuAccY,
      'imuAccZ': imuAccZ,
      'imuGyrX': imuGyrX,
      'imuGyrY': imuGyrY,
      'imuGyrZ': imuGyrZ,
    };
  }
}
