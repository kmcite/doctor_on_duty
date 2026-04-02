import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/patients/patient_tile.dart';
import 'package:doctor_on_duty/ui/medical_case_details.dart';
import 'package:doctor_on_duty/ui/ui.dart';
import 'package:forui/forui.dart';

class EmergencyPatients extends UI {
  const EmergencyPatients({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Text('ER'),
        suffixes: [
          FHeaderAction.x(onPress: () => apply(NavigateBack())),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        children: List.generate(
          state.patients.emergencies.length,
          (index) {
            final patient = state.patients.emergencies.elementAt(index);
            return PatientTile(
              patient: patient,
              onTap: () => apply(
                NavigateTo(
                  (context) => PatientDetailsScreen(patientId: patient.id),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
