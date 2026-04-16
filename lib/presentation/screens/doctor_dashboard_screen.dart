import 'package:flutter/material.dart';
import '../../core/services/appointment_service.dart';
import '../../core/services/patient_service.dart';
import '../../data/models/appointment_model.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await AppointmentService.fetchAll();
    setState(() {
      _appointments = data;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(String id, AppointmentStatus status) async {
    if (status == AppointmentStatus.completed) {
      await AppointmentService.complete(id);
    } else if (status == AppointmentStatus.cancelled) {
      await AppointmentService.cancel(id);
    }
    _loadData();
  }

  void _showFollowUpDialog(String patientId) {
    String note = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Follow-up Note"),
        content: TextField(
          decoration: const InputDecoration(hintText: "Enter medical recommendations..."),
          onChanged: (v) => note = v,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (note.isNotEmpty) {
                await PatientService.logFollowUp(patientId, note);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Follow-up note saved.")));
                }
              }
            },
            child: const Text("Save Note"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        actions: [IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh))],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _appointments.isEmpty 
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final app = _appointments[index];
                return _buildAppointmentCard(app);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text("No appointments booked yet.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment app) {
    final bool isPending = app.status == AppointmentStatus.pending;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(app.status),
                Text("${app.dateTime.day}/${app.dateTime.month} | ${app.dateTime.hour}:${app.dateTime.minute.toString().padLeft(2, '0')}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const Divider(height: 24),
            Text("Patient ID: ${app.patientId}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(app.reason, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (app.notes != null) ...[
              const SizedBox(height: 8),
              Text(app.notes!, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
            ],
            const SizedBox(height: 20),
            
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateStatus(app.id, AppointmentStatus.cancelled),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(app.id, AppointmentStatus.completed),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: const Text("Complete"),
                    ),
                  ),
                ],
              )
            else if (app.status == AppointmentStatus.completed)
              ElevatedButton.icon(
                onPressed: () => _showFollowUpDialog(app.patientId),
                icon: const Icon(Icons.note_add),
                label: const Text("Log Follow-Up Note"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  backgroundColor: const Color(0xFF003D80),
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color color = Colors.grey;
    String label = "UNKNOWN";

    switch (status) {
      case AppointmentStatus.pending: color = Colors.orange; label = "PENDING"; break;
      case AppointmentStatus.completed: color = Colors.green; label = "COMPLETED"; break;
      case AppointmentStatus.cancelled: color = Colors.red; label = "CANCELLED"; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
