import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

class EditDiagnosisPage extends StatelessWidget {
  static const path = '/edit_diagnosis_page';

  @override
  Widget build(BuildContext context) {
    final diagnosis = context.routeData.arguments as Diagnosis;
    return FScaffold(
      header: FHeader(
        title: 'New Diagnosis'.text(),
        suffixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(Icons.arrow_back),
          ),
          FButton.icon(
            onPress: () {
              // navigator.back().then(
              //   (_) {
              //     return navigator.back().then(
              //       (_) {
              //         return diagnosesBlocRM.state.put(diagnosis);
              //       },
              //     );
              //   },
              // );
            },
            child: Icon(Icons.done),
          ),
        ],
      ),
      child: Column(
        children: [
          FTextField(
            label: 'Name'.text(),
            initialText: diagnosis.name,
            onChange: (value) {
              diagnosis..name = value;
            },
            maxLength: Diagnosis.nameLength,
          ).pad(),
          FTextField(
            label: 'Symptoms'.text(),
            initialText: diagnosis.symptoms,
            onChange: (value) {
              diagnosis..symptoms = value;
            },
            maxLines: null,
            maxLength: Diagnosis.symptomsLength,
          ).pad(),
          FTextField(
            label: 'Examination'.text(),
            initialText: diagnosis.examination,
            onChange: (value) {
              diagnosis..examination = value;
            },
            maxLines: null,
            maxLength: Diagnosis.examinationLength,
          ).pad(),
          FTextField(
            label: 'Description'.text(),
            initialText: diagnosis.description,
            onChange: (value) {
              diagnosis..description = value;
            },
            maxLines: null,
            maxLength: Diagnosis.descriptionLength,
          ).pad(),
          FTextField(
            label: 'Investigations'.text(),
            initialText: diagnosis.investigations,
            onChange: (value) {
              diagnosis..investigations = value;
            },
            maxLines: null,
            maxLength: Diagnosis.investigationsLength,
          ).pad(),
          FTextField(
            label: 'differentials'.text(),
            initialText: diagnosis.differentials,
            onChange: (value) {
              diagnosis..differentials = value;
            },
            maxLines: null,
            maxLength: Diagnosis.differentialsLength,
          ).pad(),
        ],
      ),
    );
  }
}
