import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  late SharedPreferences prefs;
  Future<void> setDataToSharedPref(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getDataFromSharedPref(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
