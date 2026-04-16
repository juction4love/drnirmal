import 'package:flutter/material.dart';
import '../../core/services/appointment_service.dart';
import '../../core/services/patient_service.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/patient_model.dart';

class MyHealthRecordsScreen extends StatefulWidget {
  final bool showOnlyPrescriptions;
  const MyHealthRecordsScreen({super.key, this.showOnlyPrescriptions = false});

  @override
  State<MyHealthRecordsScreen> createState() => _MyHealthRecordsScreenState();
}

class _MyHealthRecordsScreenState extends State<MyHealthRecordsScreen> {
  List<Appointment> _appointments = [];
  PatientRecord? _patientRecord;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Fetch appointments for history
    final apps = await AppointmentService.fetchAll();
    // Fetch patient record for prescriptions/notes
    final record = await PatientService.fetchById("PATIENT_001");

    setState(() {
      _appointments = apps.reversed.toList(); // Newest first
      _patientRecord = record;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showOnlyPrescriptions ? "My Prescriptions" : "Medical Journey"),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.showOnlyPrescriptions) ...[
                    _buildSectionHeader("Upcoming & Recent Visits"),
                    const SizedBox(height: 12),
                    _buildAppointmentHistory(),
                    const SizedBox(height: 30),
                  ],
                  
                  _buildSectionHeader(widget.showOnlyPrescriptions ? "All Prescriptions" : "Doctor's Recommendations"),
                  const SizedBox(height: 12),
                  _buildClinicalUpdates(),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003D80)));
  }

  Widget _buildAppointmentHistory() {
    if (_appointments.isEmpty) {
      return _buildEmptyCard("No appointments found.");
    }

    return Column(
      children: _appointments.take(5).map((app) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(
            app.status == AppointmentStatus.completed ? Icons.check_circle : Icons.schedule,
            color: app.status == AppointmentStatus.completed ? Colors.green : Colors.orange,
          ),
          title: Text(app.reason, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("${app.dateTime.day}/${app.dateTime.month}/${app.dateTime.year} at ${app.dateTime.hour}:${app.dateTime.minute.toString().padLeft(2, '0')}"),
          trailing: Text(app.status.name.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      )).toList(),
    );
  }

  Widget _buildClinicalUpdates() {
    if (_patientRecord == null || 
       (_patientRecord!.followUpNotes.isEmpty && _patientRecord!.prescriptions.isEmpty)) {
      return _buildEmptyCard("No clinical updates yet. Complete a visit to see notes.");
    }

    final List<Widget> items = [];

    // Prioritize Prescriptions if filtered
    if (widget.showOnlyPrescriptions) {
      for (var p in _patientRecord!.prescriptions.reversed) {
        items.add(_buildRecordTile(Icons.medical_services, "Prescription Update", p, Colors.indigo));
      }
    } else {
      // Show Follow-up Notes
      for (var n in _patientRecord!.followUpNotes.reversed) {
        items.add(_buildRecordTile(Icons.note_alt, "Medical Advice", n, Colors.teal));
      }
      // Show Prescriptions
      for (var p in _patientRecord!.prescriptions.reversed) {
        items.add(_buildRecordTile(Icons.medication, "Prescription", p, Colors.indigo));
      }
    }

    return Column(children: items);
  }

  Widget _buildRecordTile(IconData icon, String title, String content, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
      child: Center(child: Text(message, style: const TextStyle(color: Colors.grey))),
    );
  }
}
