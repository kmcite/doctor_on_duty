import 'package:objectbox/objectbox.dart';
import 'package:doctor_on_duty/utils/model.dart';

@Entity()
class Patient extends Model {
  @override
  @Id()
  int id = 0;

  // Patient identifiers
  String patientName = '';
  int age = 0;
  String gender = '';

  // Clinical presentation
  String symptoms = '';
  String signs = '';
  String vitals = '';
  String history = '';
  String examination = '';

  // Diagnosis
  String provisionalDiagnosis = '';
  String finalDiagnosis = '';
  String type = 'emergency'; // or opd
  String category = 'general'; // or special

  // Management
  String status = 'open'; // open, ongoing, discharged, critical
  String treatmentPlan = '';
  String progressNotes = '';
  String outcome = '';

  // Link back to Duty
  final duty = ToOne<Duty>();

  Patient();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'age': age,
      'gender': gender,
      'symptoms': symptoms,
      'signs': signs,
      'vitals': vitals,
      'history': history,
      'examination': examination,
      'provisionalDiagnosis': provisionalDiagnosis,
      'finalDiagnosis': finalDiagnosis,
      'type': type,
      'category': category,
      'status': status,
      'treatmentPlan': treatmentPlan,
      'progressNotes': progressNotes,
      'outcome': outcome,
    };
  }

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    patientName = json['patientName'] ?? '';
    age = json['age'] ?? 0;
    gender = json['gender'] ?? '';
    symptoms = json['symptoms'] ?? '';
    signs = json['signs'] ?? '';
    vitals = json['vitals'] ?? '';
    history = json['history'] ?? '';
    examination = json['examination'] ?? '';
    provisionalDiagnosis = json['provisionalDiagnosis'] ?? '';
    finalDiagnosis = json['finalDiagnosis'] ?? '';
    type = json['type'] ?? 'emergency';
    category = json['category'] ?? 'general';
    status = json['status'] ?? 'open';
    treatmentPlan = json['treatmentPlan'] ?? '';
    progressNotes = json['progressNotes'] ?? '';
    outcome = json['outcome'] ?? '';
  }
}

@Entity()
class Duty extends Model {
  @override
  @Id()
  int id = 0;

  DateTime date = DateTime.now(); // e.g. 2025-12-21
  DateTime? startTime; // When the duty started
  DateTime? endTime; // When the duty ended
  String notes = ''; // optional notes
  bool get isEnded => endTime != null;

  // One Duty → Many Cases
  final cases = ToMany<Patient>();

  Duty({
    DateTime? date,
    this.startTime,
    this.endTime,
  }) : date = date ?? DateTime.now();
}
