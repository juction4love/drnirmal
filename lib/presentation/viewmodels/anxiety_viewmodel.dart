import 'package:flutter/material.dart';
import '../../data/models/anxiety_entry_model.dart';
import '../../data/repositories/anxiety_repository.dart';

class AnxietyViewModel extends ChangeNotifier {
  final IAnxietyRepository _repository;

  AnxietyViewModel(this._repository);

  List<AnxietyEntry> _history = [];
  List<AnxietyEntry> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    _history = await _repository.fetchHistory();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(double score, List<String> symptoms, String notes) async {
    final entry = AnxietyEntry(
      score: score,
      symptoms: symptoms,
      notes: notes,
      timestamp: DateTime.now(),
    );
    await _repository.logAnxiety(entry);
    await loadHistory();
  }
}
