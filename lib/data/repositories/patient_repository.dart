import '../../core/services/database_service.dart';
import '../models/patient_model.dart';

abstract class IPatientRepository {
  Future<List<PatientRecord>> fetchPatients();
  Future<void> addPatient(PatientRecord patient);
  Future<List<PatientRecord>> searchPatients(String query);
}

class PatientRepository implements IPatientRepository {
  @override
  Future<List<PatientRecord>> fetchPatients() async {
    return await DatabaseService.getAllPatients();
  }

  @override
  Future<void> addPatient(PatientRecord patient) async {
    await DatabaseService.insertPatient(patient);
  }

  @override
  Future<List<PatientRecord>> searchPatients(String query) async {
    final all = await fetchPatients();
    return all.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
