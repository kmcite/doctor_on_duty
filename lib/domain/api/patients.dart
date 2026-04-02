import 'package:doctor_on_duty/domain/models/patient_file.dart';

class Patients {
  List<Patient> patients = [];
  Iterable<Patient> get emergencies {
    return patients.where((item) => item.type == 'emergency');
  }

  Iterable<Patient> get opd => patients.where((item) => item.type == 'opd');

  Iterable<Patient> get today {
    final now = DateTime.now();
    return patients.where(
      (medicalCase) {
        final duty = medicalCase.duty.target;
        if (duty != null) {
          return duty.date.year == now.year &&
              duty.date.month == now.month &&
              duty.date.day == now.day;
        }
        return false;
      },
    );
  }

  Iterable<Patient> get todayEmergency {
    return today.where((caze) => caze.type == 'emergency');
  }

  Iterable<Patient> get todayOPD {
    return today.where((caze) => caze.type == 'opd');
  }

  Patient? getById(int caseId) {
    return patients.where((caze) => caze.id == caseId).firstOrNull;
  }
}

Patients patients(Patients state, action) {
  return state;
}

class PatientsAction {}
