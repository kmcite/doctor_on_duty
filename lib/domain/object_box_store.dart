import 'package:doctor_on_duty/domain/api/duties.dart';
import 'package:doctor_on_duty/domain/store.dart';
import 'package:doctor_on_duty/objectbox.g.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

void objectBoxStoreMW(dynamic action) async {
  if (action is StoreIsLoading) {
    final path = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: join(
        path.path,
        (await PackageInfo.fromPlatform()).packageName,
      ),
    );
    await Future.delayed(Duration(seconds: 1));
    apply(
      ObjectBoxStoreIsLoaded(store),
    );

    /// Subscribe to duties
    apply(SubscribeToDuties());
  }
  if (action is ObjectBoxMutation) {
    action();
  }
}

class StoreIsLoading {}

class ObjectBoxStoreIsLoaded {
  final Store store;
  const ObjectBoxStoreIsLoaded(this.store);
}

/// store/actions

abstract class ObjectBoxMutation {
  void call();
}

class Put<M> implements ObjectBoxMutation {
  final M any;
  const Put(this.any);
  @override
  void call() {
    store.state.store.box<M>().put(any);
  }
}

class Remove<T> implements ObjectBoxMutation {
  final int id;
  const Remove(this.id);
  @override
  void call() {
    store.state.store.box<T>().remove(id);
  }
}

class RemoveAll<T> implements ObjectBoxMutation {
  const RemoveAll();
  @override
  void call() {
    store.state.store.box<T>().removeAll();
  }
}
