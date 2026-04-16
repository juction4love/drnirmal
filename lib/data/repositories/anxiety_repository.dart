import '../../core/services/database_service.dart';
import '../models/anxiety_entry_model.dart';

abstract class IAnxietyRepository {
  Future<void> logAnxiety(AnxietyEntry entry);
  Future<List<AnxietyEntry>> fetchHistory();
}

class AnxietyRepository implements IAnxietyRepository {
  @override
  Future<void> logAnxiety(AnxietyEntry entry) async {
    await DatabaseService.insertAnxietyEntry(entry.toMap());
  }

  @override
  Future<List<AnxietyEntry>> fetchHistory() async {
    final maps = await DatabaseService.getAnxietyEntries();
    return maps.map((m) => AnxietyEntry.fromMap(m)).toList();
  }
}
