enum AppointmentStatus { pending, completed, cancelled }
enum PaymentStatus { unpaid, paid }

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final AppointmentStatus status;
  final PaymentStatus paymentStatus;
  final DateTime dateTime;
  final String reason;
  final String? notes;
  final double amount;
  final String? transactionId; // Added for SDK tracking [cite: 2026-03-30]

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.status = AppointmentStatus.pending,
    this.paymentStatus = PaymentStatus.unpaid,
    required this.dateTime,
    required this.reason,
    this.notes,
    this.amount = 500.0,
    this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'dateTime': dateTime.toIso8601String(),
      'reason': reason,
      'notes': notes,
      'amount': amount,
      'transactionId': transactionId,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      status: AppointmentStatus.values.firstWhere((e) => e.name == json['status']),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == (json['paymentStatus'] ?? 'unpaid')),
      dateTime: DateTime.parse(json['dateTime']),
      reason: json['reason'],
      notes: json['notes'],
      amount: (json['amount'] ?? 500.0).toDouble(),
      transactionId: json['transactionId'],
    );
  }

  Appointment copyWith({
    AppointmentStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? dateTime,
    String? notes,
    String? reason,
    double? amount,
    String? transactionId,
  }) {
    return Appointment(
      id: id,
      patientId: patientId,
      doctorId: doctorId,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      dateTime: dateTime ?? this.dateTime,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
