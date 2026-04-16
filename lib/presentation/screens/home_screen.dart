import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../widgets/section_title.dart';
import 'appointment_booking_screen.dart' ;
import 'my_health_records_screen.dart' ;
import 'ai_chat_screen.dart'; // Import for navigation
import 'anxiety_tracker_screen.dart';
import 'experience_screen.dart';
import '../../core/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIdentityHeader(),
          const SizedBox(height: 24),
          
          // Action Grid: The core functionality [cite: 2026-03-30]
          _buildActionGrid(context),
          const SizedBox(height: 24),

          // Follow-up & Support [cite: Rewritten Concept]
          _buildSupportBanner(),
          const SizedBox(height: 24),

          // About our Medical expertise
          const SectionTitle(title: AppConstants.sectionServices),
          _buildServicesGrid(context),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildIdentityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patient Portal", style: TextStyle(color: Colors.blueGrey, letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(AppConstants.drName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003d80))),
            Text(AppConstants.drSpecialty, style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFF3F4FB),
            backgroundImage: NetworkImage('https://www.drnirmal.com.np/profile.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildCompactAction(
          Icons.calendar_today, 
          AppConstants.actionBook, 
          Colors.blue, 
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentBookingScreen())),
        ),
        
        _buildCompactAction(
          Icons.folder_shared, 
          AppConstants.actionRecords, 
          Colors.teal, 
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHealthRecordsScreen(showOnlyPrescriptions: false))),
        ),
        
        _buildCompactAction(
          Icons.psychology_outlined, 
          "Anxiety Tracker", 
          Colors.orange, 
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnxietyTrackerScreen())),
        ),
        
        _buildCompactAction(
          Icons.support_agent, 
          AppConstants.actionAI, 
          Colors.purple, 
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: const Text("AI Assistant")), body: const AIChatScreen()))),
        ),
      ],
    );
  }

  Widget _buildCompactAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportBanner() {
    return InkWell(
      onTap: () => AppUtils.launchURL("tel:056524501"), // Direct trigger for health emergency
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF003D80), Color(0xFF0056B3)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Need Emergency Support?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(AppConstants.emergencyLine, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            Text(AppConstants.followUpSupport, style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    return Column(
      children: AppConstants.mainServices.map((s) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.check_circle_outline, color: Color(0xFF003D80)),
          title: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            // Service click navigates to info screen [cite: 2026-03-30]
            Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
              appBar: AppBar(title: Text(s)),
              body: const ExperienceScreen(),
            )));
          },
        ),
      )).toList(),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title feature coming soon! (Healthcare Records Integration)")));
  }
}