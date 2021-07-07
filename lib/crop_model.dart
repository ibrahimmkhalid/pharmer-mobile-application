class CropModel {
  final String name;
  final String iconPath;
  final String subText;
  final double airTemp;
  final double airHumidity;
  final double soilMoisture;

  CropModel({
    required this.name,
    required this.soilMoisture,
    required this.iconPath,
    required this.subText,
    required this.airTemp,
    required this.airHumidity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconPath': iconPath,
      'subText': subText,
      'airTemp': airTemp,
      'airHumidity': airHumidity,
      'soilMoisture': soilMoisture,
    };
  }
}
