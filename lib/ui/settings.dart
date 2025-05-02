import 'dart:async';

import 'package:doctor_on_duty/domain/api/settings_repository.dart';
import 'package:doctor_on_duty/main.dart';

import '../domain/api/navigator.dart';

class ToggleDarkModeEvent {}

final _settingsBloc = SettingsBloc();

class SettingsBloc extends Bloc<ToggleDarkModeEvent, bool> {
  SettingsBloc() {
    on<ToggleDarkModeEvent>(
      (_) => settingsRepository(!state),
    );
    _subscription = settingsRepository().listen(emit);
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  StreamSubscription? _subscription;
  bool get initialState => settingsRepository.value;
}

class SettingsPage extends UI {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Settings'.text(),
        prefixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.x),
            onPress: navigator.back,
          ),
        ],
      ),
      content: ListView(
        children: [
          FButton(
            label: FIcon(
              _settingsBloc() ? FAssets.icons.moon : FAssets.icons.sun,
              size: 50,
            ),
            onPress: () => _settingsBloc(ToggleDarkModeEvent()),
          ),
        ],
      ),
    );
  }
}
