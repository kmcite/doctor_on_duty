import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/cases/diagnoses_bloc.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

final diagnosisSearchQueryRM = RM.inject(() => '');

List<Diagnosis> get searchedDiagnoses {
  return diagnosesBlocRM.state.diagnoses.where(
    (diagnosis) {
      return diagnosis.name.contains(diagnosisSearchQueryRM.state);
    },
  ).toList();
}

class SearchDiagnosisPage extends UI {
  static const path = '/search_diagnosis_page';

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: 'Search Diagnoses'.text(),
        actions: [
          FButton.icon(
            onPress: () {
              navigator.back();
            },
            child: FIcon(FAssets.icons.arrowLeft),
          ),
        ],
      ),
      content: Column(
        children: [
          FTextField(
            label: 'Search'.text(),
            onChange: (value) => diagnosisSearchQueryRM.state = value,
            maxLines: 1,
          ).pad(
              // vertical: 8
              ),
          Expanded(
            child: ListView.builder(
              itemCount: searchedDiagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = searchedDiagnoses[index];
                return FButton(
                  label: Text(diagnosis.name),
                  onPress: () {
                    // navigator.toNamed(
                    //   DiagnosisPage.path,
                    //   arguments: diagnosis,
                    // );
                  },
                ).pad(
                    // vertical: 8
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
