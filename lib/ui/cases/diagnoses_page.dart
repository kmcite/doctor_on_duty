import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

List<Diagnosis> get diagnoses => [];

class DiagnosesPage extends StatelessWidget {
  static const path = '/diagnoses_page';
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Diagnoses'.text(),
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.arrowLeft),
          ),
        ],
        suffixes: [
          // FButton.icon(
          //   onPress: () => navigator.toNamed(SearchDiagnosisPage.path),
          //   child: Icon(Icons.search),
          // ),
        ],
      ),
      child:
          //  diagnosesBlocRM.state.loading
          //     ? CircularProgressIndicator().center()
          //     :
          RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: diagnoses.length,
          itemBuilder: (context, index) {
            final diagnosis = diagnoses[index];
            return FButton(
              child: diagnosis.name.toString().text(),
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
        child: 'Add Diagnosis'.text(),
      ).pad(),
    );
  }
}
