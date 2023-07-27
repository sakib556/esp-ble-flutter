class BleDataModel {
  final double accelerometer;
  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;
  final double sensor3Data;
  final double sensor4Data;
  final double currentSpeed;

  BleDataModel({
    required this.accelerometer,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
    required this.sensor3Data,
    required this.sensor4Data,
    required this.currentSpeed,
  });

  factory BleDataModel.fromJson(Map<String, dynamic> json) {
    return BleDataModel(
      accelerometer: (json['accelerometer'] as num).toDouble(),
      gyroscopeX: (json['gyroscopeX'] as num).toDouble(),
      gyroscopeY: (json['gyroscopeY'] as num).toDouble(),
      gyroscopeZ: (json['gyroscopeZ'] as num).toDouble(),
      sensor3Data: (json['sensor3Data'] as num).toDouble(),
      sensor4Data: (json['sensor4Data'] as num).toDouble(),
      currentSpeed: (json['currentSpeed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accelerometer': accelerometer,
      'gyroscopeX': gyroscopeX,
      'gyroscopeY': gyroscopeY,
      'gyroscopeZ': gyroscopeZ,
      'sensor3Data': sensor3Data,
      'sensor4Data': sensor4Data,
      'currentSpeed': currentSpeed,
    };
  }
}
