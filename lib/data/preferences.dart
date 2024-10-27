import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String SDK_LOCATION = "icara_sdk_location";

  static Future setSdkLocation(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SDK_LOCATION, path ?? "");
  }

  static Future<String?> getSdkLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SDK_LOCATION);
  }
}
