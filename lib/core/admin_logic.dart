import 'package:shared_preferences/shared_preferences.dart';

class AdminLogic {
  static const String secretPin = "7788"; // डा. निर्मलले मात्र थाहा पाउने पिन

  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dr_nirmal') ?? false;
  }

  static Future<void> setAdmin(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dr_nirmal', status);
  }
}