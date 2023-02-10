import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  setInt(String key, int value) async {
    SharedPreferences pref = await preferences;
    return pref.setInt(key, value);
  }

  setString(String key, String value) async {
    SharedPreferences pref = await preferences;
    return pref.setString(key, value);
  }

  setBool(String key, bool value) async {
    SharedPreferences pref = await preferences;
    return pref.setBool(key, value);
  }

  setDouble(String key, double value) async {
    SharedPreferences pref = await preferences;
    return pref.setDouble(key, value);
  }

  getString(String key) async {
    SharedPreferences pref = await preferences;
    return pref.getString(key);
  }

  getInt(String key) async {
    SharedPreferences pref = await preferences;
    return pref.getInt(key);
  }

  getBool(String key) async {
    SharedPreferences pref = await preferences;
    return pref.getBool(key);
  }

  getDouble(String key) async {
    SharedPreferences pref = await preferences;
    return pref.getDouble(key);
  }
}
