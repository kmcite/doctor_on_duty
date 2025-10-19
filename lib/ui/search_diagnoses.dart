import 'package:doctor_on_duty/domain/api/diagnoses_repository.dart';
import 'package:doctor_on_duty/domain/models/diagnosis.dart';
import 'package:doctor_on_duty/main.dart';
import 'package:doctor_on_duty/domain/api/navigator.dart';

class SearchDiagnosisPage extends StatefulWidget {
  @override
  State<SearchDiagnosisPage> createState() => _SearchDiagnosisPageState();
}

class _SearchDiagnosisPageState extends State<SearchDiagnosisPage> {
  late DiagnosesRepository diagnosesRepository = watch();

  String diagnosisSearchQuery = '';
  void changeSearchQuery(String query) {
    diagnosisSearchQuery = query;
    rebuild();
  }

  Iterable<Diagnosis> get searchedDiagnoses {
    return diagnosesRepository.getAll().where(
      (diagnosis) {
        return diagnosis.name.contains(diagnosisSearchQuery);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Search Diagnoses'.text(),
        prefixes: [
          FButton.icon(
            onPress: () {
              navigator.back();
            },
            child: Icon(FIcons.x),
          ),
        ],
      ),
      child: Column(
        children: [
          FTextField(
            label: 'Search'.text(),
            onChange: changeSearchQuery,
            maxLines: 1,
          ).pad(),
          Expanded(
            child: ListView.builder(
              itemCount: searchedDiagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = searchedDiagnoses.elementAt(index);
                return FButton(
                  child: Text(diagnosis.name),
                  onPress: () {
                    // navigator.toNamed(
                    //   DiagnosisPage.path,
                    //   arguments: diagnosis,
                    // );
                  },
                ).pad();
              },
            ),
          ),
        ],
      ),
    );
  }
}
