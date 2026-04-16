import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/patient_model.dart';

class PatientService {
  static const String _storageKey = 'patient_records';

  // Add a new patient record (e.g., initial registration)
  static Future<void> addRecord(PatientRecord record) async {
    final records = await fetchAll();
    records.add(record);
    await _saveAll(records);
  }

  // Update a patient's prescription list
  static Future<void> updatePrescription(String patientId, String newPrescription) async {
    final records = await fetchAll();
    final index = records.indexWhere((r) => r.id == patientId);
    if (index != -1) {
      final updatedPrescriptions = List<String>.from(records[index].prescriptions)..add(newPrescription);
      records[index] = records[index].copyWith(prescriptions: updatedPrescriptions);
      await _saveAll(records);
    }
  }

  // Log a follow-up note for a patient
  static Future<void> logFollowUp(String patientId, String note) async {
    final records = await fetchAll();
    final index = records.indexWhere((r) => r.id == patientId);
    if (index != -1) {
      final updatedNotes = List<String>.from(records[index].followUpNotes)..add(note);
      records[index] = records[index].copyWith(followUpNotes: updatedNotes);
      await _saveAll(records);
    }
  }

  // Fetch all patient records
  static Future<List<PatientRecord>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data == null) return [];
    
    final List decoded = jsonDecode(data);
    return decoded.map((e) => PatientRecord.fromJson(e)).toList();
  }

  // Fetch a specific patient record by ID
  static Future<PatientRecord?> fetchById(String patientId) async {
    final records = await fetchAll();
    try {
      return records.firstWhere((r) => r.id == patientId);
    } catch (e) {
      return null;
    }
  }

  // Internal Helper to save list
  static Future<void> _saveAll(List<PatientRecord> list) async {
    final String data = jsonEncode(list.map((e) => e.toJson()).toList());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, data);
  }
}
