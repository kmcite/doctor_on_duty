import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/ui/cases/diagnoses_bloc.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

class DiagnosesPage extends UI {
  static const path = '/diagnoses_page';
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Diagnoses'.text(),
        prefixActions: [
          FButton.icon(
            onPress: navigator.back,
            child: FIcon(FAssets.icons.arrowLeft),
          ),
        ],
        suffixActions: [
          // FButton.icon(
          //   onPress: () => navigator.toNamed(SearchDiagnosisPage.path),
          //   child: Icon(Icons.search),
          // ),
        ],
      ),
      content:
          //  diagnosesBlocRM.state.loading
          //     ? CircularProgressIndicator().center()
          //     :
          RefreshIndicator(
        onRefresh: diagnosesBlocRM.state.diagnosesRM.refresh,
        child: ListView.builder(
          itemCount: diagnosesBlocRM.state.diagnoses.length,
          itemBuilder: (context, index) {
            final diagnosis = diagnosesBlocRM.state.diagnoses[index];
            return FButton(
              label: diagnosis.name.toString().text(),
              onPress: () {
                // navigator.toNamed(
                //   DiagnosisPage.path,
                //   arguments: diagnosis,
                // );
              },
            )
                // .pad( 8)
                ;
          },
        ),
      ),
      footer: FButton(
        onPress: () {
          // navigator.toNamed(
          //   EditDiagnosisPage.path,
          //   arguments: Diagnosis(),
          // );
        },
        label: 'Add Diagnosis'.text(),
      ).pad(),
    );
  }
}
