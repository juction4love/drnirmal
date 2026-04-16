class PatientRecord {
  final String id;
  final String name;
  final int age;
  final String gender;
  final List<String> medicalHistory;
  final List<String> prescriptions;
  final List<String> followUpNotes;

  PatientRecord({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.medicalHistory,
    required this.prescriptions,
    required this.followUpNotes,
  });

  // Convert to Map for Storage (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'medicalHistory': medicalHistory,
      'prescriptions': prescriptions,
      'followUpNotes': followUpNotes,
    };
  }

  // Create from Map
  factory PatientRecord.fromJson(Map<String, dynamic> json) {
    return PatientRecord(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      medicalHistory: List<String>.from(json['medicalHistory']),
      prescriptions: List<String>.from(json['prescriptions']),
      followUpNotes: List<String>.from(json['followUpNotes']),
    );
  }

  // CopyWith Pattern to add records/notes (Preserving Immutability)
  PatientRecord copyWith({
    String? name,
    int? age,
    String? gender,
    List<String>? medicalHistory,
    List<String>? prescriptions,
    List<String>? followUpNotes,
  }) {
    return PatientRecord(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      prescriptions: prescriptions ?? this.prescriptions,
      followUpNotes: followUpNotes ?? this.followUpNotes,
    );
  }
}
