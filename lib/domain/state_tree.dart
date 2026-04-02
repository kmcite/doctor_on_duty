import 'package:doctor_on_duty/domain/api/duties.dart';
import 'package:doctor_on_duty/domain/api/patients.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/objectbox.g.dart';
import 'package:doctor_on_duty/domain/dark.dart';

class StateTree {
  bool dark = false;
  bool isStoreWaiting = false;

  /// DUTIES
  Duties duties = Duties();

  /// PATIENTS
  Patients patients = Patients();

  ///

  Store? _store;

  Store get store {
    if (_store != null) {
      return _store!;
    } else {
      return throw Exception(
        'ObjectBox is not initialized',
      );
    }
  }
}

StateTree stateTree(StateTree state, action) {
  return switch (action) {
    ToggleDarkMode() => state..dark = !state.dark,
    StoreIsLoading() => state..isStoreWaiting = true,
    DutiesAction() => state..duties = duties(state.duties, action),
    PatientsAction() => state..patients = patients(state.patients, action),
    ObjectBoxStoreIsLoaded() =>
      state
        ..isStoreWaiting = false
        .._store = action.store,
    _ => state,
  };
}
