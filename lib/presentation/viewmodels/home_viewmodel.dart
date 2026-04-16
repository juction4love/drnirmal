import 'package:flutter/material.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final IPatientRepository _repository;

  HomeViewModel(this._repository);

  List<PatientRecord> _patients = [];
  List<PatientRecord> get patients => _patients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      _patients = await _repository.fetchPatients();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadPatients();
      return;
    }
    _patients = await _repository.searchPatients(query);
    notifyListeners();
  }
}
