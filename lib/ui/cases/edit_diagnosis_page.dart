import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

class EditDiagnosisPage extends UI {
  static const path = '/edit_diagnosis_page';

  @override
  Widget build(BuildContext context) {
    final diagnosis = context.routeData.arguments as Diagnosis;
    return FScaffold(
      header: FHeader(
        title: 'New Diagnosis'.text(),
        actions: [
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
      content: Column(
        children: [
          FTextField(
            label: 'Name'.text(),
            initialValue: diagnosis.name,
            onChange: (value) {
              diagnosis..name = value;
            },
            maxLength: Diagnosis.nameLength,
          ).pad(),
          FTextField(
            label: 'Symptoms'.text(),
            initialValue: diagnosis.symptoms,
            onChange: (value) {
              diagnosis..symptoms = value;
            },
            maxLines: null,
            maxLength: Diagnosis.symptomsLength,
          ).pad(),
          FTextField(
            label: 'Examination'.text(),
            initialValue: diagnosis.examination,
            onChange: (value) {
              diagnosis..examination = value;
            },
            maxLines: null,
            maxLength: Diagnosis.examinationLength,
          ).pad(),
          FTextField(
            label: 'Description'.text(),
            initialValue: diagnosis.description,
            onChange: (value) {
              diagnosis..description = value;
            },
            maxLines: null,
            maxLength: Diagnosis.descriptionLength,
          ).pad(),
          FTextField(
            label: 'Investigations'.text(),
            initialValue: diagnosis.investigations,
            onChange: (value) {
              diagnosis..investigations = value;
            },
            maxLines: null,
            maxLength: Diagnosis.investigationsLength,
          ).pad(),
          FTextField(
            label: 'differentials'.text(),
            initialValue: diagnosis.differentials,
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
