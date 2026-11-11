import 'dart:async';

import 'package:doctor_on_duty/domain/models/patient.dart';
import 'package:doctor_on_duty/domain/services/store_service.dart';
import 'package:flutter/foundation.dart';

class PatientsRepository extends ChangeNotifier {
  PatientsRepository(this._store) {
    _subscription = _store.watchAll<Patient>().listen((patients) {
      _patients = List<Patient>.from(patients);
      notifyListeners();
    });
  }

  final StoreService _store;
  StreamSubscription<List<Patient>>? _subscription;
  List<Patient> _patients = [];

  List<Patient> get patients => List<Patient>.unmodifiable(_patients);

  int countForDuty(int dutyId) =>
      _patients.where((p) => p.duty.targetId == dutyId).length;

  void remove(int id) => _store.remove<Patient>(id);

  void save(Patient patient) => _store.put(patient);

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
