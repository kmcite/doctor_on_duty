import 'dart:async';

final settingsRepository = SettingsRepository();

class SettingsRepository extends Repository<bool> {
  SettingsRepository() {}
  @override
  bool get initialValue => true;
}

abstract class Repository<T> {
  Repository() {
    _value = initialValue;
    controller.add(_value);
  }
  late T _value;
  T get value => _value;
  T get initialValue;

  final controller = StreamController<T>.broadcast();

  Stream<T> call([T? value]) {
    if (value != null) {
      controller.add(value);
      _value = value;
    }
    return controller.stream;
  }
}
