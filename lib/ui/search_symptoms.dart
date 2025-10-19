import 'package:doctor_on_duty/domain/api/navigator.dart';
import 'package:doctor_on_duty/domain/api/symptoms_repository.dart';
import 'package:doctor_on_duty/domain/models/symptom.dart';
import 'package:doctor_on_duty/main.dart';

final symptomSearchQueryRM = RM.inject(() => '');

Iterable<Symptom> get searchedSymptoms {
  return symptomsRepository.getAll().where(
    (symptom) {
      return symptom.name.contains(symptomSearchQueryRM.state);
    },
  );
}

class SearchSymptomPage extends StatelessWidget {
  static const path = '/search_symptom_page';

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
          titleAlignment: Alignment.centerRight,
          title: FTextField(
              // leading: BackButton(),
              // onChanged: (value) => symptomSearchQueryRM.state = value,
              ),
          // leadingWidth: double.maxFinite,
          prefixes: [
            FButton.icon(
              onPress: () {
                navigator.back();
              },
              child: Icon(FIcons.x),
            ),
          ]),
      child: ListView.builder(
        itemCount: searchedSymptoms.length,
        itemBuilder: (context, index) {
          final symptom = searchedSymptoms.elementAt(index);
          return ListTile(
            title: Text(symptom.name),
            onTap: () {
              // navigator.toNamed(
              //   SymptomPage.path,
              //   arguments: symptom,
              // );
            },
          );
        },
      ),
    );
  }
}
