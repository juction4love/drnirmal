import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { patient, doctor }

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userRoleKey = 'user_role';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get current user role
  static Future<UserRole> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_userRoleKey);
    return role == 'doctor' ? UserRole.doctor : UserRole.patient;
  }

  // Handle Login
  static Future<void> login(String email, String password, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userRoleKey, role.name);
    await prefs.setString(_userEmailKey, email);
    // Mock user name for now
    await prefs.setString(_userNameKey, "Patient User");
  }

  // Handle Registration
  static Future<void> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    // Auto-login after registration as patient
    await login(email, password, UserRole.patient);
  }

  // Handle Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  // Get User Details
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey),
      'email': prefs.getString(_userEmailKey),
      'role': prefs.getString(_userRoleKey),
    };
  }
}
