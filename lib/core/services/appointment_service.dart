import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/appointment_model.dart';

class AppointmentService {
  static const String _storageKey = 'patient_appointments';

  // Schedule a new appointment
  static Future<void> schedule(Appointment appointment) async {
    final appointments = await fetchAll();
    appointments.add(appointment);
    await _saveAll(appointments);
  }

  // Cancel an appointment
  static Future<void> cancel(String id) async {
    final appointments = await fetchAll();
    final index = appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      appointments[index] = appointments[index].copyWith(status: AppointmentStatus.cancelled);
      await _saveAll(appointments);
    }
  }

  // Complete an appointment
  static Future<void> complete(String id) async {
    final appointments = await fetchAll();
    final index = appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      appointments[index] = appointments[index].copyWith(status: AppointmentStatus.completed);
      await _saveAll(appointments);
    }
  }

  // Reschedule an existing appointment
  static Future<void> reschedule(String id, DateTime newStartTime) async {
    final appointments = await fetchAll();
    final index = appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      appointments[index] = appointments[index].copyWith(dateTime: newStartTime);
      await _saveAll(appointments);
    }
  }

  // Fetch all appointments
  static Future<List<Appointment>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data == null) return [];
    
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Appointment.fromJson(e)).toList();
  }

  // Internal Helper to save list
  static Future<void> _saveAll(List<Appointment> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, data);
  }
}
