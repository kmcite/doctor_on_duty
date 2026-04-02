import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/patients/patient_tile.dart';
import 'package:doctor_on_duty/ui/medical_case_details.dart';
import 'package:doctor_on_duty/ui/ui.dart';

class OpdPatients extends UI {
  const OpdPatients({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        state.patients.opd.length,
        (index) {
          final patient = state.patients.opd.elementAt(index);
          return PatientTile(
            patient: patient,
            onTap: () => apply(
              NavigateTo(
                (_) => PatientDetailsScreen(patientId: patient.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
