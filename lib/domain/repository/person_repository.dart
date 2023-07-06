import 'package:water_alarm/data/sql_data_helper.dart';
import 'package:water_alarm/domain/model/user_model.dart';
import 'package:water_alarm/logic/hydration_pool_logic.dart';

class PersonRepository {
  final DatabaseHelper _personDataSource = DatabaseHelper();
  final HydrationPoolLogic _hydrationPoolLogic = HydrationPoolLogic();

  Future<List<UserModel>> getPerson() async {
    return await _personDataSource.getUsers().then((value) {
      if (value.isNotEmpty) {
        _hydrationPoolLogic.getTodayConsumption();
        UserModel.defaultConsumptionTarget = value[0].consumptionTarget ?? 20;
        print("${UserModel.defaultConsumptionTarget}defaultConsumptionTarget");
      }
      return value;
    });
  }

  Future<bool> createUsers(UserModel user) async {
    try {
      await _personDataSource.insertUser(user);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteUsers() async {
    await _personDataSource.deleteUser();
  }

  Future<int> getConsumptionCount() async {
    return await _personDataSource.getConsumptionCount();
  }

  getTodayConsumption() async {
    return await _personDataSource.getTodayConsumption();
  }

  getWeeklyConsumption() async {
    return await _personDataSource.getWeeklyConsumption();
  }

  getMonthlyConsumption() async {
    return await _personDataSource.getMonthlyConsumption();
  }
}
