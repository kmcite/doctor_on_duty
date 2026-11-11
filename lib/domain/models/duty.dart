import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:objectbox/objectbox.dart';

import 'model.dart';

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

  /// Cases linked via [Patient.duty].
  @Backlink('duty')
  final cases = ToMany<Patient>();

  Duty({
    DateTime? date,
    this.startTime,
    this.endTime,
  }) : date = date ?? DateTime.now();
}
