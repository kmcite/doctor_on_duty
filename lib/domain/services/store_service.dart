import 'package:doctor_on_duty/domain/models/model.dart';
import 'package:doctor_on_duty/objectbox.g.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class StoreService {
  Store? store;
  bool isReady = false;
  Future<void>? _initFuture;

  /// Opens a single ObjectBox [Store] for this app (one per isolate).
  Future<void> init() {
    if (store != null) {
      return Future.value();
    }
    return _initFuture ??= _openStore();
  }

  Future<void> _openStore() async {
    final path = await getApplicationDocumentsDirectory();
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    store = await openStore(
      directory: join(path.path, packageName),
    );
    isReady = true;
  }

  int put<T>(T entity) {
    return store!.box<T>().put(entity);
  }

  void remove<T>(int id) {
    store?.box<T>().remove(id);
  }

  void removeAll<T>() {
    store?.box<T>().removeAll();
  }

  Stream<List<T>> watchAll<T extends Model>() async* {
    yield [];
    await init();
    yield* store!
        .box<T>()
        .query()
        .watch(triggerImmediately: true)
        .map((q) => q.find());
  }
}
