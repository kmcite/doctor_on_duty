import 'dart:developer';

import 'package:doctor_on_duty/domain/api/duties.dart';
import 'package:doctor_on_duty/domain/navigation.dart';
import 'package:doctor_on_duty/domain/object_box_store.dart';
import 'package:doctor_on_duty/domain/state_tree.dart';
import 'package:redux/redux.dart';

final store = Store<StateTree>(
  stateTree,
  initialState: StateTree(),
  middleware: [
    (store, action, next) {
      next(action);

      /// LOGGER
      log(action.runtimeType.toString());

      /// middlewares
      navigationMW(action);
      objectBoxStoreMW(action);
      dutiesMW(action);
    },
  ],
);

void apply(dynamic action) {
  store.dispatch(action);
}
