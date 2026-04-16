import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/services/appointment_service.dart';
import '../../data/models/appointment_model.dart';
import 'payment_screen.dart'; // Stable, modern Flutter-based Payment Screen [cite: 2026-03-30]

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isBooking = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _handleBook() async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a reason for visit")));
      return;
    }

    final reason = _reasonController.text;
    final appointmentDate = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      _selectedTime.hour, _selectedTime.minute,
    );

    // Navigate to Stable Payment Bridge [cite: 2026-03-30]
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: 500.0, 
          onSuccess: (txnId) => _finalizeBooking(appointmentDate, txnId),
        ),
      ),
    );
  }

  Future<void> _finalizeBooking(DateTime dateTime, String txnId) async {
    setState(() => _isBooking = true);

    final newAppointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: "PATIENT_001",
      doctorId: AppConstants.drName,
      dateTime: dateTime,
      reason: _reasonController.text,
      status: AppointmentStatus.pending,
      paymentStatus: PaymentStatus.paid,
      transactionId: txnId,
    );

    await AppointmentService.schedule(newAppointment);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verified! Appointment scheduled successfully."), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            
            const Text("Select Date & Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildDateTimePicker(),
            
            const SizedBox(height: 24),
            const Text("Reason for Visit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g., General check-up, Consultation...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            
            const SizedBox(height: 40),
            _isBooking 
              ? const Center(child: CircularProgressIndicator()) 
              : ElevatedButton(
                  onPressed: _handleBook,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: const Color(0xFF003d80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Continue to Payment (NPR 500)", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF003d80).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF003d80).withValues(alpha: 0.1)),
      ),
      child: const Row(
        children: [
          CircleAvatar(backgroundColor: Color(0xFF003d80), child: Icon(Icons.medical_services, color: Colors.white)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppConstants.drName, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(AppConstants.drSpecialty, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            dense: true,
            title: const Text("Date", style: TextStyle(fontSize: 12, color: Colors.grey)),
            subtitle: Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.event, color: Color(0xFF003d80)),
            onTap: _pickDate,
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ListTile(
            dense: true,
            title: const Text("Time", style: TextStyle(fontSize: 12, color: Colors.grey)),
            subtitle: Text(_selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: const Icon(Icons.access_time, color: Color(0xFF003d80)),
            onTap: _pickTime,
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
