import 'dart:convert';

import 'package:doctor_on_duty/domain/api/diagnoses_repository.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../domain/models/diagnosis.dart';

class DiagnosesBloc {
  final diagnosesRM = RM.injectFuture<List<Diagnosis>>(
    () => diagnosesRepositoryRM.state.getAll(),
    initialState: <Diagnosis>[],
    persist: () => PersistState(
      key: 'diagnoses',
      toJson: (listOfDiagnosis) {
        return jsonEncode(
          listOfDiagnosis.map(
            (diagnosis) {
              return diagnosis.toJson();
            },
          ).toList(),
        );
      },
      fromJson: (json) {
        return (jsonDecode(json) as List).map(
          (data) {
            return Diagnosis.fromJson(data);
          },
        ).toList();
      },
    ),
  );
  List<Diagnosis> get diagnoses => diagnosesRM.state;
  bool get loading => diagnosesRM.isWaiting;

  Future<void> put(Diagnosis diagnosis) async {
    await diagnosesRM.setState(
      (_) async {
        await diagnosesRepositoryRM.state.put(diagnosis);
        return await diagnosesRepositoryRM.state.getAll();
      },
    );
  }
}

final diagnosesBlocRM = RM.inject(() => DiagnosesBloc());
