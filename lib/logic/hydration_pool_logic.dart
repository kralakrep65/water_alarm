import 'package:flutter/cupertino.dart';
import 'package:water_alarm/constant/shared_preferences_helper.dart';
import 'package:water_alarm/data/sql_data_helper.dart';
import 'package:water_alarm/domain/model/user_model.dart';

class HydrationPoolLogic {
  static final HydrationPoolLogic _instance = HydrationPoolLogic._internal();
  factory HydrationPoolLogic() => _instance;
  HydrationPoolLogic._internal();

  final DatabaseHelper _personDataSource = DatabaseHelper();
  int _todayConsumptionAmount = 0;
  int get todayConsumptionAmount => _todayConsumptionAmount;
  void reset() {
    _todayConsumptionAmount = 0;
    progressNotifier.value = 0;
  }

  ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
  Future getTodayConsumption() async {
    UserModel.defaultConsumptionTarget = double.parse(
        await SharedPreferencesHelper()
                .getDataFromSharedPref("defaultConsumptionTarget") ??
            '0');
    try {
      _todayConsumptionAmount = 0;
      List<Map<String, dynamic>> todayData =
          await _personDataSource.getTodayConsumption();
      if (todayData.isNotEmpty) {
        for (var element in todayData) {
          _todayConsumptionAmount +=
              int.parse(element['consumption_amount'].round().toString());
        }
        print(todayData);
      }
      progressNotifier.value =
          (_todayConsumptionAmount / UserModel.defaultConsumptionTarget) <= 1
              ? (_todayConsumptionAmount / UserModel.defaultConsumptionTarget)
              : 1;
      // updateProgress();
    } catch (e) {
      print(e);
    }
  }

  double remindingWater() {
    return UserModel.defaultConsumptionTarget - _todayConsumptionAmount;
  }

  setTodayConsumption(int consumption) async {
    await _personDataSource.setTodayConsumption(consumption);
    await getTodayConsumption();
  }

  void updateProgress() async {
    progressNotifier.value =
        (_todayConsumptionAmount / UserModel.defaultConsumptionTarget);
    print(progressNotifier.value);
  }
}
