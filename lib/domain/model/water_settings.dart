import 'package:water_alarm/domain/model/user_model.dart';

class WaterSettings {
  final int currentMilliliters;
  final double recommendedMilliliters;
  final bool alarmEnabled;

  WaterSettings({
    required this.currentMilliliters,
    required this.recommendedMilliliters,
    required this.alarmEnabled,
  });

  factory WaterSettings.initial() {
    return WaterSettings(
      currentMilliliters: 0,
      recommendedMilliliters: UserModel.defaultConsumptionTarget,
      alarmEnabled: true,
    );
  }

  factory WaterSettings.fromMap(Map map) {
    return WaterSettings(
      currentMilliliters: map["currentMilliliters"],
      recommendedMilliliters: map["recommendedMilliliters"],
      alarmEnabled: map["alarmEnabled"],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WaterSettings &&
        other.currentMilliliters == currentMilliliters &&
        other.recommendedMilliliters == recommendedMilliliters &&
        other.alarmEnabled == alarmEnabled;
  }

  @override
  int get hashCode =>
      currentMilliliters.hashCode ^
      recommendedMilliliters.hashCode ^
      alarmEnabled.hashCode;
}
