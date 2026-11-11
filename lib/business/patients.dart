import 'package:doctor_on_duty/domain/case_workflow.dart';
import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/domain/repositories/patients_repository.dart';
import 'package:flutter/foundation.dart';

class PatientsController extends ChangeNotifier {
  PatientsController(this._repository) {
    _repository.addListener(_onRepoChanged);
  }

  final PatientsRepository _repository;

  List<Patient> get patients => _repository.patients;

  Iterable<Patient> get today {
    final now = DateTime.now();
    return patients.where((p) => _isSameDay(p.arrivedAt, now));
  }

  Patient? byId(int caseId) {
    for (final caze in patients) {
      if (caze.id == caseId) return caze;
    }
    return null;
  }

  void removePatient(int id) => _repository.remove(id);

  /// Marks case [id] complete when management is recorded.
  bool tryCompleteCase(int id) {
    final patient = byId(id);
    if (patient == null || patient.isCaseComplete) return false;
    if (patient.managementDocument.trim().isEmpty) return false;
    patient.caseStatus = CaseWorkflow.complete;
    _repository.save(patient);
    return true;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _onRepoChanged() => notifyListeners();

  @override
  void dispose() {
    _repository.removeListener(_onRepoChanged);
    super.dispose();
  }
}
