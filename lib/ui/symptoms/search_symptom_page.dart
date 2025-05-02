import 'package:doctor_on_duty/domain/models/symptom.dart';
import 'package:doctor_on_duty/main.dart';

import 'symptoms_bloc.dart';

final symptomSearchQueryRM = RM.inject(() => '');

List<Symptom> get searchedSymptoms {
  return symptomsBlocRM.state.symptoms.where(
    (symptom) {
      return symptom.name.contains(symptomSearchQueryRM.state);
    },
  ).toList();
}

class SearchSymptomPage extends UI {
  static const path = '/search_symptom_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SearchBar(
          leading: BackButton(),
          onChanged: (value) => symptomSearchQueryRM.state = value,
        ).pad(),
        leadingWidth: double.maxFinite,
      ),
      body: ListView.builder(
        itemCount: searchedSymptoms.length,
        itemBuilder: (context, index) {
          final symptom = searchedSymptoms[index];
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
