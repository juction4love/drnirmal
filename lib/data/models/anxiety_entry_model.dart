class AnxietyEntry {
  final String? id;
  final double score; // 1.0 - 10.0
  final List<String> symptoms;
  final String notes;
  final DateTime timestamp;

  AnxietyEntry({
    this.id,
    required this.score,
    required this.symptoms,
    required this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score': score,
      'symptoms': symptoms.join(','),
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AnxietyEntry.fromMap(Map<String, dynamic> map) {
    return AnxietyEntry(
      id: map['id'],
      score: map['score']?.toDouble() ?? 0.0,
      symptoms: (map['symptoms'] as String).split(','),
      notes: map['notes'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
