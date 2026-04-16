import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../core/services/auth_service.dart';
import '../screens/doctor_dashboard_screen.dart';
import '../screens/experience_screen.dart';
import '../screens/my_health_records_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map<String, String?> _userData = {};
  UserRole _role = UserRole.patient;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await AuthService.getUserData();
    final role = await AuthService.getUserRole();
    setState(() {
      _userData = data;
      _role = role;
    });
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Dynamic Header with Authenticated User [cite: 2026-03-30]
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF003D80), Color(0xFF001F40)]),
            ),
            accountName: Text(_userData['name'] ?? "Patient User", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(_userData['email'] ?? "nirmal.patient@example.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.shield_moon, size: 40, color: Color(0xFF003D80)),
            ),
          ),

          // Role-Based Navigation
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (_role == UserRole.doctor) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text("Staff Administrative", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  _buildDrawerItem(Icons.dashboard_outlined, "Doctor Dashboard", () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorDashboardScreen()));
                  }),
                  const Divider(),
                ],

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text("Patient Services", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                _buildDrawerItem(Icons.calendar_month, AppConstants.actionBook, () => AppUtils.launchURL(AppConstants.appointmentLink)),
                _buildDrawerItem(Icons.folder_shared_outlined, AppConstants.actionRecords, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHealthRecordsScreen(showOnlyPrescriptions: false)));
                }),
                _buildDrawerItem(Icons.receipt_long, AppConstants.actionPrescriptions, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHealthRecordsScreen(showOnlyPrescriptions: true)));
                }),
                
                const Divider(),
                _buildDrawerItem(Icons.privacy_tip_outlined, "Privacy Policy", () => AppUtils.launchURL(AppConstants.privacyPolicy)),
                _buildDrawerItem(Icons.info_outline, "About Digital Healthcare", () {
                  Navigator.pop(context);
                  // Pushing a Scaffold wrapped ExperienceScreen for standalone navigation
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text("About Care & Expertise")),
                    body: const ExperienceScreen(),
                  )));
                }),
                
                const Divider(),
                _buildDrawerItem(Icons.logout, "Logout System", _handleLogout, color: Colors.red),
              ],
            ),
          ),

          // Version Footer
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(AppConstants.appVersion, style: TextStyle(color: Colors.grey, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF003D80)),
      title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color)),
      onTap: onTap,
    );
  }
}