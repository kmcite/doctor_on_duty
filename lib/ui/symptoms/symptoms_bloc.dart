import 'dart:convert';

import 'package:doctor_on_duty/domain/api/symptoms_repository.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../domain/models/symptom.dart';

class SymptomsBloc {
  final symptomsRM = RM.injectFuture<List<Symptom>>(
    () => symptomsRepositoryRM.state.getAll(),
    initialState: <Symptom>[],
    persist: () => PersistState(
      key: 'symptoms',
      toJson: (listOfSymptoms) {
        return jsonEncode(
          listOfSymptoms.map(
            (symptoms) {
              return symptoms.toJson();
            },
          ).toList(),
        );
      },
      fromJson: (json) {
        return (jsonDecode(json) as List).map(
          (data) {
            return Symptom.fromJson(data);
          },
        ).toList();
      },
    ),
  );
  List<Symptom> get symptoms => symptomsRM.state;

  Future<void> put(Symptom symptom) async {
    await symptomsRM.setState(
      (_) async {
        await symptomsRepositoryRM.state.put(symptom);
        return await symptomsRepositoryRM.state.getAll();
      },
    );
  }
}

final symptomsBlocRM = RM.inject(() => SymptomsBloc());
