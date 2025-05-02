import 'package:doctor_on_duty/main.dart';
import 'package:objectbox/objectbox.dart';

abstract class Repository<T extends Model> extends CRUD<T> {
  Stream<List<T>> watchAll() =>
      crud.query().watch(triggerImmediately: true).map(
        (query) {
          return query.find();
        },
      );
  Stream<T?> watch(int id) {
    return watchAll().map(
      (anys) {
        return anys.where(
          (any) {
            return any.id == id;
          },
        ).firstOrNull;
      },
    );
  }

  List<T> getAll() => crud.getAll();
  T? get(int id) {
    return getAll().where(
      (any) {
        return any.id == id;
      },
    ).firstOrNull;
  }

  void put(T any) => crud.put(any);
  void remove(int id) => crud.remove(id);
  void clear() => crud.removeAll();
}

class CRUD<T> {
  Box<T> get crud => store.box<T>();
}

abstract class Model {
  int get id;
  set id(int value);
}
