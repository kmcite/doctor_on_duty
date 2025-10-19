import 'dart:async';

import 'package:doctor_on_duty/utils/services.dart';
import 'package:objectbox/objectbox.dart';

final repositories = <Type, Repository>{};

void repository<T extends Repository>(T instance) {
  repositories[T] = instance;
}

abstract class Repository<T> {
  final controller = StreamController<void>.broadcast();
  Stream<void> get watch => controller.stream;

  void notifyListeners() {
    controller.add(null);
  }

  S serve<S>() {
    final instance = services[S];
    if (instance is! S) {
      throw Exception('$S not found. please inject using service($S())');
    } else {
      return instance;
    }
  }
}

class CrudRepository<M> extends Repository<M> with CRUD<M> {}

mixin CRUD<M> on Repository<M> {
  late final store = serve<Store>();
  late final box = store.box<M>();

  late final getAll = box.getAll;
  late final put = box.put;
  late final get = box.get;
  late final remove = box.remove;
  late final removeAll = box.removeAll;
  late final count = box.count;
}
