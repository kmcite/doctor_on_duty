import 'package:doctor_on_duty/domain/api/medical_cases.dart';

import 'package:doctor_on_duty/domain/navigation.dart';

import 'package:doctor_on_duty/domain/models/medical_case.dart';

import 'package:doctor_on_duty/main.dart';

import 'package:doctor_on_duty/ui/ui.dart';

import 'package:yaru/widgets.dart';

class CaseDeletionDialog extends UI {
  MedicalCase? get medicalCase => medicalCases.get(caseId)!;

  final int caseId;

  const CaseDeletionDialog({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Case'),

      actions: [
        if (!medicalCases.loading)
          FilledButton(
            onPressed: () => apply(NavigateBack()),

            child: Text('CANCEL'),
          ),

        ElevatedButton(
          onPressed: medicalCases.loading
              ? null
              : () => medicalCases
                    .remove(caseId)
                    .then((_) => apply(NavigateBack())),

          child: medicalCases.loading
              ? YaruCircularProgressIndicator()
              : Text('DELETE'),
        ),
      ],
    );
  }
}
