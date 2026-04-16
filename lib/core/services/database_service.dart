import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/patient_model.dart';
import '../security/encryption_service.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dr_nirmal_patients.db');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        contactNumber TEXT,
        clinicalHistory TEXT,
        prescriptions TEXT,
        lastVisitDate TEXT,
        nextFollowUp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE anxiety_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        score REAL,
        symptoms TEXT,
        notes TEXT,
        timestamp TEXT
      )
    ''');
  }

  static Future<void> insertPatient(PatientRecord patient) async {
    final db = await database;
    // Encrypt sensitive history before saving
    final encryptedHistory = EncryptionService.encryptData(patient.medicalHistory.join(','));
    
    final map = {
      'id': patient.id,
      'fullName': patient.name,
      'clinicalHistory': encryptedHistory,
      'prescriptions': patient.prescriptions.join(','),
    };
    
    await db.insert('patients', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<PatientRecord>> getAllPatients() async {
    final db = await database;
    final res = await db.query('patients');
    
    return res.map((json) {
      final decryptedHistory = json['clinicalHistory'] != null 
          ? EncryptionService.decryptData(json['clinicalHistory'] as String)
          : '';
      
      return PatientRecord(
        id: json['id'] as String,
        name: json['fullName'] as String,
        age: 0, // Placeholder as schema doesn't have it
        gender: 'Unknown',
        medicalHistory: decryptedHistory.split(','),
        prescriptions: (json['prescriptions'] as String? ?? '').split(','),
        followUpNotes: [],
      );
    }).toList();
  }

  // Anxiety Methods
  static Future<void> insertAnxietyEntry(Map<String, dynamic> entry) async {
    final db = await database;
    
    // Security Hardening: Encrypt progress notes before storage
    final encryptedNotes = EncryptionService.encryptData(entry['notes'] ?? '');
    
    final Map<String, dynamic> secureEntry = Map.from(entry);
    secureEntry['notes'] = encryptedNotes;
    
    await db.insert('anxiety_entries', secureEntry);
  }

  static Future<List<Map<String, dynamic>>> getAnxietyEntries() async {
    final db = await database;
    final res = await db.query('anxiety_entries', orderBy: 'timestamp DESC');
    
    return res.map((json) {
      final decryptedNotes = json['notes'] != null 
          ? EncryptionService.decryptData(json['notes'] as String)
          : '';
      
      final Map<String, dynamic> readableJson = Map.from(json);
      readableJson['notes'] = decryptedNotes;
      return readableJson;
    }).toList();
  }
}
